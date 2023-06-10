@echo off
set url=https://drivers.amd.com/drivers/installer/22.40/whql/amd-software-adrenalin-edition-23.5.2-minimalsetup-230531_web.exe
set output=C:\Users\%USERNAME%\Downloads\amd-software-adrenalin-edition.exe

curl -o "%output%" "%url%"