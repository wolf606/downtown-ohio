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
        # Print with distinctive colors a separator that indicates the deployment is starting
        echo -e "\e[32m--------------------------------------------------\e[0m"
        echo -e "\e[32mDeploying Rust server...\e[0m"

        touch "$SERVER_PATH/deploying"

        # create logs folder in $SERVER_PATH

        if [ ! -d "$SERVER_PATH/logs" ]; then
            mkdir -p "$SERVER_PATH/logs"
        fi

        ./run.sh

        # if run.sh fails, exit with error code

        if [ $? -ne 0 ]; then
            # Print error message in red
            echo -e "\e[31m DEPLOYMENT FAILURE: Rust server exited with an error\e[0m"
            rm "$SERVER_PATH/deploying"
            exit 1
        fi

        # If Rust/Compiler.x86_x64 exists, then add 755 permissions to it, else exit with error code

        if [ -f "$SERVER_PATH/Rust/Compiler.x86_x64" ]; then
            chmod 755 "$SERVER_PATH/Rust/Compiler.x86_x64"
        else
            # Print error message in red
            echo -e "\e[31mRust/Compiler.x86_x64 not found\e[0m"
            rm "$SERVER_PATH/deploying"
            exit 1
        fi

        # check if plugins/data folder exists, if not create it

        if [ ! -d "$SERVER_PATH/plugins/data" ]; then
            mkdir -p "$SERVER_PATH/plugins/data"
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

    echo -e "Deployment completed"
    echo -e "\e[32m--------------------------------------------------\e[0m"
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

if [ "$(ls -A $OXIDE_PATH/config)" ]; then
    cp -rn "$OXIDE_PATH/config"/* "$SERVER_PATH/plugins/configs"
fi

# Check if oxide/data is not empty, if not copy files to plugins/data folder

if [ "$(ls -A $OXIDE_PATH/data)" ]; then
    cp -r "$OXIDE_PATH/data"/* "$SERVER_PATH/plugins/data"
fi