' VBScript wrapper for DarkLightThemeToggle utility (Legacy - V2)
' This provides silent execution of the PowerShell script
' For latest version, use ToggleTheme_V3.vbs

Set sh = CreateObject("Wscript.Shell")
sh.Run "powershell.exe -NoProfile -NoLogo -ExecutionPolicy Bypass -File ""DarkLightThemeToggle_V2 - Copy.ps1"" -Quiet", 0, False