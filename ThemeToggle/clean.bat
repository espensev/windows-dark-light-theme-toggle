@echo off
REM Clean all build artifacts and user shortcuts
pushd "%~dp0"

echo Cleaning ThemeToggle directory...
echo.

REM Build artifacts
del *.obj 2>nul
del *.res 2>nul
del ThemeToggle.exe 2>nul

REM User-created shortcuts (careful!)
echo Removing shortcuts...
del *.lnk 2>nul

REM Uninstall scheduled tasks if they exist
echo Removing scheduled tasks...
schtasks /delete /tn "ThemeToggle-Morning" /f >nul 2>&1
schtasks /delete /tn "ThemeToggle-Evening" /f >nul 2>&1

echo.
echo Cleanup complete!
echo.
echo To rebuild: run build.bat
echo To reconfigure: run setup.bat
echo.

popd
pause
