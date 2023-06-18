#! /bin/bash

# Follow the logs of the Rust server with tail.
# ask the user how many lines to show, if answer is empty, default to 10
# Check that the input is indeed a number, or ask again
# If the input is a number, show that many lines

# also select the last log file created in the logs folder

SERVER_PATH=$(pwd)
LOGS_PATH="$SERVER_PATH/logs"

# Check if logs folder exists, if not create it

if [ ! -d "$LOGS_PATH" ]; then
    mkdir -p "$LOGS_PATH"
fi

# Get the last log file created in the logs folder

LOG_FILE_NAME=$(ls -t "$LOGS_PATH" | head -n1)

# Ask the user how many lines to show, if answer is empty, default to 10

read -p "How many lines to show? (default 10): " LINES

# Check that the input is indeed a number, or ask again
# if the input is empty, default to 10

while ! [[ "$LINES" =~ ^[0-9]+$ ]]; do
    if [ -z "$LINES" ]; then
        LINES=10
        break
    fi
    echo "Please enter a number"
    read -p "How many lines to show? (default 10): " LINES
done

# If the input is a number, show that many lines

tail -n "$LINES" -f "$LOGS_PATH/$LOG_FILE_NAME"