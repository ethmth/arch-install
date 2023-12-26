#!/bin/bash

CONTAINER_NAME="nginx"

VOLUMES="
html
conf.d
"

FILES="
docker-compose.yml
Dockerfile
nginx.conf
conf.d
html
"

if ! [[ $EUID -ne 0 ]]; then
    echo "This script should not be run with root/sudo privileges."
    exit 1
fi

CUR_USER=$(whoami)
LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired Label Studio installation location")

if ([ "$LOC" == "" ] || [ "$LOC" == "Cancel" ]); then
    echo "Nothing was selected"
    echo "Run this script again with target drive mounted."
    exit 1
fi

if [ "$LOC" == "/" ]; then
    LOC="/home/$CUR_USER"
fi

if ! [ -d "$LOC" ]; then
    echo "Your location is not available. Is the disk mounted? Do you have access?"
	exit 1
fi

LOC="$LOC/programs"
mkdir -p $LOC

# read -p "Please enter your domain (or subdomain): " input_domain
# if [ "$input_domain" == "" ]; then
#     echo "Please specify your domain next time."
#     exit 1
# fi
# if [[ ! $input_domain =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
#     echo "Invalid domain format. Please enter a valid domain."
#     exit 1
# fi
# domain=$input_domain
# domain_no_sub=$(echo $input_domain | awk -F'.' '{if (NF > 2) {print $(NF-1)"."$NF} else {print $0}}')

# read -p "Please enter your email: " email

mkdir -p $LOC/$CONTAINER_NAME

# replace_content() {
#     file="$1"
#     domain="$2"
#     domain_no_sub="$3"
#     email="$4"

#     sed -i "s/\.YOURDOMAIN\.COM/\.$domain_no_sub/g" "$file"
#     sed -i "s/YOURDOMAIN\.COM/$domain/g" "$file"
#     sed -i "s/YOUREMAIL/$email/g" "$file"
# }

for file in $FILES; do
    if [ -d "$file" ]; then
        cp -r $file $LOC/$CONTAINER_NAME/$file

        # for myfile in "$LOC/$CONTAINER_NAME/$file"/*; do
        #     if [ -f "$myfile" ]; then
        #         replace_content "$myfile" "$domain" "$domain_no_sub" "$email"
        #     fi
        # done
    elif [ -f "$file" ]; then
        cp $file $LOC/$CONTAINER_NAME/$file
        # replace_content "$LOC/$CONTAINER_NAME/$file" "$domain" "$domain_no_sub" "$email"
    fi
done

# chmod +rx $LOC/$CONTAINER_NAME/init-letsencrypt.sh

for vol in $VOLUMES; do
    mkdir -p $LOC/$CONTAINER_NAME/$vol
    chmod -R 777 $LOC/$CONTAINER_NAME/$vol
done

echo "Installed $CONTAINER_NAME to $LOC"
echo "Run 'docker-compose up --build -d' to run"
echo "cd $LOC/$CONTAINER_NAME"