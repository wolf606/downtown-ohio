#! /bin/bash

# Download oxide from https://umod.org/games/rust/download/develop and unzip it to /home/rusty/Steam/Rust

# Set the following variables to your liking

# The path to your Rust server
# Get the current path, get out of the folder plus the Rust folder
RUST_SERVER_PATH=$(dirname "$(pwd)") && rust_folder_path="$folder_path/Rust"

# Download the latest version of oxide and unzip it to the Rust server
# Use wget

wget -O /tmp/oxide.zip https://umod.org/games/rust/download/develop

# If command fails, exit with error code

if [ $? -ne 0 ]; then
    echo "Failed to download oxide"
    exit 1
fi

# Unzip and overwrite existing files

unzip -o /tmp/oxide.zip -d $RUST_SERVER_PATH

# Remove the downloaded zip file

rm /tmp/oxide.zip