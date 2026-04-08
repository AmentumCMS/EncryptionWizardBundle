@echo off
REM Batch file to create a Windows desktop shortcut for Encryption Wizard
REM This file uses PowerShell to create the shortcut since batch files cannot
REM directly create .lnk files.
REM
REM Usage: Double-click this file to create a desktop shortcut

setlocal

echo Creating Encryption Wizard desktop shortcut...
echo.

REM Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

REM Remove trailing backslash
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Use PowerShell to create the shortcut
powershell -ExecutionPolicy Bypass -NoProfile -Command ^
    "$scriptDir = '%SCRIPT_DIR%'; ^
    $jarFile = Join-Path $scriptDir 'EW-Unified-4.0.005-FIPS.jar'; ^
    $javaExe = Join-Path $scriptDir 'jre\bin\javaw.exe'; ^
    $exeFile = Join-Path $scriptDir 'EncryptionWizard.exe'; ^
    $workingDir = $scriptDir; ^
    $desktopPath = [Environment]::GetFolderPath('Desktop'); ^
    $shortcutPath = Join-Path $desktopPath 'Encryption Wizard.lnk'; ^
    $shell = New-Object -ComObject WScript.Shell; ^
    $shortcut = $shell.CreateShortcut($shortcutPath); ^
    if (Test-Path $exeFile) { ^
        $shortcut.TargetPath = $exeFile; ^
        $shortcut.IconLocation = \"$exeFile,0\"; ^
        $shortcut.Description = 'Encryption Wizard - FIPS-compliant encryption application'; ^
        Write-Host 'Using EncryptionWizard.exe launcher' -ForegroundColor Green; ^
    } elseif ((Test-Path $javaExe) -and (Test-Path $jarFile)) { ^
        $shortcut.TargetPath = $javaExe; ^
        $shortcut.Arguments = \"-jar `\"$jarFile`\"\"; ^
        $shortcut.Description = 'Encryption Wizard - FIPS-compliant encryption application'; ^
        $shortcut.IconLocation = \"$jarFile,0\"; ^
        Write-Host 'Using bundled JRE to launch JAR' -ForegroundColor Green; ^
    } else { ^
        Write-Host 'ERROR: Required files not found!' -ForegroundColor Red; ^
        Write-Host 'Expected either: EncryptionWizard.exe OR (jre\bin\javaw.exe + EW-Unified-4.0.005-FIPS.jar)'; ^
        exit 1; ^
    } ^
    $shortcut.WorkingDirectory = $workingDir; ^
    $shortcut.WindowStyle = 1; ^
    $shortcut.Save(); ^
    Write-Host ''; ^
    Write-Host 'Desktop shortcut created successfully!' -ForegroundColor Green; ^
    Write-Host \"Shortcut location: $shortcutPath\"""

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Success! A shortcut has been created on your desktop.
) else (
    echo.
    echo Failed to create shortcut. See error message above.
)

echo.
echo Press any key to continue...
pause >nul

endlocal
