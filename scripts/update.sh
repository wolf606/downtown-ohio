#! /bin/sh
RUST_SERVER_PATH="$(dirname "$(pwd)")/Rust"
steamcmd +force_install_dir $RUST_SERVER_PATH +login anonymous +app_update 258550 +quit
./oxide.sh
