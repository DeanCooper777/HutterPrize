<#
.SYNOPSIS
  Windows build of fx2-cmix-T (Hutter Prize record holder, Jul 2026).

.DESCRIPTION
  Mirrors fx2-cmix-T/makefile + build_and_construct_comp.sh using a portable
  LLVM clang (tools\llvm) against the MSVC headers/libs:

    1. (optional) PGO instrumented build, trained on prof_input/input
    2. optimized build              -> build\cmix_orig.exe  (plain cmix: -c/-d/-n ...)
    3. self-extracting compressor   -> build\run\cmix.exe   (enwik9-only: -e)

  Output files are NOT bit-compatible with the Linux reference build (different
  compiler / libm), but compress/decompress round-trips with themselves.

.PARAMETER NoPgo       Skip the profile-guided pass (faster build, ~10-20% slower binary).
.PARAMETER Native      -march=native instead of the portable x86-64-v3 baseline.
.PARAMETER SkipConstruct  Do not build the self-extracting run\cmix.exe (that step
                          runs the model over ~1.5MB of data and takes several minutes).
#>

# build.ps1 -- Windows development build. New in this entry.
#
# Where it fits: the Hutter Prize submission is the Linux build made by
# fx2-cmix-T/makefile + fx2-cmix-T/build_and_construct_comp.sh. This script
# repeats the same steps with a portable clang on Windows so the code can be
# developed, tuned and round-trip tested (test.ps1) on a Windows laptop. Its
# binaries are never submitted.
#
# Same as the Linux build:
#   - the three source groups and their flags: "fast" (-O3, -ffp-model=fast),
#     "slow" (-Os: preprocessor, dictionary), transformer objects (-O3, strict
#     IEEE floating point, no PGO/LTO);
#   - the default instruction set x86-64-v3 and -mrecip=none;
#   - profile-guided optimization with prof_input/input, then LTO;
#   - the layout of the self-extracting compressor: executable, compressed
#     dictionary, compressed article order, transformer weights, 16-byte
#     trailer written by "cmix -h".
# Different from the Linux build:
#   - src/win_compat.h is force-included (POSIX calls mapped to Windows);
#   - no -DFX2_NO_VNNI: the AVX-VNNI / AVX512-VNNI matmul kernels stay in and
#     are selected at run time (bit-identical results, faster development
#     runs). The Linux makefile compiles them out to stay AVX2-only;
#   - no executable packer, no size-only flags, and no disassembly checks
#     (AVX2-only, reciprocal estimates): those belong to the submission;
#   - -Defines reaches every source group, including the transformer objects
#     (the makefile's CFLAGS_DEFINES does not). Used for experiment builds
#     such as CMIX_PROFILE, FX2_PROF, CMIX_PIPE or CMIX_OFFICIAL, usually with
#     -OutName so the normal binary is kept.
#
# Testing: .\test.ps1 runs the binaries built here.

param(
  [switch]$NoPgo,
  [switch]$Native,
  [switch]$SkipConstruct,
  [int]$Seed = 923,
  [int]$UpdateLimit = 3000,
  [string[]]$Defines = @(),          # extra -D macros, e.g. -Defines CMIX_PROFILE
  [string]$OutName = 'cmix_orig.exe', # output name in build\ (experiments use their own name)
  [switch]$ReusePgo                   # reuse build\pgo_data\default.profdata instead of re-profiling
)
$ErrorActionPreference = 'Continue'   # PS 5.1 turns native stderr into errors under 'Stop'; exit codes are checked explicitly

$Root   = $PSScriptRoot
$Src    = Join-Path $Root 'fx2-cmix-T'
$Llvm   = Join-Path $Root 'tools\llvm\bin'
$Clang  = Join-Path $Llvm 'clang++.exe'
$Prof   = Join-Path $Llvm 'llvm-profdata.exe'
$Build  = Join-Path $Root 'build'
$ObjDir = Join-Path $Build 'obj'
$PgoDir = Join-Path $Build 'pgo_data'

if (-not (Test-Path $Clang)) { throw "clang not found at $Clang (see README.md for the LLVM download)" }

# ---------------------------------------------------------------- flags
# Instruction set: x86-64-v3 (AVX2, FMA, F16C, BMI2) as in the submission, or
# the build machine's own with -Native (development only, not portable).
$arch = if ($Native) { @('-march=native', '-mtune=native') } else { @('-march=x86-64-v3', '-mtune=generic') }
$arch += '-mrecip=none'   # see makefile: keeps FP results vendor-independent

# $common goes to every compile: C++17, quiet MSVC CRT warnings, the Windows
# compatibility header, the two compile-time constants and any -Defines.
$common = @('-m64', '-std=c++17', '-D_CRT_SECURE_NO_WARNINGS', '-D_CRT_NONSTDC_NO_DEPRECATE',
            '-include', 'src/win_compat.h',
            "-DSEED=$Seed", "-DUPDATE_LIMIT=$UpdateLimit") + ($Defines | ForEach-Object { "-D$_" })
$warn   = @('-Wall', '-Wno-unknown-escape-sequence', '-Wno-unused-variable',
            '-Wno-unneeded-internal-declaration', '-Wno-unused-but-set-variable', '-Wno-format',
            '-Wno-deprecated-declarations', '-Wno-unused-function', '-Wno-sign-compare',
            '-Wno-microsoft-include', '-Wno-unused-private-field', '-Wno-c++11-narrowing')
# cmix proper: fast floating point; one section per function/object so the
# linker can drop unreferenced ones (/OPT:REF below).
$cmixBase = $common + $warn + $arch + @('-ffp-model=fast', '-fno-threadsafe-statics',
            '-fdata-sections', '-ffunction-sections')
$fastFlags = $cmixBase + '-O3'
$slowFlags = $cmixBase + '-Os'
# transformer: bit-exact IEEE arithmetic, no PGO/LTO (as in the makefile)
$tfFlags   = $common + $arch + @('-O3', '-Wall', '-fno-math-errno', '-fdata-sections', '-ffunction-sections')

# "fast" group: everything on the per-bit path (coder, contexts, models,
# PPMD, mixers, SSE, predictor, runner). Same list as the makefile.
$fastSrc = @(
  'src/coder/decoder.cpp','src/coder/encoder.cpp','src/context-manager.cpp',
  'src/contexts/bit-context.cpp','src/contexts/bracket-context.cpp','src/contexts/combined-context.cpp',
  'src/contexts/context-hash.cpp','src/contexts/indirect-hash.cpp','src/contexts/interval-hash.cpp',
  'src/contexts/interval.cpp','src/contexts/sparse.cpp','src/models/bracket.cpp','src/models/byte-model.cpp',
  'src/models/direct-hash.cpp','src/models/direct.cpp','src/models/indirect.cpp','src/models/match.cpp',
  'src/models/fxcmv1.cpp','src/models/ppmd.cpp','src/states/nonstationary.cpp','src/states/run-map.cpp',
  'src/mixer/byte-mixer.cpp','src/mixer/mixer-input.cpp','src/mixer/mixer.cpp','src/mixer/sigmoid.cpp',
  'src/mixer/sse.cpp','src/predictor.cpp','src/runner.cpp')
# "slow" group: runs once per file, compiled for size.
$slowSrc = @('src/preprocess/preprocessor.cpp','src/preprocess/dictionary.cpp')
# Transformer byte model (cpp_infer). os = $true compiles that file with -Os
# instead of -O3 (load-time code). act16.cpp is the 16-bit activation kernels.
$tfSrc = @(
  @{ src='cpp_infer/src/weights_io.cpp';            obj='tf_weights_io';            os=$false },
  @{ src='cpp_infer/src/weights_io_compressed.cpp'; obj='tf_weights_io_compressed'; os=$true  },
  @{ src='cpp_infer/src/opt/qmat_dense.cpp';        obj='tf_qmat_dense';            os=$false },
  @{ src='cpp_infer/src/opt/qmat_sparse.cpp';       obj='tf_qmat_sparse';           os=$false },
  @{ src='cpp_infer/src/opt/attn.cpp';              obj='tf_attn';                  os=$false },
  @{ src='cpp_infer/src/opt/kda.cpp';               obj='tf_kda';                   os=$false },
  @{ src='cpp_infer/src/opt/glue.cpp';              obj='tf_glue';                  os=$false },
  @{ src='cpp_infer/src/opt/arena_build.cpp';       obj='tf_arena_build';           os=$false },
  @{ src='cpp_infer/src/opt/act16.cpp';             obj='tf_act16';                 os=$false },
  @{ src='cpp_infer/src/opt/model_opt.cpp';         obj='tf_model_opt';             os=$false })

# ---------------------------------------------------------------- helpers
# Runs the compile jobs, as many at once as there are logical processors.
# Each job's stderr goes to build\obj\<name>.log; if any job fails, the first
# error lines of each failed log are shown and the build stops.
function Invoke-Parallel([object[]]$jobs) {
  # $jobs: array of @{ name; args }. Runs up to N clang processes at once.
  $max = [Environment]::ProcessorCount
  $running = @()
  $failed = @()
  $queue = [System.Collections.Queue]::new($jobs)
  while ($queue.Count -or $running.Count) {
    while ($queue.Count -and $running.Count -lt $max) {
      $j = $queue.Dequeue()
      $log = Join-Path $ObjDir ($j.name + '.log')
      $quoted = ($j.args | ForEach-Object { if ($_ -match '\s') { '"' + $_ + '"' } else { $_ } }) -join ' '
      $psi = [Diagnostics.ProcessStartInfo]::new($Clang, $quoted)
      $psi.UseShellExecute = $false
      $psi.RedirectStandardError = $true
      $psi.WorkingDirectory = $Src
      $p = [Diagnostics.Process]::Start($psi)
      $err = $p.StandardError.ReadToEndAsync()
      $running += [pscustomobject]@{ p = $p; j = $j; log = $log; err = $err }
    }
    Start-Sleep -Milliseconds 200
    $still = @()
    foreach ($r in $running) {
      if ($r.p.HasExited) {
        $r.p.WaitForExit()
        [IO.File]::WriteAllText($r.log, $r.err.Result)
        if ($r.p.ExitCode -ne 0) { $failed += $r }
        else { Write-Host "  compiled $($r.j.name)" }
      } else { $still += $r }
    }
    $running = $still
  }
  if ($failed) {
    foreach ($f in $failed) {
      Write-Host "---- $($f.j.name) FAILED" -ForegroundColor Red
      Get-Content $f.log | Select-String -Pattern 'error' -Context 0,3 | Select-Object -First 15 | Out-String | Write-Host
    }
    throw "compilation failed"
  }
}

# One complete build into $outExe: wipes build\obj, compiles the three groups
# and links with lld. $extraCmix is added to the fast and slow groups only
# (PGO/LTO flags; the transformer objects never get them), $extraLink to the
# link line.
function Build-Cmix([string[]]$extraCmix, [string[]]$extraLink, [string]$outExe) {
  Remove-Item -Recurse -Force $ObjDir -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force $ObjDir | Out-Null
  $jobs = @()
  foreach ($s in $fastSrc) {
    $o = Join-Path $ObjDir ([IO.Path]::GetFileNameWithoutExtension($s) + '.o')
    $jobs += @{ name = [IO.Path]::GetFileName($s); args = $fastFlags + $extraCmix + @('-c', $s, '-o', $o) }
  }
  foreach ($s in $slowSrc) {
    $o = Join-Path $ObjDir ([IO.Path]::GetFileNameWithoutExtension($s) + '.o')
    $jobs += @{ name = [IO.Path]::GetFileName($s); args = $slowFlags + $extraCmix + @('-c', $s, '-o', $o) }
  }
  foreach ($t in $tfSrc) {
    $f = if ($t.os) { ($tfFlags | Where-Object { $_ -ne '-O3' }) + '-Os' } else { $tfFlags }
    $jobs += @{ name = $t.obj; args = $f + @('-c', $t.src, '-o', (Join-Path $ObjDir ($t.obj + '.o'))) }
  }
  Invoke-Parallel $jobs
  $objs = Get-ChildItem $ObjDir -Filter *.o | ForEach-Object FullName
  # Linux default stack is 8MB vs 1MB on Windows: reserve 64MB to be safe.
  $link = @('-fuse-ld=lld', '-Wl,/OPT:REF', '-Wl,/STACK:67108864') + $extraLink + $objs + @('-o', $outExe)
  Write-Host "  linking $outExe"
  & $Clang @link
  if ($LASTEXITCODE -ne 0) { throw "link failed" }
}

New-Item -ItemType Directory -Force $Build | Out-Null
$sw = [Diagnostics.Stopwatch]::StartNew()

# ---------------------------------------------------------------- PGO
# Three cases:
#   default    instrumented build -> training run -> merge profile -> final build
#   -ReusePgo  skip the first three steps and use the existing default.profdata
#              (for experiment builds; the profile may be slightly stale, hence
#              the -Wno-profile-instr-* flags below)
#   -NoPgo     no profile and no LTO at all
$useFlags = @(); $useLink = @()
$haveProfile = Test-Path "$PgoDir\default.profdata"
if ($ReusePgo -and -not $haveProfile) { throw "-ReusePgo: $PgoDir\default.profdata not found" }
if (-not $NoPgo -and -not $ReusePgo) {
  Write-Host "== PGO instrumented build" -ForegroundColor Cyan
  Remove-Item -Recurse -Force $PgoDir -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force $PgoDir | Out-Null
  $gen = "-fprofile-generate=$PgoDir"
  $instr = Join-Path $Build 'cmix_instr.exe'
  Build-Cmix @($gen) @($gen) $instr
  # The instrumented binary compresses the sample in a scratch directory; on
  # exit it writes *.profraw files into $PgoDir, which are merged below.
  Write-Host "== PGO training run (prof_input/input)" -ForegroundColor Cyan
  $tmp = Join-Path $Build 'pgo_tmp'
  New-Item -ItemType Directory -Force $tmp | Out-Null
  Push-Location $tmp
  try {
    & $instr -c (Join-Path $Src 'prof_input\input') prof_comp | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "PGO training run failed" }
  } finally { Pop-Location }
  Remove-Item -Recurse -Force $tmp
  & $Prof merge -output="$PgoDir\default.profdata" (Get-ChildItem $PgoDir -Filter *.profraw | ForEach-Object FullName)
  if ($LASTEXITCODE -ne 0) { throw "llvm-profdata merge failed" }
  Remove-Item $instr
}
if (-not $NoPgo) {
  $useFlags = @("-fprofile-use=$PgoDir\default.profdata", '-flto', '-Wno-profile-instr-unprofiled', '-Wno-profile-instr-out-of-date', '-Wno-backend-plugin')
  $useLink  = @('-flto')
}

# The build that is kept: build\<OutName> (cmix_orig.exe unless -OutName).
Write-Host "== optimized build" -ForegroundColor Cyan
$orig = Join-Path $Build $OutName
Build-Cmix $useFlags $useLink $orig
Write-Host ("built {0} ({1:N0} bytes)" -f $orig, (Get-Item $orig).Length) -ForegroundColor Green

# ---------------------------------------------------------------- self-extracting compressor
# Same assembly as the end of build_and_construct_comp.sh, without packing:
#   run\cmix.exe = cmix_orig.exe + comp_dict + comp_order + comp_tfweights
#                  + header.dat
# The dictionary and the article order are compressed by cmix itself (-c); the
# weights file is already compressed and is appended as it is; "cmix -h"
# writes header.dat, the trailer with the sizes of the appended parts (the 0
# is the size of the compressed enwik9, which only the archive has).
# "cmix.exe -e enwik9 out" then writes the self-extracting archive9.exe.
if (-not $SkipConstruct) {
  Write-Host "== constructing self-extracting run\cmix.exe (compresses dictionary + article order; takes a few minutes)" -ForegroundColor Cyan
  $run = Join-Path $Build 'run'
  New-Item -ItemType Directory -Force $run | Out-Null
  Push-Location $run
  try {
    Copy-Item $orig .\cmix_orig.exe -Force
    & .\cmix_orig.exe -c (Join-Path $Src 'dictionary\english.dic') comp_dict
    if ($LASTEXITCODE -ne 0) { throw "dictionary compression failed" }
    & .\cmix_orig.exe -c (Join-Path $Src 'src\readalike_prepr\data\new_article_order') comp_order
    if ($LASTEXITCODE -ne 0) { throw "article-order compression failed" }
    Copy-Item (Join-Path $Src 'models\6m-q4-fp32.tfwc2') comp_tfweights -Force
    & .\cmix_orig.exe -h (Get-Item comp_dict).Length (Get-Item comp_order).Length 0 (Get-Item comp_tfweights).Length
    if ($LASTEXITCODE -ne 0) { throw "header creation failed" }
    $out = [IO.File]::Create((Join-Path $run 'cmix.exe'))
    foreach ($part in 'cmix_orig.exe','comp_dict','comp_order','comp_tfweights','header.dat') {
      $in = [IO.File]::OpenRead((Join-Path $run $part)); $in.CopyTo($out); $in.Close()
    }
    $out.Close()
  } finally { Pop-Location }
  Write-Host ("built {0} ({1:N0} bytes)" -f (Join-Path $run 'cmix.exe'), (Get-Item (Join-Path $run 'cmix.exe')).Length) -ForegroundColor Green
}
Write-Host ("done in {0:N1} min" -f $sw.Elapsed.TotalMinutes)
