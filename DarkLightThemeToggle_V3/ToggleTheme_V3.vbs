' VBScript wrapper for DarkLightThemeToggle utility (V3 - Latest)
' This provides silent execution of the PowerShell script
' Runs the latest V3 version with enhanced features

Set sh = CreateObject("Wscript.Shell")
sh.Run "powershell.exe -NoProfile -NoLogo -ExecutionPolicy Bypass -File ""DarkLightThemeToggle_V3.ps1"" -Quiet", 0, False