#!/bin/bash

conf_file="/etc/mkinitcpio.conf"

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root/sudo privileges."
	exit 1
fi

EDIT_HOOKS=0
EDIT_MODULES=0
REMOVE_HOOK=0
if [ "$1" == "add-hooks" ]; then
    EDIT_HOOKS=1
elif [ "$1" == "add-modules" ]; then
    EDIT_MODULES=1
elif [ "$1" == "add-files" ]; then
    EDIT_FILES=1
elif [ "$1" == "remove-hook" ]; then
    REMOVE_HOOK=1
else
	printf "Options \n"
	printf	"\t add-hooks\n"
	printf	"\t add-modules\n"
	printf	"\t add-files\n"
	printf	"\t remove-hook\n"
    exit 1
fi

edit_string=""
if (( EDIT_HOOKS )); then
    edit_string="HOOKS"
elif (( REMOVE_HOOK )); then
    edit_string="HOOKS"
elif (( EDIT_MODULES )); then
    edit_string="MODULES"
elif (( EDIT_FILES )); then
    edit_string="FILES"
fi

shift

if (( REMOVE_HOOK )); then

    if [ "$#" -ne 1 ]; then
        echo "Only one hook can be removed at a time"
        exit 1
    fi
    
    current_hooks=$(grep "^$edit_string=" "$conf_file" | sed -e "s/^$edit_string=//")
    if ! ( echo "$current_hooks" | grep -qw "$1" ); then
        echo "$1 is not in current hooks"
        exit 1
    fi
    new_hooks=$(echo "$current_hooks" | sed "s/\b$1 \b//g")

    echo "$current_hooks"
    echo "$new_hooks"

    read -p "Do these $edit_string look right (YES for yes, otherwise No)? " userInput

    if ! [ "$userInput" == "YES" ]; then
        echo "Cancelling. No damage done."
        exit 1
    fi

    sed -i "s/^$edit_string=.*/$edit_string=$new_hooks/" "$conf_file"
    echo "Changes written to $conf_file, remember to run mkinitcpio -P"
    exit 0
fi

AFTER=0
BEFORE=0
after_word=""
before_word=""
target_word=""

while getopts "ab" opt; do
  case $opt in
    a)
      AFTER=1
      shift
      after_word=$1 
      shift
      ;;
    b)
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

if ! (( AFTER || BEFORE )); then
	echo "Please specify -a <module> for after or -b <module for before"
	exit 1
fi

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

if [ "$target_word" = "end" ]; then
    target_word=")"
    BEFORE=1
    AFTER=0
elif [ "$target_word" = "start" ]; then
    target_word="("
    AFTER=1
    BEFORE=0
elif ! grep -q "^$edit_string=.*$target_word" "$conf_file"; then
        echo "The target $target_word ($edit_string) is not present in $conf_file."
        exit 1
fi

hooks_string="$@"
hooks=("$@")

current_hooks=$(grep "^$edit_string=" "$conf_file" | sed -e "s/^$edit_string=//")

new_hooks="$current_hooks"

for hook in "${hooks[@]}"; do
    if ( echo "$new_hooks" | grep -qw "$hook" ); then
        echo "$hook is already in current hooks. No changes made."
        exit 1
    fi
    new_hooks=${new_hooks//"$hook "/}
    new_hooks=${new_hooks//"$hook)"}
    new_hooks=${new_hooks/". $hook"/}
done

if (( AFTER )); then
    new_hooks=$(echo "$new_hooks" | sed "s|$target_word| $target_word $hooks_string |")
    #new_hooks=$(echo "$new_hooks" | sed 's/\\//g' | sed "s|$target_word| $target_word $hooks_string |")
    #new_hooks=$(echo ${new_hooks//\\/} | sed 's/||//g' | sed "s|$target_word| $target_word $hooks_string |")
elif (( BEFORE )); then 
    #new_hooks=$(echo "$new_hooks" | sed 's/\\//g' | sed "s|$target_word| $hooks_string $target_word |")
    #new_hooks=$(echo "$new_hooks" | sed 's/\\//g' | sed "s|$target_word| $hooks_string $target_word |")
    new_hooks=$(echo "$new_hooks" | sed "s|$target_word| $hooks_string $target_word |")
fi
new_hooks=$(echo "$new_hooks" | sed 's/[()]//g' | tr -s ' ')
new_hooks=$(echo "$new_hooks" | sed 's/[[:blank:]]*$//')
new_hooks=$(echo "$new_hooks" | sed 's/^[[:space:]]*//')
new_hooks=$(echo "$new_hooks" | sed 's/[]\/$*.^[]/\\&/g')
new_hooks=$(echo "($new_hooks)")

echo "$current_hooks"
echo "$new_hooks"

read -p "Do these $edit_string look right (YES for yes, otherwise No)? " userInput

if ! [ "$userInput" == "YES" ]; then
    echo "Cancelling. No damage done."
    exit 1
fi

sed -i "s/^$edit_string=.*/$edit_string=$new_hooks/" "$conf_file"

echo "Changes written to $conf_file, remember to run mkinitcpio -P"

