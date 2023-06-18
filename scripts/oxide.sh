#! /bin/bash

# Download oxide from https://umod.org/games/rust/download/develop and unzip it to /home/rusty/Steam/Rust

# Set the following variables to your liking

# The path to your Rust server
# Get the current path, get out of the folder plus the Rust folder
RUST_SERVER_PATH="$(dirname "$(pwd)")/Rust"

# Print with distinctive colors a separator that indicates the server is updating plugins

echo -e "\e[32m--------------------------------------------------\e[0m"
echo -e "\e[32mUpdating oxide...\e[0m"

# Download the latest version of oxide and unzip it to the Rust server
# Use wget and if theres an error print the error, else go quiet

wget -nv --show-progress https://umod.org/games/rust/download/develop -O /tmp/oxide.zip

# If command fails, exit with error code

if [ $? -ne 0 ]; then
    # Print error message in red
    echo -e "\e[31mFailed to download oxide\e[0m"
    exit 1
    echo -e "\e[32m--------------------------------------------------\e[0m"
fi

# Unzip and overwrite existing files

unzip -o /tmp/oxide.zip -d $RUST_SERVER_PATH

# If command fails, exit with error code

if [ $? -ne 0 ]; then
    # Print error message in red
    echo -e "\e[31mFailed to unzip oxide\e[0m"
    exit 1
    echo -e "\e[32m--------------------------------------------------\e[0m"
fi

# Remove the downloaded zip file

rm /tmp/oxide.zip

# If command fails, exit with error code

if [ $? -ne 0 ]; then
    # Print error message in red
    echo -e "\e[31mFailed to remove oxide zip\e[0m"
    exit 1
    echo -e "\e[32m--------------------------------------------------\e[0m"
fi

echo -e "\e[32m--------------------------------------------------\e[0m"