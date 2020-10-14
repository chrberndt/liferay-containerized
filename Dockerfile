FROM azul/zulu-openjdk-alpine:11

ARG LIFERAY_UID

RUN addgroup -S liferay && adduser -S liferay -G liferay -u ${LIFERAY_UID:-100} && \
    apk --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.10/main/ \
    add gcompat

USER liferay

WORKDIR /home/liferay

COPY --chown=liferay:liferay gradle gradle
COPY --chown=liferay:liferay gradlew .
COPY --chown=liferay:liferay gradle.properties .

RUN BUNDLE_URL=$(cat gradle.properties | grep liferay.workspace.bundle.url= | cut -d'=' -f2) && \
    mkdir -p .liferay/bundles && \
    wget -P .liferay/bundles "$BUNDLE_URL" && \
    ./gradlew

ARG TARGET_ENV=prod

COPY --chown=liferay:liferay settings.gradle .
COPY --chown=liferay:liferay build.gradle .
COPY --chown=liferay:liferay configs/common configs/common
COPY --chown=liferay:liferay configs/$TARGET_ENV configs/$TARGET_ENV

RUN ./gradlew initBundle -Pliferay.workspace.environment=$TARGET_ENV && \
    rm -r bundles/osgi/state

COPY --chown=liferay:liferay modules modules
COPY --chown=liferay:liferay themes themes

RUN ./gradlew deploy

FROM azul/zulu-openjdk-alpine:11

ARG LIFERAY_UID
ENV LIFERAY_HOME=/opt/liferay
ENV TOMCAT_VERSION=9.0.37

RUN addgroup -S liferay && adduser -S liferay -G liferay -u ${LIFERAY_UID:-100}

COPY --chown=liferay:liferay start-liferay.sh .
COPY --chown=liferay:liferay --from=0 /home/liferay/bundles $LIFERAY_HOME

RUN mv $LIFERAY_HOME/tomcat-$TOMCAT_VERSION $LIFERAY_HOME/tomcat

ENV DEBUG_PORT=8000
ENV JPDA_ADDRESS=*:$DEBUG_PORT
ENV LIFERAY_JPDA_ENABLED=false
ENV CATALINA_HOME=$LIFERAY_HOME/tomcat

EXPOSE 8080 11311 $DEBUG_PORT

ENTRYPOINT ["./start-liferay.sh"]
