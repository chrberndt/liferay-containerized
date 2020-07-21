FROM azul/zulu-openjdk-alpine:11

RUN addgroup -S liferay && adduser -S liferay -G liferay
USER liferay

WORKDIR /home/liferay

COPY --chown=liferay:liferay gradle gradle
COPY --chown=liferay:liferay gradlew .
COPY --chown=liferay:liferay gradle.properties .

RUN BUNDLE_URL=$(cat gradle.properties | grep liferay.workspace.bundle.url= | cut -d'=' -f2) && \
    mkdir -p .liferay/bundles && \
    wget -P .liferay/bundles "$BUNDLE_URL" && \
    ./gradlew

ENV TARGET_ENV "local"

COPY --chown=liferay:liferay docker-entrypoint.sh .
COPY --chown=liferay:liferay settings.gradle .
COPY --chown=liferay:liferay build.gradle .
COPY --chown=liferay:liferay configs/$TARGET_ENV configs/$TARGET_ENV
COPY --chown=liferay:liferay themes themes
COPY --chown=liferay:liferay modules modules

RUN ./gradlew initBundle -Pliferay.workspace.environment=$TARGET_ENV

EXPOSE 8080 8000 11311

ENTRYPOINT ["./docker-entrypoint.sh"]
