# ============================================================================
# ThemeToggle PowerShell Wrapper
# ============================================================================
# Purpose: Cross-platform wrapper for ThemeToggle.exe with better error handling
# Advantages over VBS:
#   - Better error handling and exit codes
#   - Can be used in PowerShell scripts
#   - Supports pipeline and automation
#   - Native PowerShell integration
# ============================================================================

[CmdletBinding()]
param(
    [Parameter(ParameterSetName='Light')]
    [switch]$Light,
    
    [Parameter(ParameterSetName='Dark')]
    [switch]$Dark,
    
    [Parameter(ParameterSetName='Toggle')]
    [switch]$Toggle,
    
    [switch]$ShowWindow,
    [switch]$Quiet,
    [switch]$PassThru,
    [switch]$AsExitCode
)

# Get script directory and exe path
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$exePath = Join-Path $scriptDir "ThemeToggle.exe"

# Verify executable exists
if (-not (Test-Path $exePath)) {
    if (-not $Quiet) {
        Write-Error "ThemeToggle.exe not found in: $scriptDir"
        Write-Host "Please build the project first using build.bat" -ForegroundColor Yellow
    }
    exit 1
}

# Build arguments array
$arguments = @()

# Mode selection
if ($Light) { 
    $arguments += "/light" 
}
elseif ($Dark) { 
    $arguments += "/dark" 
}
else { 
    $arguments += "/toggle"  # Default behavior
}

# Additional flags
if ($Quiet) { 
    $arguments += "/quiet" 
}
if ($PassThru) { 
    $arguments += "/passthru" 
}
if ($AsExitCode) { 
    $arguments += "/exitcode" 
}

# Configure process start info
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $exePath
$psi.Arguments = $arguments -join " "
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true

# Window visibility
if ($ShowWindow) {
    $psi.CreateNoWindow = $false
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Normal
} else {
    $psi.CreateNoWindow = $true
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
}

# Start process and capture output
try {
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi
    
    # Start process
    $null = $process.Start()
    
    # Read output streams
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    
    # Wait for exit
    $process.WaitForExit()
    $exitCode = $process.ExitCode
    
    # Display output if not quiet
    if (-not $Quiet -and $stdout) {
        Write-Host $stdout.TrimEnd()
    }
    
    # Display errors if any
    if ($stderr) {
        Write-Error $stderr.TrimEnd()
    }
    
    # Return exit code
    exit $exitCode
}
catch {
    if (-not $Quiet) {
        Write-Error "Failed to launch ThemeToggle: $_"
    }
    exit 1
}
finally {
    if ($process) {
        $process.Dispose()
    }
}
