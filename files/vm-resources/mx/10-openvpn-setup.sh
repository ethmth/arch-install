#!/bin/bash

if ! [[ $EUID -ne 0 ]]; then
	echo "This script should not be run with root/sudo privileges."
	exit 1
fi

CUR_USER=$(whoami)

if ! [ -e "openvpn/openvpn" ]; then
	echo "Make sure you run this script in the same directory as ./openvpn/openvpn"
	exit 1
fi

mkdir -p /home/$CUR_USER/programs/openvpn/
cp openvpn/docker-compose.yml /home/$CUR_USER/programs/openvpn/docker-compose.yaml

read -p "Please enter your desired hostname (Ex: 10.153.153.15, server.mydomain.com): " hostname

cd /home/$CUR_USER/programs/openvpn

echo "Use same password for everything, leave DN as default (blank)"

docker-compose run --rm openvpn ovpn_genconfig -u udp://$hostname
docker-compose run --rm openvpn ovpn_initpki

sudo chown -R $(whoami): ./openvpn-data

docker-compose up -d openvpn

echo "#!/bin/bash" > check_logs.sh
echo "docker-compose logs -f" >> check_logs.sh
chmod +x check_logs.sh

NUM_CLIENTS=2

for i in $(seq 1 $NUM_CLIENTS);
do
    echo $i
done

export CLIENTNAME="client1"
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

export CLIENTNAME="client2"
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn


# sudo cp openvpn/openvpn /usr/bin/openvpn
# sudo chmod +x /usr/bin/openvpn

# echo "Installed openvpn to bin"
# echo "Running 'wireguard' to start the container"