set "packages=firefox
vlc
notepadplusplus"

set "package_list="

for /f "delims=" %%p in ("%packages%") do (
    set "package_list=!package_list!%%p "
)

set "package_list=%package_list:~0,-1%"

choco install %package_list% -y