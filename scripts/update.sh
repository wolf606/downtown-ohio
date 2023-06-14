#! /bin/sh
RUST_SERVER_PATH="$(dirname "$(pwd)")/Rust"

# Check if path exists, if not create it

if [ ! -d "$RUST_SERVER_PATH" ]; then
    mkdir -p "$RUST_SERVER_PATH"
fi

steamcmd +force_install_dir $RUST_SERVER_PATH +login anonymous +app_update 258550 +quit
./oxide.sh
