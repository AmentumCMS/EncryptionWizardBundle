# PowerShell script to create a Windows desktop shortcut for Encryption Wizard
# This script creates a shortcut that uses the bundled JRE to launch the JAR file
#
# Usage: Right-click and select "Run with PowerShell"
#        or from PowerShell: .\Create_Desktop_Shortcut.ps1
#
# The script assumes it is located in the same directory as:
#   - EW-Unified-4.0.005-FIPS.jar
#   - jre\ subdirectory (containing the bundled Java Runtime)

# Get the directory where this script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define paths
$jarFile = Join-Path $scriptDir "EW-Unified-4.0.005-FIPS.jar"
$javaExe = Join-Path $scriptDir "jre\bin\javaw.exe"
$exeFile = Join-Path $scriptDir "EncryptionWizard.exe"
$workingDir = $scriptDir

# Get desktop path
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "Encryption Wizard.lnk"

# Create WScript Shell object for creating shortcuts
$shell = New-Object -ComObject WScript.Shell

# Create the shortcut
$shortcut = $shell.CreateShortcut($shortcutPath)

# Configure shortcut based on what files are available
if (Test-Path $exeFile) {
    # If EncryptionWizard.exe exists, use it (it has embedded JAR and icon)
    $shortcut.TargetPath = $exeFile
    $shortcut.IconLocation = "$exeFile,0"
    $shortcut.Description = "Encryption Wizard - FIPS-compliant encryption application"
    Write-Host "Using EncryptionWizard.exe launcher" -ForegroundColor Green
}
elseif ((Test-Path $javaExe) -and (Test-Path $jarFile)) {
    # Otherwise, use javaw.exe to launch the JAR directly
    $shortcut.TargetPath = $javaExe
    $shortcut.Arguments = "-jar `"$jarFile`""
    $shortcut.Description = "Encryption Wizard - FIPS-compliant encryption application"
    # Try to use the JAR file itself as icon source (some JARs have embedded icons)
    $shortcut.IconLocation = "$jarFile,0"
    Write-Host "Using bundled JRE to launch JAR" -ForegroundColor Green
}
else {
    Write-Host "ERROR: Required files not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Expected either:"
    Write-Host "  - EncryptionWizard.exe"
    Write-Host "OR"
    Write-Host "  - jre\bin\javaw.exe"
    Write-Host "  - EW-Unified-4.0.005-FIPS.jar"
    Write-Host ""
    Write-Host "in directory: $scriptDir"
    exit 1
}

$shortcut.WorkingDirectory = $workingDir
$shortcut.WindowStyle = 1  # Normal window
$shortcut.Save()

Write-Host ""
Write-Host "Desktop shortcut created successfully!" -ForegroundColor Green
Write-Host "Shortcut location: $shortcutPath"
Write-Host ""
if ($Host.UI.RawUI) {
    Write-Host "Press any key to continue..."
    try {
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    } catch {
        Start-Sleep -Seconds 2
    }
}
