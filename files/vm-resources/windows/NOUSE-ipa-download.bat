@echo off
set "url=https://github.com/BepInEx/IPALoaderX/releases/download/v1.2.4/BepInEx.IPALoader.v1.2.4.zip"
set "downloaded_file=C:\Users\%USERNAME%\Downloads\BepInEx.IPALoader.v1.2.4.zip"
set "extracted_folder=C:\Users\%USERNAME%\Downloads\BepInEx.IPALoader"

echo Downloading %downloaded_file%...
wget %url% -O %downloaded_file%

if %errorlevel% neq 0 (
    echo Failed to download %downloaded_file%.
    exit /b
)

echo Extracting %downloaded_file%...
7z x %downloaded_file% -o%extracted_folder% -aoa

if %errorlevel% neq 0 (
    echo Failed to extract %downloaded_file%.
    exit /b
)

echo File has been downloaded and extracted successfully.
echo Extraction folder: %extracted_folder%
echo "Copy the contents of C:\Users\%USERNAME%\Downloads\BepInEx.IPALoader\BepInEx to Game\BepInEx"
echo "xcopy C:\Users\%USERNAME%\Downloads\BepInEx.IPALoader\BepInEx GAME_LOCATION\Game\BepInEx /E /I /H"

pause