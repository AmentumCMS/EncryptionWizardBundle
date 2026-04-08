# em-win
Encryption Wizard bundling repo for windows that includes a launch4j exe launcher, JRE, and installer

## Features

- Windows installer (Inno Setup) with per-user and system-wide installation options
- Portable ZIP archive with bundled JRE
- Launch4j-generated EXE with embedded JAR
- Desktop shortcut creation utilities for easy access
- File type associations for `.wza`, `.wzd`, and `.wzk` files

## Desktop Shortcut Creation

The bundle includes three utilities to create a desktop shortcut that uses the bundled JRE to launch Encryption Wizard:

- `Create_Desktop_Shortcut.bat` - Batch file (recommended for most users)
- `Create_Desktop_Shortcut.ps1` - PowerShell script
- `Create_Desktop_Shortcut.vbs` - VBScript

Simply double-click any of these files to create a shortcut on your desktop. See `SHORTCUT_CREATION_README.md` for detailed instructions.

## Build Process

The CI/CD workflows automatically:
1. Download and configure a minimal JRE using jlink
2. Build the EXE with Launch4j (embeds the JAR)
3. Create the installer with Inno Setup
4. Package a portable ZIP archive with all necessary files
