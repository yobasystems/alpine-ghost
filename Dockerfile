FROM yobasystems/alpine-nodejs:min
MAINTAINER Dominic Taylor <dominic@yobasystems.co.uk>

ARG VERSION=0.11.4

ENV GHOST_NODE_VERSION_CHECK=false \
    GID=1027 \
    UID=1027 \
    URL=http://www.my-ghost-blog.com \
    SYNTAX_HIGHLIGHTING=True \
    HIGHLIGHTER_COLOR=dark \
    CUSTOM_SMTP=False \
    SERVICE=Sendgrid \
    SMTP_PASS=12345 \
    SMTP_USER=user

VOLUME /ghost/content

RUN apk -U add \
    ca-certificates \
    bash \
    grep \
    wget \
    tini \
    su-exec \
 && wget -q https://ghost.org/zip/ghost-$VERSION.zip -P /tmp \
 && unzip -q /tmp/ghost-$VERSION.zip -d /ghost \
 && cd /ghost \
 && npm install --production \
 && mv content/themes/casper casper \
 && mv config.example.js config.js \
 && sed -i 's/127.0.0.1/0.0.0.0/g' config.js \
 && npm cache clean \
 && apk del ca-certificates \
 && rm -rf /tmp/* /var/cache/apk/*

COPY files/run.sh /usr/local/bin/run.sh
COPY files/smtp.conf /usr/local/etc/smtp.conf
COPY files/prism_light.js /ghost/prismjs/light/prism.js
COPY files/prism_light.css /ghost/prismjs/light/prism.css
COPY files/prism_dark.js /ghost/prismjs/dark/prism.js
COPY files/prism_dark.css /ghost/prismjs/dark/prism.css
COPY files/prism.js.conf /usr/local/etc/prism.js.conf
COPY files/prism.css.conf /usr/local/etc/prism.css.conf

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 2368

LABEL description="Ghost Blog - Production Ready" \
      ghost="Ghost v$VERSION"

CMD ["tini","--","run.sh"]
