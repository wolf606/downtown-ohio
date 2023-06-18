#! /bin/bash

# Generate a unit file for the Rust server for systemd

SERVER_PATH=$(pwd)

# Check if .env file exists, if exit and print text in red

if [ ! -f "$SERVER_PATH/.env" ]; then
    echo -e "\e[31m.env file not found\e[0m"
    exit 1
fi

# Read .env file

source "$SERVER_PATH/.env"

# Check if SERVER_MODE is set

if [ -z "$SERVER_MODE" ]; then
  echo -e "\e[31mSERVER_MODE is not set\e[0m"
  exit 1
fi

# Check if RCON_PASSWORD is set

if [ -z "$RCON_PASSWORD" ]; then
  echo -e "\e[31mRCON_PASSWORD is not set\e[0m"
  exit 1
fi

# Check if the server is running in production 'prod'
# If yes create a unit file for the Rust server

START_LINE="tmux new-session -d -s rust '/bin/bash $SERVER_PATH/start.sh'"
STOP_LINE="tmux send -t rust quit ENTER"

if [ $SERVER_MODE == "prod" ]; then
  sudo cat > /etc/systemd/system/rust-server.service << EOF
[Unit]
Description=Rust Server
After=network-online.target
Wants=network-online.target

[Service]
User=$USER
ExecStart=$START_LINE
ExecStop=$STOP_LINE
ExecReload=$STOP_LINE && $START_LINE
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reload
  sudo systemctl enable rust-server.service

# Check if the server is running in development 'dev'
# If yes exit and say it is not supported
elif [ $SERVER_MODE == "dev" ]; then
  echo -e "\e[31mDevelopment mode is not supported\e[0m"
  exit 1
else
  echo -e "\e[31mInvalid server mode\e[0m"
  exit 1
fi