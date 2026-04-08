' VBScript launcher for Encryption Wizard using the bundled JRE
' This script launches the Encryption Wizard JAR file using the local JRE
' located in the jre/ subdirectory.
'
' Usage: Double-click this file or run: wscript Launch_Encryption_Wizard.vbs
'
' This script expects to find:
'   - jre\bin\javaw.exe (bundled Java Runtime - GUI mode)
'   - EW-Unified-4.0.005-FIPS.jar (the application JAR)

Option Explicit

Dim objShell, objFSO
Dim strScriptDir, strJavaExe, strJarFile
Dim intResult

' Create shell and file system objects
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get the directory where this script is located
strScriptDir = objFSO.GetParentFolderName(WScript.ScriptFullName)

' Define paths - use javaw.exe for GUI mode (no console window)
strJavaExe = objFSO.BuildPath(strScriptDir, "jre\bin\javaw.exe")
strJarFile = objFSO.BuildPath(strScriptDir, "EW-Unified-4.0.005-FIPS.jar")

' Check if the bundled JRE exists
If Not objFSO.FileExists(strJavaExe) Then
    WScript.Echo "ERROR: Bundled JRE not found!" & vbCrLf & vbCrLf & _
                 "Expected location: " & strJavaExe & vbCrLf & vbCrLf & _
                 "Please ensure the jre directory is in the same location as this script."
    WScript.Quit 1
End If

' Check if the JAR file exists
If Not objFSO.FileExists(strJarFile) Then
    WScript.Echo "ERROR: Encryption Wizard JAR file not found!" & vbCrLf & vbCrLf & _
                 "Expected location: " & strJarFile & vbCrLf & vbCrLf & _
                 "Please ensure EW-Unified-4.0.005-FIPS.jar is in the same location as this script."
    WScript.Quit 1
End If

' Launch the application with the bundled JRE
' Use javaw.exe which doesn't show a console window
' Use Run method with wait parameter to wait for completion
intResult = objShell.Run("""" & strJavaExe & """ -jar """ & strJarFile & """", 1, True)

' Check exit code
If intResult <> 0 Then
    WScript.Echo "Encryption Wizard exited with code: " & intResult
End If

' Cleanup
Set objFSO = Nothing
Set objShell = Nothing

WScript.Quit intResult
