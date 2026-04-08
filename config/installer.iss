; Inno Setup script for Encryption Wizard
; https://jrsoftware.org/isinfo.php
;
; Build with:
;   ISCC.exe /DAppVersion=<version> config\installer.iss
;
; The following items are expected in the working directory when this script
; is compiled:
;   build\EncryptionWizard.exe                           - EXE produced by Launch4j
;   build\icon.ico                                       - Application icon (extracted from JAR)
;   build\splash.bmp                                     - Installer splash image (extracted from JAR)
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
SetupIconFile=..\build\icon.ico
WizardImageFile=..\build\splash.bmp
WizardSmallImageFile=..\build\icon-55x58.bmp

; Notify Windows Shell to refresh file-type icon/association cache
ChangesAssociations=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Main application EXE (launcher for the JAR)
Source: "..\build\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion

; Application JAR file (must be alongside the EXE)
Source: "..\files\EW-Unified-*.jar"; DestDir: "{app}"; Flags: ignoreversion

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

; Application graphics (icon and splash image extracted from JAR)
Source: "..\build\icon.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\splash.png"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}";        Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\{#AppExeName}"
Name: "{group}\Uninstall {#AppName}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\{#AppExeName}"; \
  Tasks: desktopicon
; Send To shortcut - allows right-click "Send to" > "Encryption Wizard"
Name: "{usersendto}\{#AppName}"; Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\{#AppExeName}"; \
  Tasks: sendtoshortcut

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; \
  GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "sendtoshortcut"; Description: "Add to Send To menu (right-click > Send to > Encryption Wizard)"; \
  GroupDescription: "Shell Integration:"; Flags: unchecked
Name: "contextmenu"; Description: "Add right-click context menu options (Encrypt File / Encrypt Directory)"; \
  GroupDescription: "Shell Integration:"; Flags: unchecked

[Run]
Filename: "{app}\{#AppExeName}"; \
  Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; \
  Flags: nowait postinstall skipifsilent

[Registry]
; -----------------------------------------------------------------------
; File type associations
; Registered under HKA so they apply to HKCU for per-user installs and
; HKLM for system-wide installs, matching the installation mode chosen.
;
; Open command for all three types passes the file path as the first
; argument: EncryptionWizard.exe "<filepath>"
; The application detects the file type by extension and presents the
; appropriate Decrypt / Expand / Key-load UI automatically.
; -----------------------------------------------------------------------

; .wza – Encryption Wizard Archive
Root: HKA; Subkey: "Software\Classes\.wza"; \
  ValueType: string; ValueName: ""; ValueData: "EncryptionWizard.Archive"; \
  Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\EncryptionWizard.Archive"; \
  ValueType: string; ValueName: ""; ValueData: "Encryption Wizard Archive"; \
  Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\EncryptionWizard.Archive\DefaultIcon"; \
  ValueType: string; ValueName: ""; ValueData: "{app}\{#AppExeName},0"
Root: HKA; Subkey: "Software\Classes\EncryptionWizard.Archive\shell\open\command"; \
  ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExeName}"" ""%1"""

; .wzd – Encryption Wizard Encrypted File (single file)
Root: HKA; Subkey: "Software\Classes\.wzd"; \
  ValueType: string; ValueName: ""; ValueData: "EncryptionWizard.Document"; \
  Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\EncryptionWizard.Document"; \
  ValueType: string; ValueName: ""; ValueData: "Encryption Wizard Encrypted File"; \
  Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\EncryptionWizard.Document\DefaultIcon"; \
  ValueType: string; ValueName: ""; ValueData: "{app}\{#AppExeName},0"
Root: HKA; Subkey: "Software\Classes\EncryptionWizard.Document\shell\open\command"; \
  ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExeName}"" ""%1"""

; .wzk – Encryption Wizard Password File
Root: HKA; Subkey: "Software\Classes\.wzk"; \
  ValueType: string; ValueName: ""; ValueData: "EncryptionWizard.KeyFile"; \
  Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\EncryptionWizard.KeyFile"; \
  ValueType: string; ValueName: ""; ValueData: "Encryption Wizard Password File"; \
  Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\EncryptionWizard.KeyFile\DefaultIcon"; \
  ValueType: string; ValueName: ""; ValueData: "{app}\{#AppExeName},0"
Root: HKA; Subkey: "Software\Classes\EncryptionWizard.KeyFile\shell\open\command"; \
  ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExeName}"" ""%1"""

; -----------------------------------------------------------------------
; Right-click context menu: "Encrypt File" for all files
; -----------------------------------------------------------------------
Root: HKA; Subkey: "Software\Classes\*\shell\EncryptWithEW"; \
  ValueType: string; ValueName: ""; ValueData: "Encrypt File"; \
  Flags: uninsdeletekey; Tasks: contextmenu
Root: HKA; Subkey: "Software\Classes\*\shell\EncryptWithEW"; \
  ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#AppExeName},0"; \
  Tasks: contextmenu
Root: HKA; Subkey: "Software\Classes\*\shell\EncryptWithEW\command"; \
  ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExeName}"" ""%1"""; \
  Tasks: contextmenu

; -----------------------------------------------------------------------
; Right-click context menu: "Encrypt Directory" for folders
; -----------------------------------------------------------------------
Root: HKA; Subkey: "Software\Classes\Directory\shell\EncryptWithEW"; \
  ValueType: string; ValueName: ""; ValueData: "Encrypt Directory"; \
  Flags: uninsdeletekey; Tasks: contextmenu
Root: HKA; Subkey: "Software\Classes\Directory\shell\EncryptWithEW"; \
  ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#AppExeName},0"; \
  Tasks: contextmenu
Root: HKA; Subkey: "Software\Classes\Directory\shell\EncryptWithEW\command"; \
  ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExeName}"" ""%1"""; \
  Tasks: contextmenu

; Right-click context menu: "Encrypt Directory" for folder backgrounds
Root: HKA; Subkey: "Software\Classes\Directory\Background\shell\EncryptWithEW"; \
  ValueType: string; ValueName: ""; ValueData: "Encrypt Directory"; \
  Flags: uninsdeletekey; Tasks: contextmenu
Root: HKA; Subkey: "Software\Classes\Directory\Background\shell\EncryptWithEW"; \
  ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#AppExeName},0"; \
  Tasks: contextmenu
Root: HKA; Subkey: "Software\Classes\Directory\Background\shell\EncryptWithEW\command"; \
  ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExeName}"" ""%V"""; \
  Tasks: contextmenu
