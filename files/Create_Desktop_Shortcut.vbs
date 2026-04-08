' VBScript to create a Windows desktop shortcut for Encryption Wizard
' This script creates a shortcut that uses the bundled JRE to launch the JAR file
'
' Usage: Double-click this file or run: wscript Create_Desktop_Shortcut.vbs
'
' The script assumes it is located in the same directory as:
'   - EW-Unified-4.0.005-FIPS.jar
'   - jre\ subdirectory (containing the bundled Java Runtime)

Option Explicit

Dim objShell, objFSO, objShortcut
Dim strScriptDir, strDesktopPath, strShortcutPath
Dim strJavaExe, strJarFile, strWorkingDir, strIconFile

' Create shell and file system objects
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get the directory where this script is located
strScriptDir = objFSO.GetParentFolderName(WScript.ScriptFullName)

' Define paths
strJarFile = objFSO.BuildPath(strScriptDir, "EW-Unified-4.0.005-FIPS.jar")
strJavaExe = objFSO.BuildPath(strScriptDir, "jre\bin\javaw.exe")
strWorkingDir = strScriptDir

' Check if EncryptionWizard.exe exists (from Launch4j build)
Dim strExeFile
strExeFile = objFSO.BuildPath(strScriptDir, "EncryptionWizard.exe")

' Get desktop path
strDesktopPath = objShell.SpecialFolders("Desktop")
strShortcutPath = objFSO.BuildPath(strDesktopPath, "Encryption Wizard.lnk")

' Create the shortcut
Set objShortcut = objShell.CreateShortcut(strShortcutPath)

' If EncryptionWizard.exe exists, use it (it has embedded JAR and icon)
If objFSO.FileExists(strExeFile) Then
    objShortcut.TargetPath = strExeFile
    objShortcut.IconLocation = strExeFile & ",0"
    objShortcut.Description = "Encryption Wizard - FIPS-compliant encryption application"
' Otherwise, use javaw.exe to launch the JAR directly
ElseIf objFSO.FileExists(strJavaExe) And objFSO.FileExists(strJarFile) Then
    objShortcut.TargetPath = strJavaExe
    objShortcut.Arguments = "-jar """ & strJarFile & """"
    objShortcut.Description = "Encryption Wizard - FIPS-compliant encryption application"
    ' Try to use the JAR file itself as icon source (some JARs have embedded icons)
    objShortcut.IconLocation = strJarFile & ",0"
Else
    WScript.Echo "ERROR: Required files not found!" & vbCrLf & vbCrLf & _
                 "Expected either:" & vbCrLf & _
                 "  - EncryptionWizard.exe" & vbCrLf & _
                 "OR" & vbCrLf & _
                 "  - jre\bin\javaw.exe" & vbCrLf & _
                 "  - EW-Unified-4.0.005-FIPS.jar" & vbCrLf & vbCrLf & _
                 "in directory: " & strScriptDir
    WScript.Quit 1
End If

objShortcut.WorkingDirectory = strWorkingDir
objShortcut.WindowStyle = 1  ' Normal window
objShortcut.Save

' Success message
WScript.Echo "Desktop shortcut created successfully!" & vbCrLf & vbCrLf & _
             "Shortcut location: " & strShortcutPath

' Cleanup
Set objShortcut = Nothing
Set objFSO = Nothing
Set objShell = Nothing
