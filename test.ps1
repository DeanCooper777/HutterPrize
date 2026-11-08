<#
.SYNOPSIS
  Round-trip test of fx2-cmix-T on the enwik test files.

.DESCRIPTION
  For each requested size, compresses data\enwikN with build\cmix_orig.exe,
  decompresses it again, verifies the result byte-for-byte, and appends the
  results (size, bits/char, times, peak RAM) to results.csv.

  The enwik9-only "-e" mode (article reordering + phda9 preprocessing + the
  self-extracting archive) is hard-coded to the full enwik9 line layout, so the
  partial files use the generic mode with the same dictionary and transformer:
      cmix_orig.exe --transformer <weights> -c english.dic <in> <out>
  Use -Enwik9 to run the real contest pipeline on the full file instead (~50h+).

  Measured speed (Core Ultra 9 288V): ~4.5 KB/s, i.e. enwik5 ~35 s,
  enwik6 ~3.7 min, enwik7 ~40 min, enwik8 ~6-7 h (each way).

.EXAMPLE
  .\test.ps1                      # enwik5, enwik6
  .\test.ps1 -Sizes 7             # enwik7 only
  .\test.ps1 -Sizes 6 -NoTransformer   # use the LSTM mixer input instead
  .\test.ps1 -Enwik9              # full contest run with build\run\cmix.exe
#>
param(
  [int[]]$Sizes = @(5, 6),
  [switch]$NoTransformer,
  [switch]$NoDictionary,
  [switch]$SkipDecompress,
  [switch]$Enwik9
)
$ErrorActionPreference = 'Stop'
$Root    = $PSScriptRoot
$Src     = Join-Path $Root 'fx2-cmix-T'
$Exe     = Join-Path $Root 'build\cmix_orig.exe'
$Dict    = Join-Path $Src 'dictionary\english.dic'
$Weights = Join-Path $Src 'models\6m-q4-fp32.tfwc2'
$Csv     = Join-Path $Root 'results.csv'

function Invoke-Measured([string]$exe, [string[]]$argv, [string]$cwd) {
  $psi = [Diagnostics.ProcessStartInfo]::new($exe, (($argv | ForEach-Object { '"' + $_ + '"' }) -join ' '))
  $psi.UseShellExecute = $false
  $psi.WorkingDirectory = $cwd
  $sw = [Diagnostics.Stopwatch]::StartNew()
  $p = [Diagnostics.Process]::Start($psi)
  $peak = 0L
  while (-not $p.WaitForExit(1000)) {
    try { $p.Refresh(); $peak = [Math]::Max($peak, $p.PeakWorkingSet64) } catch {}
  }
  $p.WaitForExit()
  [pscustomobject]@{ Seconds = $sw.Elapsed.TotalSeconds; PeakMB = [int]($peak / 1MB); ExitCode = $p.ExitCode }
}

function Test-SameFile([string]$a, [string]$b) {
  if (-not (Test-Path $b)) { return $false }
  if ((Get-Item $a).Length -ne (Get-Item $b).Length) { return $false }
  (Get-FileHash $a -Algorithm SHA256).Hash -eq (Get-FileHash $b -Algorithm SHA256).Hash
}

function Add-Result($row) {
  $row | Export-Csv -Path $Csv -Append -NoTypeInformation
  $row | Format-List | Out-String | Write-Host
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

if ($Enwik9) {
  # ------------------------------------------------------------ real contest pipeline
  $cmix = Join-Path $Root 'build\run\cmix.exe'
  if (-not (Test-Path $cmix)) { throw "$cmix not found - run .\build.ps1 (without -SkipConstruct)" }
  $work = Join-Path $Root "runs\enwik9-$stamp"
  New-Item -ItemType Directory -Force "$work\comp", "$work\decomp" | Out-Null
  Copy-Item $cmix "$work\comp\cmix.exe"
  # the compressor reads enwik9 by path; a hard link avoids copying 1GB
  cmd /c mklink /H "$work\comp\enwik9" (Join-Path $Root 'enwik9') | Out-Null
  Write-Host "== compressing enwik9 in $work\comp (this takes ~2-3 days)" -ForegroundColor Cyan
  $c = Invoke-Measured "$work\comp\cmix.exe" @('-e', 'enwik9', 'enwik9.comp') "$work\comp"
  if ($c.ExitCode -ne 0) { throw "compression failed ($($c.ExitCode))" }
  $arch = Get-Item "$work\comp\archive9.exe"
  $s1 = (Get-Item $cmix).Length
  Copy-Item $arch.FullName "$work\decomp\archive9.exe"
  $d = $null; $ok = ''
  if (-not $SkipDecompress) {
    Write-Host "== decompressing in $work\decomp" -ForegroundColor Cyan
    $d = Invoke-Measured "$work\decomp\archive9.exe" @() "$work\decomp"
    $ok = Test-SameFile (Join-Path $Root 'enwik9') "$work\decomp\enwik9_uncompressed"
  }
  Add-Result ([pscustomobject]@{
    Date = $stamp; File = 'enwik9'; Mode = 'contest -e'; InputBytes = 1000000000
    CompressedBytes = $arch.Length; TotalWithCompressor = $s1 + $arch.Length
    BitsPerChar = [math]::Round(8.0 * $arch.Length / 1e9, 4)
    CompSec = [int]$c.Seconds; DecompSec = if ($d) { [int]$d.Seconds } else { '' }
    CompPeakMB = $c.PeakMB; DecompPeakMB = if ($d) { $d.PeakMB } else { '' }; Verified = $ok })
  return
}

# ---------------------------------------------------------------- partial files
if (-not (Test-Path $Exe)) { throw "$Exe not found - run .\build.ps1 first" }
$dictArg = if ($NoDictionary) { @() } else { @($Dict) }

foreach ($n in $Sizes) {
  $in = Join-Path $Root "data\enwik$n"
  if (-not (Test-Path $in)) { throw "$in not found - run: python scripts\split_enwik9.py" }
  # The transformer needs the fixed 205-byte enwik9 vocabulary, which cmix
  # only stores for inputs of >= 10,000 preprocessed bytes; enwik4 is smaller.
  $useTf = -not $NoTransformer -and (Get-Item $in).Length -gt 20000
  if (-not $NoTransformer -and -not $useTf) { Write-Warning "enwik${n} is too small for the transformer; using the LSTM" }
  $opts  = if ($useTf) { @('--transformer', $Weights) } else { @() }
  $mode = @(if ($useTf) { 'transformer' } else { 'lstm' }; if ($NoDictionary) { 'nodict' } else { 'dict' }) -join '+'
  $work = Join-Path $Root "runs\enwik$n-$mode-$stamp"
  New-Item -ItemType Directory -Force $work | Out-Null
  $comp = Join-Path $work "enwik$n.cmix"
  $out  = Join-Path $work "enwik$n.out"

  Write-Host "== enwik$n ($mode): compressing" -ForegroundColor Cyan
  $c = Invoke-Measured $Exe ($opts + @('-c') + $dictArg + @($in, $comp)) $work
  if ($c.ExitCode -ne 0) { throw "compression of enwik$n failed (exit $($c.ExitCode))" }
  $csize = (Get-Item $comp).Length

  $d = $null; $ok = ''
  if (-not $SkipDecompress) {
    Write-Host "`n== enwik$n ($mode): decompressing" -ForegroundColor Cyan
    $d = Invoke-Measured $Exe ($opts + @('-d') + $dictArg + @($comp, $out)) $work
    $ok = ($d.ExitCode -eq 0) -and (Test-SameFile $in $out)
    if ($ok) { Remove-Item $out }
  }
  $isize = (Get-Item $in).Length
  Add-Result ([pscustomobject]@{
    Date = $stamp; File = "enwik$n"; Mode = $mode; InputBytes = $isize
    CompressedBytes = $csize; TotalWithCompressor = ''
    BitsPerChar = [math]::Round(8.0 * $csize / $isize, 4)
    CompSec = [math]::Round($c.Seconds, 1); DecompSec = if ($d) { [math]::Round($d.Seconds, 1) } else { '' }
    CompPeakMB = $c.PeakMB; DecompPeakMB = if ($d) { $d.PeakMB } else { '' }; Verified = $ok })
  if ($ok -eq $false) { throw "enwik${n}: decompressed output does NOT match the input" }
}
