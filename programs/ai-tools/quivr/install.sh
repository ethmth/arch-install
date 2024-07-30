#!/bin/bash

NAME="quivr"

if ! [[ $EUID -ne 0 ]]; then
        echo "This script should not be run with root/sudo privileges."
        exit 1
fi

CUR_USER=$(whoami)

LOC=$(lsblk --noheadings -o MOUNTPOINTS | grep -v '^$' | grep -v "/boot" | fzf --prompt="Select your desired SD installation location")

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

git clone https://github.com/quivrhq/quivr.git $LOC/$NAME
cd $LOC/$NAME
git checkout 317277db734fdd03c656b487d9d2a8459be2f0e3

read -p "What is your OpenAI API Key? (https://platform.openai.com/api-keys) " api_key

if [ "$api_key" == "" ]; then
    echo "No key provided"
    exit 1
fi

cp .env.example .env

bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh .env "OPENAI_API_KEY=$api_key"
bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh .env "TELEMETRY_ENABLED=false"

bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh .env "PREMIUM_MAX_BRAIN_NUMBER=2147483647"
bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh .env "PREMIUM_MAX_BRAIN_SIZE=2147483647"
bash /home/$CUR_USER/arch-install/util/kernel/config-update.sh .env "PREMIUM_DAILY_CHAT_CREDIT=2147483647"

sed -i 's|backend-base:latest|stangirard/quivr-backend-prebuilt:latest|g' $LOC/$NAME/docker-compose.yml
sed -i 's|stangirard/quivr-backend-prebuilt:latest|stangirard/quivr-backend-prebuilt:317277db734fdd03c656b487d9d2a8459be2f0e3|g' $LOC/$NAME/docker-compose.yml

echo "#!/bin/bash
cd $LOC/$NAME/backend && supabase start
cd $LOC/$NAME
docker compose up -d
" > $LOC/$NAME/run.sh

echo "#!/bin/bash
cd $LOC/$NAME/backend && supabase stop
cd $LOC/$NAME
docker compose down
" > $LOC/$NAME/stop.sh

chmod +rx $LOC/$NAME/run.sh
chmod +rx $LOC/$NAME/stop.sh

echo "$NAME installed to $LOC/$NAME"
echo "You can access the app at http://localhost:3000/login"
echo "You can access Quivr backend API at http://localhost:5050/docs"
echo "You can access supabase at http://localhost:54323"
echo "Login with: admin@quivr.app:admin"
echo "Run ./run.sh to start and ./stop.sh to stop"
