#!/bin/bash

#conf_file="/etc/mkinitcpio.conf"
conf_file="mkinitcpio.conf"

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

EDIT_HOOKS=0
EDIT_MODULES=0
if [ "$1" == "add-hook" ]; then
    EDIT_HOOKS=1
elif [ "$1" == "add-module" ]; then
    EDIT_MODULES=1
else
	printf "Options \n"
	printf	"\t add-hook\n"
	printf	"\t add-module\n"
    exit 1
fi

shift

AFTER=0
BEFORE=0
after_word=""
before_word=""
target_word=""

while getopts "ab" opt; do
  case $opt in
    a)
      #echo "Option A is selected"
      # Do something for option A
      AFTER=1
      shift
      after_word=$1 
      shift
      ;;
    b)
      #echo "Option B is selected"
      # Do something for option B
      BEFORE=1
      shift
      before_word=$1
      shift
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

if (( AFTER && BEFORE )); then
    echo "Cannot specify both after (-a) and before (-b)"
    exit 1
fi

if (( AFTER )); then
    target_word=$after_word
fi
if (( BEFORE )); then
    target_word=$before_word
fi

if ! grep -q "^HOOKS=.*$target_word" "$conf_file"; then
        echo "The hook $target_word is not present in $conf_file."
        exit 1
fi

hooks_string="$@"
#hooks=("$hooks_string")
hooks=("$@")
#hooks=("$@")
#hooks=("$hooks_string")
#echo "$hooks"
#echo "$hooks_string"

current_hooks=$(grep "^HOOKS=" "$conf_file" | sed -e 's/^HOOKS=//')
#printf "Previous Hooks:\n$current_hooks\n"

new_hooks="$current_hooks"

# Check if the hooks are already present in the file
for hook in "${hooks[@]}"; do
    #if grep -q "^HOOKS=.*$hook" "$current_hooks"; then
    #    echo "The hook $hook is already present in $current_hooks."
    #else
    #    echo "Adding the hook $hook to $current_hooks."
    #    sed -i "/^HOOKS=/ s/\(^\(HOOKS=.*\)\)\$/\1 $hook/" "$current_hooks"
    #fi
    new_hooks=${new_hooks//"$hook "/}
    new_hooks=${new_hooks//"$hook)"}
    new_hooks=${new_hooks/". $hook"/}
    #echo "$hook"
done
#echo "$new_hooks"
#index=$(echo $new_hooks | grep -o "\b$after\b" | wc -w)
#index=$((index + 1))

#new_hooks="${current_hooks:0:$index} $hooks ${current_hooks:$index}"
#index=$(echo $original_hooks | awk -v after="$after" '{for (i=1; i<=NF; i++) if ($i == after) {print i; break}}')
#new_hooks="${new_hooks:0:$index} $hooks ${new_hooks:$index}"

new_string=$(echo "$new_string" | sed "s/$after_word/$after_word $hooks_string/")

echo "Original hooks: $current_hooks"
echo "New hooks: $new_hooks"
