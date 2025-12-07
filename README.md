# Ghost container image running on Alpine Linux

[![Docker Automated build](https://img.shields.io/docker/automated/yobasystems/alpine-ghost.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/yobasystems/alpine-ghost/)
[![Docker Pulls](https://img.shields.io/docker/pulls/yobasystems/alpine-ghost.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/yobasystems/alpine-ghost/)
[![Docker Stars](https://img.shields.io/docker/stars/yobasystems/alpine-ghost.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/yobasystems/alpine-ghost/)

[![Alpine Version](https://img.shields.io/badge/Alpine%20version-v3.23.0-green.svg?style=for-the-badge&logo=alpine-linux)](https://alpinelinux.org/)
[![Ghost Version](https://img.shields.io/badge/Ghost%20version-v6.9.3-green.svg?style=for-the-badge)](https://ghost.org/)

This container image [(yobasystems/alpine-ghost)](https://hub.docker.com/r/yobasystems/alpine-ghost/) is based on the minimal [Alpine Linux](http://alpinelinux.org/) using the `yobasystems/alpine-nodejs` base container image [yobasystems/alpine-nodejs](https://hub.docker.com/r/yobasystems/alpine-nodejs/).

### Alpine Version 3.23.0 (Released 2025-12-03)

##### Ghost Version 6.9.3

---

## Table of Contents

- [What is Alpine Linux?](#what-is-alpine-linux)
- [Features](#features)
- [Architectures](#architectures)
- [Tags](#tags)
- [Layers & Sizes](#layers--sizes)
- [How to use this image](#how-to-use-this-image)
- [Image contents & Vulnerability analysis](#image-contents--vulnerability-analysis)
- [Source Repositories](#source-repositories)
- [Container Registries](#container-registries)
- [Links](#links)

## 🏔️ What is Alpine Linux?

Alpine Linux is a Linux distribution built around musl libc and BusyBox. The image is only 5 MB in size and has access to a package repository that is much more complete than other BusyBox based images. This makes Alpine Linux a great image base for utilities and even production applications. Read more about Alpine Linux here and you can see how their mantra fits in right at home with container images.

## What is Ghost?

Ghost is a powerful app for new-media creators to publish, share, and grow a business around their content. It comes with modern tools to build a website, publish content, send newsletters & offer paid subscriptions to members.

## ✨ Features

- Minimal size only, minimal layers
- Memory usage is minimal on a simple install.

## 🏗️ Architectures

- `:amd64`, `:x86_64` - 64 bit Intel/AMD (x86_64/amd64)
- `:arm64v8`, `:aarch64` - 64 bit ARM (ARMv8/aarch64)
- `:arm32v7`, `:armhf` - 32 bit ARM (ARMv7/armhf)

## 🏷️ Tags

- `:latest` latest branch based (Automatic Architecture Selection)
- `:main` main branch usually inline with latest
- `:amd64`, `:x86_64` amd64 based on latest tag but amd64 architecture
- `:aarch64`, `:arm64v8` Armv8 based on latest tag but arm64 architecture
- `:armhf`, `:arm32v7` Armv7 based on latest tag but arm32 architecture
- `:v6.9.3` version number related to Ghost version

## 📏 Layers & Sizes

![Version](https://img.shields.io/badge/version-amd64-blue.svg?style=for-the-badge)
![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/yobasystems/alpine-ghost/amd64.svg?style=for-the-badge)

![Version](https://img.shields.io/badge/version-aarch64-blue.svg?style=for-the-badge)
![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/yobasystems/alpine-ghost/aarch64.svg?style=for-the-badge)

![Version](https://img.shields.io/badge/version-armhf-blue.svg?style=for-the-badge)
![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/yobasystems/alpine-ghost/armhf.svg?style=for-the-badge)

## 🚀 How to use this image

## Environment Variables:

### Main config.js parameters:

- `URL`: specify the ghost url with http:// or https://
- `GID`: `1027` specify the Group ID of the files
- `UID`: `1027` specify the User ID of the files
- `SYNTAX_HIGHLIGHTING`: `True` specify if Syntax Highlighting is enabled in ghost
- `HIGHLIGHTER_COLOR`: `dark` specify the colour scheme for Syntax Highlighting

#### Email (defaults to False meaning no emails):

- `CUSTOM_SMTP`: specify custom email service. This can be True or False.
- `SERVICE`: specify email service. This can be Mailgun, Sendgrid or Gmail.
- `SMTP_USER`: specify email service smtp username
- `SMTP_PASS`: specify email service smtp password

> http://support.ghost.org/config/

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

## Docker Compose example:

##### (Please pass your own credentials or let them be generated automatically, don't use these ones for production!!)

```yaml
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

## 🔍 Image contents & Vulnerability analysis

| PACKAGE NAME | PACKAGE VERSION | VULNERABILITIES |
| ------------ | --------------- | --------------- |

## 📚 Source Repositories

- [Github - yobasystems/alpine-ghost](https://github.com/yobasystems/alpine-ghost)
- [Gitlab - yobasystems/alpine-ghost](https://gitlab.com/yobasystems/alpine-ghost)

## 🐳 Container Registries

- [Dockerhub - yobasystems/alpine-ghost](https://hub.docker.com/r/yobasystems/alpine-ghost/)
- [Quay.io - yobasystems/alpine-ghost](https://quay.io/repository/yobasystems/alpine-ghost)
- [GHCR - yobasystems/alpine-ghost](https://ghcr.io/yobasystems/alpine-ghost)

## 🔗 Links

- [Yoba Systems](https://yoba.systems/)
- [Github - Yoba Systems](https://github.com/yobasystems/)
- [Dockerhub - Yoba Systems](https://hub.docker.com/u/yobasystems/)
- [Quay.io - Yoba Systems](https://quay.io/organization/yobasystems)
- [GHCR - Yoba Systems](https://ghcr.io/yobasystems)
- [Maintainer - Dominic Taylor](https://github.com/dominictayloruk)
