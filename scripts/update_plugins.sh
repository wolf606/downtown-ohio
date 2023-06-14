#! /bin/bash

SERVER_PATH=$(dirname "$(pwd)")
RUST_SERVER_PATH="$SERVER_PATH/Rust"
OXIDE_PATH="$RUST_SERVER_PATH/oxide"
PLUGINS_PATH="$SERVER_PATH/plugins"

# Check if .env file exists, if exit and print text in red
if [ ! -f "$SERVER_PATH/.env" ]; then
    echo -e "\e[31m.env file not found\e[0m"
    exit 1
fi

# Read .env file
source "$SERVER_PATH/.env"

# Check if plugins.txt exists, if not exit and print text in red

if [ ! -f "$PLUGINS_PATH/plugins.txt" ]; then
    echo -e "\e[31mplugins.txt not found\e[0m"
    exit 1
fi

# Read plugins.txt file and create an array

readarray -t PLUGINS < "$PLUGINS_PATH/plugins.txt"

# Check if path exists, if not exit and print text in red

if [ ! -d "$RUST_SERVER_PATH" ]; then
    echo -e "\e[31mRust server path not found\e[0m"
    exit 1
fi

# Check if oxide folder exists, if not exit and print text in red

if [ ! -d "$OXIDE_PATH" ]; then
    echo -e "\e[31mOxide folder not found\e[0m"
    exit 1
fi

# Remove all plugins from oxide folder

rm -rf "$OXIDE_PATH/plugins"/*

# Use wget to download plugins from the oxide website, show progress and replace if exists

for i in "${PLUGINS[@]}"
do
    wget -nv --show-progress -N "$i" -P "$OXIDE_PATH/plugins"

    # if wget fails, exit with error code

    if [ $? -ne 0 ]; then
        # Print error message in red
        echo -e "\e[31mFailed to download plugin\e[0m"
        exit 1
    fi
done

# Remove the config files

rm -rf "$OXIDE_PATH/config"/*

# Copy the config files to the oxide config folder
# if "$PLUGINS_PATH/configs" is not empty

if [ "$(ls -A $PLUGINS_PATH/configs)" ]; then
    cp -r "$PLUGINS_PATH/configs"/* "$OXIDE_PATH/config"
fi
