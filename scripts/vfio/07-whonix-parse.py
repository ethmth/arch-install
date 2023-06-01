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
    print("Run ./04-vm-config.sh first to set location")
    sys.exit(1)

if os.path.exists(WHONIX_LOC) == False:
    print("Your configured location is not available. Is the disk mounted?")
    print("Try mounting the disk, and optionally running ./04-vm-config.sh")
    sys.exit(1)

# print(f"whonix {WHONIX_LOC}/whonix/Whonix-Gateway.xml")


gw_file=f"{WHONIX_LOC}/whonix/Whonix-Gateway.xml"
ws_file=f"{WHONIX_LOC}/whonix/Whonix-Workstation.xml"
int_file=f"{WHONIX_LOC}/whonix/Whonix_internal.xml"
ext_file=f"{WHONIX_LOC}/whonix/Whonix_external.xml"

# xml_file = 'Whonix-Gateway.xml'
# memory_value = '1048576'  # New memory value in KiB (1GB)
# dump_core_value = 'on'  # New dumpCore attribute value

# Parse the XML file
gw_tree = ET.parse(gw_file)
gw_root = gw_tree.getroot()

# Find the memory element and update its attributes and text
gw_memory_element = gw_root.find(".//memory")
# gw_memory_element.set('dumpCore', dump_core_value)
gw_memory_element.text = '1048576'

# Save the modified XML file
gw_tree.write(gw_file)