#!/bin/sh
set -eu

: "${MC_XMS:=4G}"
: "${MC_XMX:=4G}"
: "${EULA:=false}"

if [ "${EULA}" != "true" ]; then
  echo "Set EULA=true only after reading and accepting the Minecraft EULA: https://www.minecraft.net/eula" >&2
  exit 1
fi

if [ ! -f /config/server.properties ]; then
  echo "Missing /config/server.properties" >&2
  exit 1
fi

if [ ! -f /data/server.properties ]; then
  cp /config/server.properties /data/server.properties
fi

printf 'eula=true\n' > /data/eula.txt

exec java "-Xms${MC_XMS}" "-Xmx${MC_XMX}" -jar /opt/minecraft/minecraft_server.26.3.jar nogui