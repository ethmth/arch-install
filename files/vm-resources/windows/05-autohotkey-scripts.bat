@echo off
set "StartupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "LocalPath=autohotkey"
set "ScriptPath=$env:USERPROFILE\Documents\autohotkey"
set "ShortcutName=pushtotalk.lnk"

powershell -Command "Copy-Item -Path '%LocalPath%' -Destination "%ScriptPath%" -Recurse"

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; `
    $Shortcut = $WshShell.CreateShortcut('%StartupFolder%\%ShortcutName%'); `
    $Shortcut.TargetPath = '%ScriptPath%\pushtotalk.ahk'; `
    $Shortcut.Save()"

echo Shortcut created in the Startup folder.

