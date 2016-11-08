# Ghost Docker image running on Alpine Linux

[![Docker Layers](https://img.shields.io/badge/docker%20layers-12-blue.svg?maxAge=2592000?style=flat-square)](https://hub.docker.com/r/yobasystems/alpine-ghost/) [![Docker Size](https://img.shields.io/badge/docker%20size-36.7%20MB-blue.svg?maxAge=2592000?style=flat-square)](https://hub.docker.com/r/yobasystems/alpine-ghost/) [![Docker Stars](https://img.shields.io/docker/stars/yobasystems/alpine-ghost.svg?maxAge=2592000?style=flat-square)](https://hub.docker.com/r/yobasystems/alpine-ghost/) [![Docker Pulls](https://img.shields.io/docker/pulls/yobasystems/alpine-ghost.svg?maxAge=2592000?style=flat-square)](https://hub.docker.com/r/yobasystems/alpine-ghost/)

[![Alpine Version](https://img.shields.io/badge/alpine%20version-v3.4-green.svg?maxAge=2592000?style=flat-square)](http://alpinelinux.org/) [![nodejs Version](https://img.shields.io/badge/nodejs%20version-v6.2.0-green.svg?maxAge=2592000?style=flat-square)](https://nodejs.org/en/) [![Ghost Version](https://img.shields.io/badge/Ghost%20version-v0.11.3-green.svg?maxAge=2592000?style=flat-square)](https://ghost.org/)



This Docker image [(yobasystems/alpine-ghost)](https://hub.docker.com/r/yobasystems/alpine-ghost/) is based on the minimal [Alpine Linux](http://alpinelinux.org/) using the nodejs Alpine docker image [yobasystems/alpine-nodejs](https://hub.docker.com/r/yobasystems/alpine-nodejs/).

## Features

  * Minimal size only 36.7 MB and only 12 layers
  * Memory usage is minimal on a simple install
  * Node Version 6.2.0
  * NPM Version 3.8.9
  * Ghost Version 0.11.3
  * su-exec instead of gosu because it's fully gosu-compatible in a fraction of the file size.

## Creating an instance

```bash
docker run --name some-ghost -d yobasystems/alpine-ghost
```

This will start a Ghost instance listening on the default Ghost port of 2368.

If you'd like to be able to access the instance from the host without the container's IP, standard port mappings can be used:

```bash
docker run --name some-ghost -p 80:2368 -d yobasystems/alpine-ghost
```

Then, access it via http://localhost or http://host-ip in a browser.

You can also point the image to your existing content on your host:

```bash
docker run --name some-ghost -v /path/on/host:/ghost/content yobasystems/alpine-ghost
```

Alternatively you can use a data container that has a volume that points to /ghost and then reference it:

```bash
docker run --name some-ghost --volumes-from some-ghost-data yobasystems/alpine-ghost
```

## Environment Variables:

### Main config.js parameters:
* `URL`: specify the ghost url with http:// or https://
* `GID`: `1027` specify the Group ID of the files
* `UID`: `1027` specify the User ID of the files
* `SYNTAX_HIGHLIGHTING`: `True` specify if Syntax Highlighting is enabled in ghost
* `HIGHLIGHTER_COLOR`: `dark` specify the colour scheme for Syntax Highlighting

#### Email (defaults to False meaning no emails):
* `CUSTOM_SMTP`: specify custom email service. This can be True or False.
* `SERVICE`: specify email service. This can be Mailgun, Sendgrid or Gmail.
* `SMTP_USER`: specify email service smtp username
* `SMTP_PASS`: specify email service smtp password

> http://support.ghost.org/config/

## Docker Compose example:

```yalm
ghost:
  image: yobasystems/alpine-ghost
  command: npm start --production
  environment:
    URL: https://www.example.co.uk
    SYNTAX_HIGHLIGHTING: True
    HIGHLIGHTER_COLOR: dark
    CUSTOM_SMTP: True
    SERVICE: Sendgrid
    SMTP_USER: user@example.co.uk
    SMTP_PASS: RANd0Mpa55w0Rd
  expose:
    - "2368"
  volumes:
    - /app/ghost:/ghost/content
  domainname: www.example.co.uk
  restart: always
```

## Source Repository

* [Bitbucket - yobasystems/alpine-ghost](https://bitbucket.org/yobasystems/alpine-ghost/)

* [Github - yobasystems/alpine-ghost](https://github.com/yobasystems/alpine-ghost)

## Links

* [Yoba Systems](https://www.yobasystems.co.uk/)

* [Dockerhub - yobasystems](https://hub.docker.com/u/yobasystems/)
