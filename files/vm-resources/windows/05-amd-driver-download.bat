@echo off
set url=https://drivers.amd.com/drivers/installer/22.40/whql/amd-software-adrenalin-edition-23.5.2-minimalsetup-230531_web.exe
set output=C:\Users\%USERNAME%\Downloads\amd-software-adrenalin-edition.exe

curl -o "%output%" "%url%" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:113.0) Gecko/20100101 Firefox/113.0" -H "Connection: keep-alive" -H "Referer: https://www.amd.com/"

pause