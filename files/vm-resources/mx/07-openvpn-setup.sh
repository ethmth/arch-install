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

if ! [ -e "openvpn/client.conf" ]; then
	echo "openvpn/client.conf not found"
	exit 1
fi

if ! [ -e "openvpn/server.conf" ]; then
	echo "openvpn/server.conf not found"
	exit 1
fi

mkdir -p /home/$CUR_USER/programs/openvpn/
cp openvpn/docker-compose.yml /home/$CUR_USER/programs/openvpn/docker-compose.yaml
cp openvpn/client.conf /home/$CUR_USER/programs/openvpn/client.conf
cp openvpn/server.conf /home/$CUR_USER/programs/openvpn/server.conf

hostname=""
# read -p "Please enter your desired hostname (Ex: 10.153.153.15, server.mydomain.com): " hostname
hostname="10.152.153.15"

if [ "$hostname" == "" ]; then
    echo "No hostname specified"
    exit 1
fi

cd /home/$CUR_USER/programs/openvpn

echo "Use same password for everything, leave Common Name as default (blank)"


docker-compose run --rm openvpn ovpn_genconfig -u udp://$hostname
docker-compose run --rm openvpn ovpn_initpki

sudo chown -R $(whoami): ./openvpn-data

docker-compose up -d

echo "#!/bin/bash" > check_logs.sh
echo "docker-compose logs -f" >> check_logs.sh
chmod +x check_logs.sh

NUM_CLIENTS=2

for i in $(seq 1 $NUM_CLIENTS);
do
    export CLIENTNAME="client$i"
    docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
    docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn


    cp client.conf my_$CLIENTNAME.ovpn

    sed -i "s/HOSTNAME_HERE/$hostname/g" my_$CLIENTNAME.ovpn


    word_list=("key" "cert" "ca" "tls-auth")

    for word in "${word_list[@]}"; do

        start_pattern="<$word>"
        end_pattern="<\/$word>"
        content_to_replace=$(awk "/$start_pattern/,/$end_pattern/" $CLIENTNAME.ovpn)

        echo 'Ignore awk warning "escape sequence `\/' treated as plain \`/'":'
        awk -v start="$start_pattern" -v end="$end_pattern" -v new_content="$content_to_replace" '
        $0 ~ start {
            print new_content
            found_start = 1
            next
        }
        !found_start {
            print $0
        }
        $0 ~ end && found_start {
            found_start = 0
        }
        ' "my_$CLIENTNAME.ovpn" > "my_$CLIENTNAME.tmp"

        mv "my_$CLIENTNAME.tmp" "my_$CLIENTNAME.ovpn"
    done
done

sed -i "s/HOSTNAME_HERE/$hostname/g" server.conf
cp server.conf ./openvpn-data/conf/openvpn.conf

docker-compose down
docker-compose up -d

echo "openvpn installed and running in /home/$CUR_USER/programs/openvpn."
echo "Run 'openvpn stop' or 'openvpn start' to control it"

echo "========================================================="
echo "Transfer the client configuration file my_client1.ovpn to the phone manually"
echo "Run ./openvpn-client.sh on Ubuntu to set that up"