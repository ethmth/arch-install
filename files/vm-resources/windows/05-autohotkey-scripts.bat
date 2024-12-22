@echo off
set "StartupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "LocalPath=autohotkey"
set "ScriptPath=%USERPROFILE%\Documents\autohotkey"
set "ScriptFile=pushtotalk.ahk"
set "ShortcutName=pushtotalk.lnk"
 
:: Ensure the directory exists before copying
:: if not exist "%ScriptPath%" mkdir "%ScriptPath%"
 
:: Copy the AutoHotkey script using PowerShell
powershell -Command "Copy-Item -Path '%LocalPath%' -Destination '%ScriptPath%' -Recurse"
 
:: Ensure the script exists before creating a shortcut
if not exist "%ScriptPath%\%ScriptFile%" (
            echo Script not found at "%ScriptPath%\%ScriptFile%". Aborting.
                pause
                    exit /b
            )
 
            :: Create shortcut using PowerShell (single-line)
            powershell -Command "$WScriptShell = New-Object -ComObject WScript.Shell; $Shortcut = $WScriptShell.CreateShortcut('%StartupFolder%\\%ShortcutName%'); $Shortcut.TargetPath = '%ScriptPath%\\%ScriptFile%'; $Shortcut.WorkingDirectory = '%ScriptPath%'; $Shortcut.Arguments = ''; $Shortcut.Save();"
 
            echo Shortcut created at %StartupFolder%\%ShortcutName%
            pause
 
