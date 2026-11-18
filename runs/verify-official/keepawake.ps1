# Keeps Windows from going to sleep while the WSL verification run is active (the run takes
# about three days). Exits by itself when runs\verify-official\log.txt ends with "done" or when
# the wsl.exe process given by -WslPid has gone.
param([int]$WslPid)
Add-Type -Namespace Win32 -Name Power -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);'
$log = Join-Path $PSScriptRoot 'log.txt'
while ($true) {
  # ES_CONTINUOUS | ES_SYSTEM_REQUIRED: no idle sleep while this process lives
  [void][Win32.Power]::SetThreadExecutionState(0x80000001)
  Start-Sleep -Seconds 60
  if ((Test-Path $log) -and ((Get-Content $log -Tail 1) -match ' done$')) { break }
  if ($WslPid -and -not (Get-Process -Id $WslPid -ErrorAction SilentlyContinue)) { break }
}
[void][Win32.Power]::SetThreadExecutionState(0x80000000)
