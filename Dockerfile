FROM azul/zulu-openjdk-alpine:11

RUN addgroup -S liferay && adduser -S liferay -G liferay && \
    apk --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.10/main/ add \
    gcompat

USER liferay

WORKDIR /home/liferay

COPY --chown=liferay:liferay gradle gradle
COPY --chown=liferay:liferay gradlew .
COPY --chown=liferay:liferay gradle.properties .

RUN BUNDLE_URL=$(cat gradle.properties | grep liferay.workspace.bundle.url= | cut -d'=' -f2) && \
    mkdir -p .liferay/bundles && \
    wget -P .liferay/bundles "$BUNDLE_URL" && \
    ./gradlew

ENV LIFERAY_HOME=/home/liferay/bundles
ARG TARGET_ENV=prod

COPY --chown=liferay:liferay start-liferay.sh .
COPY --chown=liferay:liferay settings.gradle .
COPY --chown=liferay:liferay build.gradle .
COPY --chown=liferay:liferay configs/common configs/common
COPY --chown=liferay:liferay configs/$TARGET_ENV configs/$TARGET_ENV
COPY --chown=liferay:liferay themes themes
COPY --chown=liferay:liferay modules modules

RUN ./gradlew initBundle -Pliferay.workspace.environment=$TARGET_ENV

ENV DEBUG_PORT=8000
ENV JPDA_ADDRESS=*:$DEBUG_PORT
ENV LIFERAY_JPDA_ENABLED=false

EXPOSE 8080 11311 $DEBUG_PORT

ENTRYPOINT ["./start-liferay.sh"]
