# AutoHide Task View v1.2  (2025-10-09)
# Author: espsev
# Purpose: Event-driven auto-hide of Task View button based on desktop count

# Uninstall-AutoHideTaskView.ps1
# Removes the scheduled task and installed files.
[CmdletBinding()]
param(
    [string]$InstallDir = "$env:LOCALAPPDATA\AutoHideTaskView",
    [string]$TaskName = "AutoHide Task View"
)

$ErrorActionPreference = 'Continue'

# Remove scheduled task
try {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction Stop | Out-Null
} catch {
    Write-Verbose "Unregister-ScheduledTask failed, trying schtasks: $_"
    & schtasks /Delete /TN "$TaskName" /F | Out-Null
}

# Signal running instance to stop (best-effort)
try {
    $stopEventName = 'Local\\AutoHideTaskView-Stop'
    $stopEvent = [System.Threading.EventWaitHandle]::OpenExisting($stopEventName)
    if ($stopEvent) { $stopEvent.Set() | Out-Null }
} catch { }

# As an additional safety, terminate processes that are running this script (best-effort)
try {
    Get-CimInstance Win32_Process -Filter "Name='powershell.exe' OR Name='pwsh.exe'" |
        Where-Object { $_.CommandLine -match 'AutoHide_TaskView\.ps1' } |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
} catch { }

# Remove files
try {
    if (Test-Path $InstallDir) {
        Remove-Item -Path $InstallDir -Recurse -Force -ErrorAction Stop
    }
} catch {
    Write-Warning "Could not remove $InstallDir: $_"
}

Write-Host "Uninstalled AutoHide Task View."
