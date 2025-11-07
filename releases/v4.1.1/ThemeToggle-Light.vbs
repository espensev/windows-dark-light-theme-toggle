' ============================================================================
' ThemeToggle - Force Light Mode (Silent)
' ============================================================================
' Purpose: Silently switch to Light theme
' Usage:
'   - Double-click to force Light mode silently
'   - Assign to hotkey for instant Light theme
'   - Use in scheduled tasks for morning automation
' ============================================================================

Option Explicit

' Configuration
Const TOGGLE_EXE = "ThemeToggle.exe"
Const WINDOW_HIDDEN = 0
Const DONT_WAIT = False

' Get the directory where this VBS script is located
Dim fso, scriptDir, exePath
Set fso = CreateObject("Scripting.FileSystemObject")
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
exePath = fso.BuildPath(scriptDir, TOGGLE_EXE)

' Verify ThemeToggle.exe exists
If Not fso.FileExists(exePath) Then
    ' Show error only if exe not found (critical failure)
    WScript.Echo "Error: ThemeToggle.exe not found in:" & vbCrLf & scriptDir
    WScript.Quit 1
End If

' Create shell object and run silently with /light flag
Dim shell
Set shell = CreateObject("WScript.Shell")

' Run ThemeToggle.exe with /light and /quiet flags, hidden window
shell.Run """" & exePath & """ /light /quiet", WINDOW_HIDDEN, DONT_WAIT

' Clean up
Set shell = Nothing
Set fso = Nothing

' Exit silently
WScript.Quit 0
