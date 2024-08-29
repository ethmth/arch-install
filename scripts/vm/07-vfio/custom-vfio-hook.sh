#!/bin/bash
# https://hardcoded.info/post/2023/03/04/pci-passthrough-using-vfio-pci-for-linux-kernel-version-6-solution/


if [[ $# -ne 3 ]]; then
    echo "DO NOT RUN THIS SCRIPT DIRECTLY"
    exit 1
fi

if [ "$1" != "IUNDERSTAND" ]; then
    echo "DO NOT RUN THIS SCRIPT DIRECTLY"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
	echo "This script should be run with root/sudo privileges."
	exit 1
fi

if ! [ -f "./custom-vfio-hook-files/vfio-pci-override-vga.sh" ]; then
    echo "Make sure you're in the correct directory"
    exit 1
fi

if ! [ -f "./custom-vfio-hook-files/hooks-vfio" ]; then
    echo "Make sure you're in the correct directory"
    exit 1
fi

if ! [ -f "./custom-vfio-hook-files/install-vfio" ]; then
    echo "Make sure you're in the correct directory"
    exit 1
fi

if ! [ -f "./custom-vfio-hook-files/vfio-load.service" ]; then
    echo "Make sure you're in the correct directory"
    exit 1
fi

CUR_USER=$2
groups=$3

# Step 1
echo "#!/bin/sh" > /sbin/vfio-pci-override-vga.sh
echo "DEVS=\"$groups\"" >> /sbin/vfio-pci-override-vga.sh
cat ./custom-vfio-hook-files/vfio-pci-override-vga.sh >> /sbin/vfio-pci-override-vga.sh
chmod 755 /sbin/vfio-pci-override-vga.sh

# Step 2
cp ./custom-vfio-hook-files/hooks-vfio /etc/initcpio/hooks/vfio
chmod 644 /etc/initcpio/hooks/vfio

cp ./custom-vfio-hook-files/install-vfio /etc/initcpio/install/vfio
chmod 644 /etc/initcpio/install/vfio

# Step 3
echo "YES" | bash /home/$CUR_USER/arch-install/util/kernel/mkinit-edit.sh add-files -b "end" /sbin/vfio-pci-override-vga.sh
bash /home/$CUR_USER/arch-install/util/kernel/mkinit-edit.sh add-hooks -a base vfio

# Step 4
cp ./custom-vfio-hook-files/vfio-load.service /etc/systemd/system/vfio-load.service
chmod 644 /etc/systemd/system/vfio-load.service

systemctl enable vfio-load.service


