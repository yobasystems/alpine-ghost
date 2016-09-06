# Alpine Ghost Docker image

[![Docker Stars](https://img.shields.io/docker/stars/yobasystems/alpine-ghost.svg)](https://imagelayers.io/?images=yobasystems/alpine-ghost:latest)

[![Docker Pulls](https://img.shields.io/docker/pulls/yobasystems/alpine-ghost.svg)](https://imagelayers.io/?images=yobasystems/alpine-ghost:latest)

[![Image Size](https://img.shields.io/imagelayers/image-size/yobasystems/alpine-ghost/latest.svg)](https://imagelayers.io/?images=yobasystems/alpine-ghost:latest)

[![Image Layers](https://img.shields.io/imagelayers/layers/yobasystems/alpine-ghost/latest.svg)](https://imagelayers.io/?images=yobasystems/alpine-ghost:latest)


[This](https://hub.docker.com/r/yobasystems/alpine-ghost/) Docker image is based on the minimal [Alpine Linux latest](http://alpinelinux.org/) using the nodejs 6.2.0 Alpine docker image [yobasystems/alpine-nodejs](https://hub.docker.com/r/yobasystems/alpine-nodejs/).

## Features

  * Minimal size: 189Mb uncompressed, and only 11 layers.
  * Memory usage is minimal on a simple install.
  * Node Version 6.2.0
  * NPM Version 3.8.9
  * Ghost Version 0.9.0

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
* `GID`: `991` specify the Group ID of the files
* `UID`: `991` specify the User ID of the files
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
