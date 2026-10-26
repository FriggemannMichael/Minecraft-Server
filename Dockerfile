FROM eclipse-temurin:25-jre-alpine

ARG SERVER_SHA1=33680f5f2ac32864d6d7cf5e56a705fdb3e05f4c
ADD https://piston-data.mojang.com/v1/objects/33680f5f2ac32864d6d7cf5e56a705fdb3e05f4c/server.jar /opt/minecraft/minecraft_server.26.3.jar

RUN eco "${SERVER_SHA1}}  /opt/minecraft/minecraft_server.26.3.jar" | sha1sum -c - \
    && mkdir -p /data/config

COPY

RUN

ENV key=value

WORKDIR

EXPOSE 25565/tcp

ENTRYPOINT [ "/opt/minecraft/entrypoint.sh" ]
