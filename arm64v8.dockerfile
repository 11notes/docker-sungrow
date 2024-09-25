# :: QEMU
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;

# :: Build
  FROM --platform=linux/arm64 golang:alpine as build
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  COPY --from=util /util/linux/shell/elevenGoModCVE /usr/local/bin
  ARG BUILD_VERSION=3.0.7
  ARG BUILD_ROOT=/go/GoSungrow

  RUN set -ex; \
    apk add --no-cache \
      curl \
      wget \
      unzip \
      build-base \
      linux-headers \
      make \
      cmake \
      g++ \
      git;

  RUN set -ex; \
    git clone https://github.com/MickMake/GoSungrow.git -b v${BUILD_VERSION}; \
    cd /;\
    git clone https://github.com/MickMake/GoUnify.git;

  COPY ./build /
  
  RUN set -ex; \
    cd ${BUILD_ROOT}; \
    git remote add -t encryption triamazikamno https://github.com/triamazikamno/GoSungrow.git; \
    git pull triamazikamno encryption; \
    git switch encryption; \
    git apply --reject --ignore-space-change --ignore-whitespace /GoSungrow.patch;
  
  RUN set -ex; \
    cd ${BUILD_ROOT}; \
    chmod +x -R /usr/local/bin; \
    elevenGoModCVE \
      "golang.org/x/net|v0.23.0|CVE-2023-45288/CVE-2023-44487/CVE-2023-39325" \
      "golang.org/x/crypto|v0.17.0|CVE-2023-45288/CVE-2023-48795" \
      "golang.org/x/image|v0.18.0|CVE-2023-36308/CVE-2024-24792" \
      "github.com/gomarkdown/markdown|v0.0.0-20230922105210-14b16010c2ee|CVE-2023-42821"; \
    go mod tidy;

  RUN set -ex; \
    cd ${BUILD_ROOT}; \
    go build -o /usr/local/bin;

# :: Header
  FROM --platform=linux/arm64 11notes/alpine:stable
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  COPY --from=util /util/linux/shell/elevenLogJSON /usr/local/bin
  COPY --from=build /usr/local/bin/ /usr/local/bin
  ENV APP_NAME="sungrow"
  ENV APP_VERSION=3.0.7
  ENV APP_ROOT=/sungrow
  ENV HOME=/sungrow/etc
  ENV GOSUNGROW_APPKEY=B0455FBE7AA0328DB57B59AA729F05D8
  ENV GOSUNGROW_MQTT_CLIENT_ID="GoSungrow"
  ENV GOSUNGROW_MQTT_TOPIC="mqtt"
  ENV GOSUNGROW_MQTT_CRON="*/5 * * * *"

  # :: Run
    USER root

  # :: prepare image
    RUN set -ex; \
      mkdir -p ${APP_ROOT}; \
      mkdir -p ${APP_ROOT}/etc; 

  # :: update image
    RUN set -ex; \
      apk --no-cache --update upgrade;

  # :: copy root filesystem changes and add execution rights to init scripts
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin

  # :: change home path for existing user and set correct permission
    RUN set -ex; \
      usermod -d ${APP_ROOT} docker; \
      chown -R 1000:1000 \
        ${APP_ROOT};

# :: Volumes
  VOLUME ["${APP_ROOT}/etc"]

# :: Monitor
  HEALTHCHECK CMD /usr/local/bin/healthcheck.sh || exit 1

# :: Start
  USER docker
  ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]