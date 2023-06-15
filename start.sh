#! /bin/bash

SERVER_PATH=$(pwd)
OXIDE_PATH="$SERVER_PATH/Rust/oxide"

# Read .env file
# Check if .env file exists, else exit with error code

if [ ! -f .env ]; then
    # Print error message in red
    echo -e "\e[31m.env file not found\e[0m"
    exit 1
fi

source .env

clear

cd scripts

./update.sh

if [ $? -ne 0 ]; then
    # Print error message in red
    echo -e "\e[31mFailed to update Rust server\e[0m"
    exit 1
fi

# if SERVER_MODE is set to dev or Rust/oxide does not exists, update plugins

if [ $SERVER_MODE == "dev" ] || [ ! -d "$SERVER_PATH/Rust/oxide" ]; then

    # Run run.sh server to create oxide folder if Rust/oxide does not exists

    if [ ! -d "$SERVER_PATH/Rust/oxide" ]; then
        touch "$SERVER_PATH/deploying"
        ./run.sh

        # if run.sh fails, exit with error code

        if [ $? -ne 0 ]; then
            # Print error message in red
            echo -e "\e[31m DEPLOYMENT FAILURE: Rust server exited with an error\e[0m"
            # if Rust/oxide exists, remove it
            if [ -d "$SERVER_PATH/Rust/oxide" ]; then
                rm -rf "$SERVER_PATH/Rust/oxide"
            fi
            rm "$SERVER_PATH/deploying"
            exit 1
        fi
    fi

    # check if plugins/configs folder exists, if not create it

    if [ ! -d "$SERVER_PATH/plugins/configs" ]; then
        mkdir -p "$SERVER_PATH/plugins/configs"
    fi

    ./update_plugins.sh

    # if update_plugins.sh fails, exit with error code

    if [ $? -ne 0 ]; then
        # Print error message in red
        echo -e "\e[31mFailed to update plugins\e[0m"
        exit 1
    fi
fi

# If deploying file exists, remove it

if [ -f "$SERVER_PATH/deploying" ]; then
    rm "$SERVER_PATH/deploying"
fi

# Run run.sh server

./run.sh

# if run.sh fails, exit with error code

if [ $? -ne 0 ]; then
    # Print error message in red
    echo -e "\e[31mRust server exited with an error\e[0m"
    exit 1
fi

# if SERVER_MODE is set to dev, copy the oxide/config files to plugins/configs folder
# check if oxide/config is not empty, if not copy files to plugins/configs folder

if [ $SERVER_MODE == "dev" ]; then
    if [ "$(ls -A $OXIDE_PATH/config)" ]; then
        cp -rn "$OXIDE_PATH/config"/* "$SERVER_PATH/plugins/configs"
    fi
fi