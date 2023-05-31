#!/bin/bash

#conf_file="/etc/mkinitcpio.conf"
conf_file="mkinitcpio.conf"

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

if [ "$1" == "add-hook" ]; then 
  printf ""
elif [ "$1" == "ls-hook" ]; then 
  printf ""
elif [ "$1" == "add-module" ]; then
  printf ""
else
	printf "Options \n"
	printf	"\t add-hook\n"
	printf	"\t ls-hook\n"
	printf	"\t add-module\n"
    exit 1
fi

shift

AFTER=0
BEFORE=0
after_word=""
before_word=""

while getopts "ab" opt; do
  case $opt in
    a)
      echo "Option A is selected"
      # Do something for option A
      AFTER=1
      shift
      after_word=$1 
      shift
      ;;
    b)
      echo "Option B is selected"
      # Do something for option B
      BEFORE=1
      shift
      before_word=$1
      shift
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      usage
      exit 1
      ;;
  esac
done

if (( AFTER && BEFORE )); then
    echo "Cannot specify both after (-a) and before (-b)"
    exit 1
fi

if (( AFTER )); then
    echo "After $after_word"
fi
if (( BEFORE )); then
    echo "Before $before_word"
fi

hooks=("$@")  # Add the hooks you want to check and add here

#echo "BEFORE: $(grep -q "^HOOKS=.*base" "$conf_file")"
current_hooks=$(grep "^HOOKS=" "$conf_file" | sed -e 's/^HOOKS=//')
printf "Previous Hooks:\n $current_hooks\n"
#grep -q "^HOOKS=.*base" "$conf_file"

#echo "$hooks"

# Check if the hooks are already present in the file
for hook in "${hooks[@]}"; do
    if grep -q "^HOOKS=.*$hook" "$conf_file"; then
        echo "The hook $hook is already present in $conf_file."
    else
        echo "Adding the hook $hook to $conf_file."
        sed -i "/^HOOKS=/ s/\(^\(HOOKS=.*\)\)\$/\1 $hook/" "$conf_file"
    fi
done
