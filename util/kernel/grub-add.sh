#!/bin/bash

conf_file="/etc/default/grub"

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

if [ $# -lt 1 ]; then
	echo "Please provide at least one option to add"
	exit 1
fi

new="$@"

# current=$(grep -oP '(?<=GRUB_CMDLINE_LINUX_DEFAULT=")[^"]*' "$conf_file")
current=$(grep -oP '^GRUB_CMDLINE_LINUX_DEFAULT="\K[^"]*' "$conf_file")
IFS=' ' read -r -a current_array <<< "$current"
IFS=' ' read -r -a new_array <<< "$new"

result=("${current_array[@]}")

for new_value in "${new_array[@]}"; do
  found=false

  for item in "${current_array[@]}"; do
    if [ "$item" == "$new_value" ]; then
        echo "$new_value is already in the config. No changes made."
        exit 1
    fi
  done

  for ((i=0; i<${#result[@]}; i++)); do
    # Check if the current value starts with the new value
    if [[ ${result[i]} == ${new_value%%=*}* ]]; then
      result[i]=$new_value
      found=true
      break
    fi
  done

  if [[ $found == false ]]; then
    result+=("$new_value")
  fi
done

result_string=$(IFS=' '; echo "${result[*]}")

echo "$current"
echo "$result_string"

read -p "Do these argument changes look right (YES for yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Cancelling. No damage done."
    exit 1
fi

old_values="$current"
new_values="$result_string"

escaped_old_values=$(printf '%s\n' "$old_values" | sed -e 's/[\/&]/\\&/g')
escaped_new_values=$(printf '%s\n' "$new_values" | sed -e 's/[\/&]/\\&/g')

sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"$escaped_old_values\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$escaped_new_values\"/" "$conf_file"

echo "Changes written to $conf_file, remember to run grub-mkconfig -o /boot/grub/grub.cfg"

