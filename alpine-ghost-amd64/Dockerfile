FROM yobasystems/alpine-nodejs:min-amd64

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Dominic Taylor <dominic@yoba.systems>" \
    architecture="amd64/x86_64" \
    ghost-version="5.67.0" \
    alpine-version="3.18.4" \
    build="04-Oct-2023" \
    org.opencontainers.image.title="alpine-ghost" \
    org.opencontainers.image.description="Ghost container image running on Alpine Linux" \
    org.opencontainers.image.authors="Dominic Taylor <dominic@yoba.systems>" \
    org.opencontainers.image.vendor="Yoba Systems" \
    org.opencontainers.image.version="v5.67.0" \
    org.opencontainers.image.url="https://hub.docker.com/r/yobasystems/alpine-ghost/" \
    org.opencontainers.image.source="https://github.com/yobasystems/alpine-ghost" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

ENV NODE_ENV production
ENV GHOST_INSTALL /var/lib/ghost
ENV GHOST_CONTENT /var/lib/ghost/content
ENV GHOST_CLI_VERSION 1.25.1

RUN apk add --no-cache 'su-exec>=0.2' bash && \
    npm install -g node-gyp && \
    npm install -g "ghost-cli@$GHOST_CLI_VERSION"

ENV GHOST_VERSION 5.67.0

RUN set -ex; \
	mkdir -p "$GHOST_INSTALL"; \
	chown node:node "$GHOST_INSTALL"; \
	\
	su-exec node ghost install "$GHOST_VERSION" --db sqlite3 --no-prompt --no-stack --no-setup --dir "$GHOST_INSTALL"; \
	\
	cd "$GHOST_INSTALL"; \
	su-exec node ghost config --ip 0.0.0.0 --port 2368 --no-prompt --db sqlite3 --url http://localhost:2368 --dbpath "$GHOST_CONTENT/data/ghost.db"; \
	su-exec node ghost config paths.contentPath "$GHOST_CONTENT"; \
	\
	su-exec node ln -s config.production.json "$GHOST_INSTALL/config.development.json"; \
	readlink -f "$GHOST_INSTALL/config.development.json"; \
	\
	mv "$GHOST_CONTENT" "$GHOST_INSTALL/content.orig"; \
	mkdir -p "$GHOST_CONTENT"; \
	chown node:node "$GHOST_CONTENT"


WORKDIR $GHOST_INSTALL
VOLUME $GHOST_CONTENT

COPY files/docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 2368
CMD ["node", "current/index.js"]
