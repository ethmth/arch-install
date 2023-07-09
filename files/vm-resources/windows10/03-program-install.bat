@echo off

set url=https://download.piaproxy.com/file/pc/PIA_S5_Proxy_1.5.5_06051857.exe
set output=C:\Users\%USERNAME%\Downloads\ProxyProvider.exe

curl -o "%output%" "%url%" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:113.0) Gecko/20100101 Firefox/113.0" -H "Connection: keep-alive"

pause