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

hostname=""
read -p "Please enter your desired hostname (Ex: 10.153.153.15, server.mydomain.com): " hostname
# echo -n Password: 
# read -s password
# echo

if [ "$hostname" == "" ]; then
    echo "No hostname specified"
    exit 1
fi


# echo $password

cd /home/$CUR_USER/programs/openvpn

echo "Use same password for everything, leave DN as default (blank)"

# sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | docker-compose run --rm openvpn ovpn_genconfig -u udp://$hostname
#   $password # password
#   $password # confirm
#     # default DN
#   $password # pass again
# EOF

# exit 0

docker-compose run --rm openvpn ovpn_genconfig -u udp://$hostname
docker-compose run --rm openvpn ovpn_initpki

sudo chown -R $(whoami): ./openvpn-data

docker-compose up -d

# echo "#!/bin/bash" > up.sh
# echo "docker-compose up -d openvpn" >> up.sh
# chmod +x up.sh

echo "#!/bin/bash" > check_logs.sh
echo "docker-compose logs -f" >> check_logs.sh
chmod +x check_logs.sh

NUM_CLIENTS=2

for i in $(seq 1 $NUM_CLIENTS);
do
    export CLIENTNAME="client$i"
    docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
    docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
done