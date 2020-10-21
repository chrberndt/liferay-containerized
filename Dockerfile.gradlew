FROM azul/zulu-openjdk-alpine:11

ARG LIFERAY_UID

RUN addgroup -S liferay && adduser -S liferay -G liferay -u ${LIFERAY_UID:-100} && \
    apk --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.10/main/ add \
    gcompat

USER liferay

WORKDIR /home/liferay

COPY --chown=liferay:liferay gradle gradle
COPY --chown=liferay:liferay gradlew .
COPY --chown=liferay:liferay gradle.properties .

RUN ./gradlew

COPY --chown=liferay:liferay settings.gradle .
COPY --chown=liferay:liferay build.gradle .
COPY --chown=liferay:liferay themes themes
COPY --chown=liferay:liferay modules modules

ENTRYPOINT ["./gradlew"]
CMD ["-t","deploy"]
