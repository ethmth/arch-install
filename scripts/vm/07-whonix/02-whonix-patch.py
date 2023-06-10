#!/bin/python

from dotenv import load_dotenv
import os
import sys
import xml.etree.ElementTree as ET

effective_user_id = os.geteuid()
if effective_user_id == 0:
    print("Don't run this script as root or with sudo.")
    sys.exit(1)

current_user = os.getlogin()

dotenv_path = f'/home/{current_user}/arch-install/config/vm.conf'  # Path to the custom-named file
load_dotenv(dotenv_path)

WHONIX_LOC=""
try:
    WHONIX_LOC= os.environ.get('WHONIX_LOC')
except:
    print(f"Error reading variable from {dotenv_path}")
    sys.exit(1)

if WHONIX_LOC == "":
    print("Whonix location not set in /home/$USER/arch-install/config/vm.conf")
    print("Run ../01-vm-config.sh first to set location")
    sys.exit(1)

if os.path.exists(WHONIX_LOC) == False:
    print("Your configured location is not available. Is the disk mounted?")
    print("Try mounting the disk, and optionally running ./04-vm-config.sh")
    sys.exit(1)

gw_file=f"{WHONIX_LOC}/whonix/Whonix-Gateway.xml"
ws_file=f"{WHONIX_LOC}/whonix/Whonix-Workstation.xml"
int_file=f"{WHONIX_LOC}/whonix/Whonix_internal.xml"
ext_file=f"{WHONIX_LOC}/whonix/Whonix_external.xml"

gw_tree = ET.parse(gw_file)
ws_tree = ET.parse(ws_file)
int_tree = ET.parse(int_file)
ext_tree = ET.parse(ext_file)

gw_root = gw_tree.getroot()
ws_root = ws_tree.getroot()
int_root = int_tree.getroot()
ext_root = ext_tree.getroot()

# ============= MAKE XML CHANGES HERE ====================

# Update Memory of Gateway
gw_root.find(".//memory").text = "1048576"

# Tun0 killswitch
ext_root.find('forward').set('dev', 'tun0')


# ============= END XML CHANGES =========================

gw_tree.write(gw_file)
ws_tree.write(ws_file)
int_tree.write(int_file)
ext_tree.write(ext_file)

with open(gw_file, 'r') as file:
    gw_content = file.read()
with open(ws_file, 'r') as file:
    ws_content = file.read()
with open(int_file, 'r') as file:
    int_content = file.read()
with open(ext_file, 'r') as file:
    ext_content = file.read()

updated_gw_content = gw_content
updated_ws_content = ws_content
updated_int_content = int_content
updated_ext_content = ext_content

# =============== MAKE REPLACEMENT/RAW CHANGES HERE ========

# Replace disk in Gateway
updated_gw_content = gw_content.replace("/var/lib/libvirt/images/Whonix-Gateway.qcow2", f"{WHONIX_LOC}/disk/Whonix-Gateway.qcow2")

# Replace disk in Workstation
updated_ws_content = ws_content.replace("/var/lib/libvirt/images/Whonix-Workstation.qcow2", f"{WHONIX_LOC}/disk/Whonix-Workstation.qcow2")

# =============== END REPLACEMENT/RAW CHANGES ==============

with open(gw_file, 'w') as file:
    file.write(updated_gw_content)
with open(ws_file, 'w') as file:
    file.write(updated_ws_content)
with open(int_file, 'w') as file:
    file.write(updated_int_content)
with open(ext_file, 'w') as file:
    file.write(updated_ext_content)

print("Whonix files modified.")
print("Run ./03-whonix-define.sh to define the virtual machines.")