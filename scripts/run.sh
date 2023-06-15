#! /bin/bash

# Variables for production
PROD_PORT=28015
PROD_QUERY_PORT=28016
PROD_RCON_PORT=28016
PROD_APP_PORT=17151

# Variables for development
DEV_PORT=30000
DEV_QUERY_PORT=30001
DEV_RCON_PORT=30001
DEV_RCON_PASSWORD="testing"
DEV_APP_PORT=17000

runGame() {
  if [ $SERVER_MODE == "dev" ]; then
    echo "Running in development mode"
  elif [ $SERVER_MODE == "prod" ]; then
    echo "Running in production mode"
  else
    echo -e "\e[31mInvalid server mode\e[0m"
  fi
  echo ""
  echo 'Starting server PRESS CTRL-C to exit'
  echo 'Server PORT: ' $PORT
  echo 'Server QUERY_PORT: ' $QUERY_PORT
  echo 'Server RCON_PORT: ' $RCON_PORT
  echo 'Server APP_PORT: ' $APP_PORT
  
  exec ./RustDedicated -batchmode -nographics \
  -server.gamemode vanilla \
  -server.tags battlefield,SA \
  -server.port $PORT \
  -server.queryport $QUERY_PORT \
  -server.level "Procedural Map" \
  -server.seed 34646056 \
  -server.worldsize 5000 \
  -server.maxplayers 50 \
  -server.hostname "Ohio x1000000" \
  -server.description "Swag like Ohio" \
  -server.url "https://ohio.gov" \
  -server.headerimage "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Flag_of_Ohio.svg/800px-Flag_of_Ohio.svg.png" \
  -server.identity "ohio" \
  -rcon.port $RCON_PORT \
  -rcon.password $RCON_PASSWORD \
  -rcon.web 1 \
  -app.port $APP_PORT
}

SERVER_PATH=$(dirname "$(pwd)")
RUST_SERVER_PATH="$(dirname "$(pwd)")/Rust"

# Check if .env file exists, if exit and print text in red
if [ ! -f "$SERVER_PATH/.env" ]; then
    echo -e "\e[31m.env file not found\e[0m"
    exit 1
fi

# Check if Rust server path exists, if not exit and print text in red
if [ ! -d "$RUST_SERVER_PATH" ]; then
    echo -e "\e[31mRust server path not found\e[0m"
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

# Check if the server is running in production or development
if [ $SERVER_MODE == "dev" ]; then
  PORT=$DEV_PORT
  QUERY_PORT=$DEV_QUERY_PORT
  RCON_PORT=$DEV_RCON_PORT
  RCON_PASSWORD=$DEV_RCON_PASSWORD
  APP_PORT=$DEV_APP_PORT
elif [ $SERVER_MODE == "prod" ]; then
  PORT=$PROD_PORT
  QUERY_PORT=$PROD_QUERY_PORT
  RCON_PORT=$PROD_RCON_PORT
  APP_PORT=$PROD_APP_PORT
else
  echo -e "\e[31mInvalid server mode\e[0m"
  exit 1
fi

cd $RUST_SERVER_PATH

# While $SERVER_MODE is set to prod and $SERVER_PATH/deployig does not exist
while [ $SERVER_MODE == "prod" ] && [ ! -f "$SERVER_PATH/deploying" ]; do
  clear
  runGame
  echo "Rust server closed unexpectedly, restarting in 10 seconds..."
  sleep 10
done
