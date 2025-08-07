@echo off

echo Open powershell admin and run
echo netsh interface ipv4 set subinterface "Ethernet" mtu=1320 store=persistent
echo Replacing 1320 with the MTU of your VPN interface, if less than the default of 1500; replace "Ethernet" with your network interface name

pause