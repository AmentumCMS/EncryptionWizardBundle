@echo off
REM Launcher for Encryption Wizard using the bundled JRE
REM This script launches the Encryption Wizard JAR file using the local JRE
REM located in the jre/ subdirectory.
REM
REM Usage: Double-click this file or run from command line with optional arguments
REM        Launch_Encryption_Wizard.bat [arguments for Encryption Wizard]
REM
REM This script expects to find:
REM   - jre\bin\java.exe (bundled Java Runtime)
REM   - EW-Unified-4.0.005-FIPS.jar (the application JAR)

setlocal enableextensions

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"

REM Remove trailing backslash
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Define paths
set "JAVA_EXE=%SCRIPT_DIR%\jre\bin\java.exe"
set "JAR_FILE=%SCRIPT_DIR%\EW-Unified-4.0.005-FIPS.jar"

REM Check if the bundled JRE exists
if not exist "%JAVA_EXE%" (
    echo ERROR: Bundled JRE not found!
    echo Expected location: %JAVA_EXE%
    echo.
    echo Please ensure the jre directory is in the same location as this script.
    echo.
    pause
    exit /b 1
)

REM Check if the JAR file exists
if not exist "%JAR_FILE%" (
    echo ERROR: Encryption Wizard JAR file not found!
    echo Expected location: %JAR_FILE%
    echo.
    echo Please ensure EW-Unified-4.0.005-FIPS.jar is in the same location as this script.
    echo.
    pause
    exit /b 1
)

REM Launch the application with the bundled JRE
REM Pass all command line arguments to the application
"%JAVA_EXE%" -jar "%JAR_FILE%" %*

REM Capture the exit code
set EXITCODE=%ERRORLEVEL%

REM Pause only if there was an error (non-zero exit code)
if %EXITCODE% neq 0 (
    echo.
    echo Encryption Wizard exited with code: %EXITCODE%
    echo.
    pause
)

endlocal
exit /b %EXITCODE%
