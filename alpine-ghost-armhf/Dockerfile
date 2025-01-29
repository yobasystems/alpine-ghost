FROM yobasystems/alpine-nodejs:armhf

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Dominic Taylor <dominic@yoba.systems>" \
    architecture="arm32v7/armhf" \
    ghost-version="5.108.1" \
    alpine-version="3.21.1" \
    build="29-Jan-2025" \
    org.opencontainers.image.title="alpine-ghost" \
    org.opencontainers.image.description="Ghost container image running on Alpine Linux" \
    org.opencontainers.image.authors="Dominic Taylor <dominic@yoba.systems>" \
    org.opencontainers.image.vendor="Yoba Systems" \
    org.opencontainers.image.version="5.108.1" \
    org.opencontainers.image.url="https://hub.docker.com/r/yobasystems/alpine-ghost/" \
    org.opencontainers.image.source="https://github.com/yobasystems/alpine-ghost" \
	org.opencontainers.image.base.name="docker.io/yobasystems/alpine-nodejs:armhf" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

	ENV NODE_ENV production
	ENV GHOST_INSTALL /var/lib/ghost
	ENV GHOST_CONTENT /var/lib/ghost/content
	ENV GHOST_CLI_VERSION 1.25.3
	ENV GHOST_VERSION 5.108.1
	
	# Install base dependencies
	RUN apk add --no-cache 'su-exec>=0.2' bash g++ make python3 linux-headers gyp-pyc gyp
	
	# Install Ghost CLI and prepare directories
	RUN set -eux; \
		mkdir -p "$GHOST_INSTALL"; \
		chown node:node "$GHOST_INSTALL"; \
		npm install -g "ghost-cli@$GHOST_CLI_VERSION"; \
		npm cache clean --force
	
	# Install Ghost and configure
	RUN set -eux; \
		cd "$GHOST_INSTALL"; \
		su-exec node ghost install "$GHOST_VERSION" --db mysql --dbhost mysql --no-prompt --no-stack --no-setup --dir "$GHOST_INSTALL"; \
		su-exec node ghost config --no-prompt --ip '::' --port 2368 --url 'http://localhost:2368'; \
		su-exec node ghost config paths.contentPath "$GHOST_CONTENT"; \
		\
		su-exec node ln -s config.production.json "$GHOST_INSTALL/config.development.json"; \
		readlink -f "$GHOST_INSTALL/config.development.json"; \
		\
		mv "$GHOST_CONTENT" "$GHOST_INSTALL/content.orig"; \
		mkdir -p "$GHOST_CONTENT"; \
		chown node:node "$GHOST_CONTENT"; \
		chmod 1777 "$GHOST_CONTENT"
	
	# Install additional packages
	RUN set -eux; \
		cd "$GHOST_INSTALL/current"; \
		packages="$(node -p ' \
			var ghost = require("./package.json"); \
			var transform = require("./node_modules/@tryghost/image-transform/package.json"); \
			[ \
				"sqlite3@" + ghost.optionalDependencies["sqlite3"], \
			].join(" ") \
		')"; \
		if echo "$packages" | grep 'undefined'; then exit 1; fi; \
		for package in $packages; do \
			su-exec node yarn add "$package" --force --build-from-source; \
		done; \
		\
		su-exec node yarn cache clean; \
		su-exec node npm cache clean --force; \
		npm cache clean --force; \
		rm -rv /tmp/yarn* /tmp/v8*
	
	
	WORKDIR $GHOST_INSTALL
	VOLUME $GHOST_CONTENT
	
	COPY files/docker-entrypoint.sh /usr/local/bin
	ENTRYPOINT ["docker-entrypoint.sh"]
	
	EXPOSE 2368
	CMD ["node", "current/index.js"]
	