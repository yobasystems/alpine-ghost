FROM yobasystems/alpine-nodejs:lts

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Dominic Taylor <dominic@yoba.systems>" \
    architecture="amd64/x86_64" \
    ghost-version="6.9.3" \
    alpine-version="3.22.2" \
    build="30-Nov-2025" \
    org.opencontainers.image.title="alpine-ghost" \
    org.opencontainers.image.description="Ghost container image running on Alpine Linux" \
    org.opencontainers.image.authors="Dominic Taylor <dominic@yoba.systems>" \
    org.opencontainers.image.vendor="Yoba Systems" \
    org.opencontainers.image.version="6.9.3" \
    org.opencontainers.image.url="https://hub.docker.com/r/yobasystems/alpine-ghost/" \
    org.opencontainers.image.source="https://github.com/yobasystems/alpine-ghost" \
	org.opencontainers.image.base.name="docker.io/yobasystems/alpine-nodejs:amd64" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

RUN apk add --no-cache \
# add "bash" for "[["
		bash

ENV GOSU_VERSION=1.19
RUN set -eux; \
	\
	apk add --no-cache --virtual .gosu-deps \
		ca-certificates \
		dpkg \
		gnupg \
	; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
# clean up fetch dependencies
	apk del --no-network .gosu-deps; \
	\
	chmod +x /usr/local/bin/gosu; \
# verify that the binary works
	gosu --version; \
	gosu nobody true
RUN set -eux; ln -svf gosu /usr/local/bin/su-exec; su-exec nobody true # backwards compatibility (TODO remove in Ghost 6+)

ENV NODE_ENV=production \
    GHOST_CLI_VERSION=1.28.3

RUN set -eux; \
    npm install -g "ghost-cli@$GHOST_CLI_VERSION"; \
    npm cache clean --force
    
ENV GHOST_INSTALL=/var/lib/ghost \
    GHOST_CONTENT=/var/lib/ghost/content \
    GHOST_VERSION=6.9.3

RUN set -eux; \
	mkdir -p "$GHOST_INSTALL"; \
	chown node:node "$GHOST_INSTALL"; \
	\
	apkDel=; \
	\
	installCmd='gosu node ghost install "$GHOST_VERSION" --db mysql --dbhost mysql --no-prompt --no-stack --no-setup --dir "$GHOST_INSTALL"'; \
	if ! eval "$installCmd"; then \
		virtual='.build-deps-ghost'; \
		apkDel="$apkDel $virtual"; \
		apk add --no-cache --virtual "$virtual" g++ linux-headers make python3; \
		eval "$installCmd"; \
	fi; \
	\
# Tell Ghost to listen on all ips and not prompt for additional configuration
	cd "$GHOST_INSTALL"; \
	gosu node ghost config --no-prompt --ip '::' --port 2368 --url 'http://localhost:2368'; \
	gosu node ghost config paths.contentPath "$GHOST_CONTENT"; \
	\
# make a config.json symlink for NODE_ENV=development (and sanity check that it's correct)
	gosu node ln -s config.production.json "$GHOST_INSTALL/config.development.json"; \
	readlink -f "$GHOST_INSTALL/config.development.json"; \
	\
# need to save initial content for pre-seeding empty volumes
	mv "$GHOST_CONTENT" "$GHOST_INSTALL/content.orig"; \
	mkdir -p "$GHOST_CONTENT"; \
	chown node:node "$GHOST_CONTENT"; \
	chmod 1777 "$GHOST_CONTENT"; \
	\
# force install a few extra packages manually since they're "optional" dependencies
# (which means that if it fails to install, like on ARM/ppc64le/s390x, the failure will be silently ignored and thus turn into a runtime error instead)
# see https://github.com/TryGhost/Ghost/pull/7677 for more details
	cd "$GHOST_INSTALL/current"; \
# scrape the expected versions directly from Ghost/dependencies
	packages="$(node -p ' \
		var ghost = require("./package.json"); \
		var transform = require("./node_modules/@tryghost/image-transform/package.json"); \
		[ \
			"sharp@" + transform.optionalDependencies["sharp"], \
			"sqlite3@" + ghost.optionalDependencies["sqlite3"], \
		].join(" ") \
	')"; \
	if echo "$packages" | grep 'undefined'; then exit 1; fi; \
	for package in $packages; do \
		installCmd='gosu node npm install "$package" --force'; \
		if ! eval "$installCmd"; then \
# must be some non-amd64 architecture pre-built binaries aren't published for, so let's install some build deps and do-it-all-over-again
			virtualPackages='g++ make python3 py3-setuptools'; \
			case "$package" in \
				sharp@*) virtualPackages="$virtualPackages pkgconf vips-dev"; \
			esac; \
			virtual=".build-deps-${package%%@*}"; \
			apkDel="$apkDel $virtual"; \
			apk add --no-cache --virtual "$virtual" $virtualPackages; \
			\
			eval "$installCmd --build-from-source"; \
		fi; \
	done; \
	\
	if [ -n "$apkDel" ]; then \
		apk del --no-network $apkDel; \
	fi; \
	\
	gosu node npm cache clean --force; \
	npm cache clean --force; \
	find /tmp -name 'npm*' -o -name 'v8*' | xargs rm -rf || true

WORKDIR $GHOST_INSTALL
VOLUME $GHOST_CONTENT

COPY files/docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 2368
CMD ["node", "current/index.js"]
