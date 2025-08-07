@echo off

echo Open powershell admin and run
echo "netsh interface ipv4 set subinterface "Ethernet" mtu=1420 store=persistent"
echo Replacing 1420 with the MTU of your VPN interface, if less than the default of 1500; replace "Ethernet" with your network interface name

echo Run "netsh interface ipv4 show subinterfaces" to confirm the change and view the interfaces

pause