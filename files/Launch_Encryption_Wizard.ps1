# PowerShell launcher for Encryption Wizard using the bundled JRE
# This script launches the Encryption Wizard JAR file using the local JRE
# located in the jre/ subdirectory.
#
# Usage: Right-click and select "Run with PowerShell"
#        or from PowerShell: .\Launch_Encryption_Wizard.ps1 [arguments]
#
# This script expects to find:
#   - jre\bin\java.exe (bundled Java Runtime)
#   - EW-Unified-4.0.005-FIPS.jar (the application JAR)

# Get the directory where this script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define paths
$javaExe = Join-Path $scriptDir "jre\bin\java.exe"
$jarFile = Join-Path $scriptDir "EW-Unified-4.0.005-FIPS.jar"

# Check if the bundled JRE exists
if (-not (Test-Path $javaExe)) {
    Write-Host "ERROR: Bundled JRE not found!" -ForegroundColor Red
    Write-Host "Expected location: $javaExe"
    Write-Host ""
    Write-Host "Please ensure the jre directory is in the same location as this script."
    Write-Host ""
    Write-Host "Press any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Check if the JAR file exists
if (-not (Test-Path $jarFile)) {
    Write-Host "ERROR: Encryption Wizard JAR file not found!" -ForegroundColor Red
    Write-Host "Expected location: $jarFile"
    Write-Host ""
    Write-Host "Please ensure EW-Unified-4.0.005-FIPS.jar is in the same location as this script."
    Write-Host ""
    Write-Host "Press any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Launch the application with the bundled JRE
# Pass all command line arguments to the application
Write-Host "Launching Encryption Wizard..." -ForegroundColor Green
Write-Host ""

$arguments = @("-jar", $jarFile) + $args
$process = Start-Process -FilePath $javaExe -ArgumentList $arguments -Wait -NoNewWindow -PassThru

# Check exit code
if ($process.ExitCode -ne 0) {
    Write-Host ""
    Write-Host "Encryption Wizard exited with code: $($process.ExitCode)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit $process.ExitCode
}

exit 0
