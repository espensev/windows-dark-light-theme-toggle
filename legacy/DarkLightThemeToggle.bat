@echo off
REM Batch wrapper for DarkLightThemeToggle utility
REM This runs the latest version (V3) of the PowerShell script

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1" %*
pause