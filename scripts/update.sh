#! /bin/sh
RUST_SERVER_PATH="$(dirname "$(pwd)")/Rust"
SERVER_PATH=$(dirname "$(pwd)")

# Check if .env file exists, if exit and print text in red
if [ ! -f "$SERVER_PATH/.env" ]; then
    echo -e "\e[31m.env file not found\e[0m"
    exit 1
fi

# Read .env file
source "$SERVER_PATH/.env"

# Check if path exists, if not create it

if [ ! -d "$RUST_SERVER_PATH" ]; then
    mkdir -p "$RUST_SERVER_PATH"
fi

steamcmd +force_install_dir $RUST_SERVER_PATH +login anonymous +app_update 258550 +quit

# if steamcmd fails, exit with error code

if [ $? -ne 0 ]; then
    # Print error message in red
    echo -e "\e[31mFailed to update Rust server\e[0m"
    exit 1
fi

./oxide.sh

# if oxide.sh fails, exit with error code

if [ $? -ne 0 ]; then
    # Print error message in red
    echo -e "\e[31mFailed to update oxide\e[0m"
    exit 1
fi

# if SERVER_MODE is set to dev, update plugins

if [ $SERVER_MODE == "dev" ]; then
    ./update_plugins.sh

    # if update_plugins.sh fails, exit with error code

    if [ $? -ne 0 ]; then
        # Print error message in red
        echo -e "\e[31mFailed to update plugins\e[0m"
        exit 1
    fi
fi