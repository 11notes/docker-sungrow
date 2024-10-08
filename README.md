![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine - SunGrow
![size](https://img.shields.io/docker/image-size/11notes/sungrow/3.0.7?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/sungrow/3.0.7?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/sungrow?color=2b75d6)

**Use GoSungrow with MQTT via SSL**

# SYNOPSIS
What can I do with this? This image will let you run GoSungrow and export all data via MQTT to whatever backend you run. To increase security this image will by default run via SSL and validate the certificate presented. Do not use with self-signed certificates.

# VOLUMES
* **/sungrow/etc** - Directory of .GoSungrow/config.json

# COMPOSE
```yaml
services:
  sungrow:
    image: "11notes/sungrow:3.0.7"
    container_name: "sungrow"
    environment:
      TZ: "Europe/Zurich"
      GOSUNGROW_USER: "user"
      GOSUNGROW_PASSWORD: "*********************"
      GOSUNGROW_HOST: "https://gateway.isolarcloud.eu"
      GOSUNGROW_MQTT_HOST: "mqtt.domain.com"
      GOSUNGROW_MQTT_USER: "user"
      GOSUNGROW_MQTT_PASSWORD: "*********************"
      GOSUNGROW_MQTT_PORT: 8883
      GOSUNGROW_MQTT_TOPIC: "mqtt.domain.com/home/solar/sungrow"
    volumes:
      - "etc:/sungrow/etc"
    restart: always
volumes:
  etc:
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /sungrow | home directory of user docker |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |
| `GOSUNGROW_MQTT_CLIENT_ID` | MQTT client id | "GoSungrow" |
| `GOSUNGROW_MQTT_TOPIC` | MQTT topic used | "mqtt" |
| `GOSUNGROW_MQTT_CRON` | MQTT sync interval (must be equal or more than 5 minutes) | "*/5 * * * *" |
| `GOSUNGROW_****` | All other available GoSungrow variables | |

# SOURCE
* [11notes/sungrow](https://github.com/11notes/docker-sungrow)

# PARENT IMAGE
* [11notes/alpine:stable](https://hub.docker.com/r/11notes/alpine)

# BUILT WITH
* [MickMake/GoSungrow](https://github.com/MickMake/GoSungrow)
* [alpine](https://alpinelinux.org)

# TIPS
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a new version. Check the changelog for breaking changes. You can find all my repositories on [github](https://github.com/11notes).
    