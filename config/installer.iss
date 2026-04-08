; Inno Setup script for Encryption Wizard
; https://jrsoftware.org/isinfo.php
;
; Build with:
;   ISCC.exe /DAppVersion=<version> config\installer.iss
;
; The following items are expected in the working directory when this script
; is compiled:
;   build\EncryptionWizard.exe                           - EXE produced by Launch4j
;   jre\                                                 - Bundled JRE (downloaded by CI)
;   files\Encryption Wizard User Guide v405.docx         - User documentation
;   files\Encryption Wizard User Guide v405.pdf          - User documentation (PDF)
;   files\Getting_Started_with_Encryption_Wizard_4.0.005.txt - Quick-start guide
;   files\Drop_Jar_File_Here_For_Fallback_Launch.bat     - Fallback launch helper
;   files\Encryption Wizard homepage.url                 - Homepage shortcut
;
; Installation modes
; ------------------
; This installer supports BOTH per-user and system-wide installation:
;   - Default (no elevation): installs to %LOCALAPPDATA%\Programs\Encryption Wizard
;     for the current user only — no administrator rights required.
;   - Elevated (optional):    installs to %ProgramFiles%\Encryption Wizard
;     for all users — requires administrator rights.
; A dialog is shown during setup so the user can choose which mode they prefer.

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif

#define AppName      "Encryption Wizard"
#define AppPublisher "AmentumCMS"
#define AppURL       "https://github.com/AmentumCMS/em-win"
#define AppExeName   "EncryptionWizard.exe"

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}

; Default installation directory
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}

; Allow non-admin users to install to their own Programs folder
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog

; Output
OutputDir=..\build
OutputBaseFilename=EncryptionWizard-{#AppVersion}-Setup

; Compression
Compression=lzma2/ultra64
SolidCompression=yes

; Require 64-bit Windows
ArchitecturesInstallIn64BitMode=x64compatible
ArchitecturesAllowed=x64compatible

; Minimum Windows version: Windows 10 (10.0)
MinVersion=10.0

; Installer appearance
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Main application EXE (JAR is embedded inside by Launch4j)
Source: "..\build\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion

; Bundled JRE – required at runtime by the EXE launcher
Source: "..\jre\*"; DestDir: "{app}\jre"; \
  Flags: ignoreversion recursesubdirs createallsubdirs

; User documentation
Source: "..\files\Encryption Wizard User Guide v405.docx"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\files\Encryption Wizard User Guide v405.pdf";  DestDir: "{app}"; Flags: ignoreversion

; Quick-start guide
Source: "..\files\Getting_Started_with_Encryption_Wizard_4.0.005.txt"; DestDir: "{app}"; Flags: ignoreversion

; Fallback JAR launcher (for users who already have a JRE in PATH)
Source: "..\files\Drop_Jar_File_Here_For_Fallback_Launch.bat"; DestDir: "{app}"; Flags: ignoreversion

; Homepage shortcut
Source: "..\files\Encryption Wizard homepage.url"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}";        Filename: "{app}\{#AppExeName}"
Name: "{group}\Uninstall {#AppName}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; \
  Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; \
  GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Run]
Filename: "{app}\{#AppExeName}"; \
  Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; \
  Flags: nowait postinstall skipifsilent
