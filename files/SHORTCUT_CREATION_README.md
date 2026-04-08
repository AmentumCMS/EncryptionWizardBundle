# Creating a Desktop Shortcut for Encryption Wizard

This directory contains several utilities to create a Windows desktop shortcut for Encryption Wizard that uses the bundled JRE to launch the application.

## Quick Start

Simply double-click one of these files to create a desktop shortcut:

- **Create_Desktop_Shortcut.bat** (Recommended - works on all Windows systems)
- **Create_Desktop_Shortcut.vbs** (Alternative method using VBScript)
- **Create_Desktop_Shortcut.ps1** (PowerShell script - may require execution policy changes)

## What the Scripts Do

All three scripts perform the same function:
1. Detect if `EncryptionWizard.exe` exists (created by Launch4j build)
2. If the EXE exists, create a shortcut pointing to it (uses embedded JAR and icon)
3. If the EXE doesn't exist, create a shortcut that uses the bundled JRE to launch the JAR directly
4. Place the shortcut on your Windows desktop

## Icon Support

The shortcuts will attempt to use icons in the following order:
1. **EncryptionWizard.exe** - If the Launch4j-built executable exists, its embedded icon will be used
2. **JAR file** - Some JAR files have embedded icons that Windows can extract
3. **Default Java icon** - If no icon is available, Windows will use the default Java application icon

## Files Required

The scripts expect to find these files in the same directory:
- `EW-Unified-4.0.005-FIPS.jar` - The Encryption Wizard application
- `jre/bin/javaw.exe` - The bundled Java Runtime Environment
- `EncryptionWizard.exe` - (Optional) The Launch4j-built executable with embedded JAR

## Troubleshooting

### PowerShell Execution Policy
If you receive an error about execution policy when running the `.ps1` file:
1. Right-click the PowerShell script and select "Run with PowerShell"
2. Or use the `.bat` file instead, which bypasses this issue
3. Or run this command in PowerShell as Administrator:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

### Missing Files
If you get an error about missing files:
- Ensure you're running the script from the correct directory (where the JAR and JRE are located)
- Check that the `jre` subdirectory exists with the bundled Java Runtime
- Verify that `EW-Unified-4.0.005-FIPS.jar` is present

## Manual Shortcut Creation

If the automated scripts don't work, you can create a shortcut manually:

1. Right-click on your desktop and select "New" → "Shortcut"
2. For the location, enter one of:
   - Path to `EncryptionWizard.exe` (if available)
   - OR: `"C:\path\to\jre\bin\javaw.exe" -jar "C:\path\to\EW-Unified-4.0.005-FIPS.jar"`
3. Name it "Encryption Wizard"
4. Right-click the shortcut → Properties → Change Icon
5. Browse to `EncryptionWizard.exe` or the JAR file to extract the icon

## Additional Information

For more information about Encryption Wizard, see:
- `Getting_Started_with_Encryption_Wizard_4.0.005.txt` - Quick start guide
- `Encryption Wizard User Guide v405.pdf` - Complete user documentation
