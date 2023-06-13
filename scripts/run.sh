#! /bin/sh
cd Rust
clear while : do
  exec ./RustDedicated -batchmode -nographics \
  -server.gamemode vanilla \
  -server.tags weekly,vanilla,NA \
  -server.port 28015 \
  -server.queryport 28016 \
  -server.level "Procedural Map" \
  -server.seed 34646056 \
  -server.worldsize 5000 \
  -server.maxplayers 50 \
  -server.hostname "Ohio x1000000" \
  -server.description "Swag like Ohio" \
  -server.url "https://ohio.gov" \
  -server.headerimage "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Flag_of_Ohio.svg/800px-Flag_of_Ohio.svg.png" \
  -server.identity "ohio" \
  -rcon.port 28016 \
  -rcon.password "*XboxDurango2013" \
  -rcon.web 1 \
  -app.port 17151\
  echo "\nRestarting server...\n" done