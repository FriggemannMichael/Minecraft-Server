FROM eclipse-temurin:25-jre-alpine

ARG SERVER_SHA1=33680f5f2ac32864d6d7cf5e56a705fdb3e05f4c
ADD https://piston-data.mojang.com/v1/objects/33680f5f2ac32864d6d7cf5e56a705fdb3e05f4c/server.jar /opt/minecraft/minecraft_server.26.3.jar

RUN echo "${SERVER_SHA1}  /opt/minecraft/minecraft_server.26.3.jar" | sha1sum -c - \
    && mkdir -p /data /config

COPY entrypoint.sh /opt/minecraft/entrypoint.sh

RUN chmod +x /opt/minecraft/entrypoint.sh

ENV MC_XMS=4G MC_XMX=4G EULA=false

WORKDIR /data
EXPOSE 25565/tcp

ENTRYPOINT [ "/opt/minecraft/entrypoint.sh" ]
