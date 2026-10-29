#!/bin/sh
set -eu

: "${MC_XMS:=4G}"
: "${MC_XMX:=4G}"
: "${EULA:=false}"

if [ "${EULA}" != "true" ]; then
  echo "Set EULA=true only after reading and accepting the Minecraft EULA: https://www.minecraft.net/eula" >&2
  exit 1
fi

if [ ! -f /data/server.properties ]; then
  cp /opt/minecraft/server.properties /data/server.properties
fi

set_property() {
  PROPERTY_KEY="${1}"
  PROPERTY_VALUE="$(printf '%s' "${2}" | sed 's/[\\&|]/\\&/g')"
  sed -i "s|^${PROPERTY_KEY}=.*|${PROPERTY_KEY}=${PROPERTY_VALUE}|" /data/server.properties
}

if [ -n "${MC_MOTD:-}" ]; then set_property motd "${MC_MOTD}"; fi
if [ -n "${MC_MAX_PLAYERS:-}" ]; then set_property max-players "${MC_MAX_PLAYERS}"; fi
if [ -n "${MC_GAMEMODE:-}" ]; then set_property gamemode "${MC_GAMEMODE}"; fi
if [ -n "${MC_DIFFICULTY:-}" ]; then set_property difficulty "${MC_DIFFICULTY}"; fi

printf 'eula=true\n' > /data/eula.txt

exec java "-Xms${MC_XMS}" "-Xmx${MC_XMX}" -jar /opt/minecraft/minecraft_server.26.3.jar nogui
