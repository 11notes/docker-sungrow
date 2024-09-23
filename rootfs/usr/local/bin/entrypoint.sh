#!/bin/ash
  if [ -z "${1}" ]; then
    GoSungrow config write --user=${GOSUNGROW_USER} --password=${GOSUNGROW_PASSWORD} --host=${GOSUNGROW_HOST}
    SUNGROW_LOGIN=$(GoSungrow api login)
    if echo "$SUNGROW_LOGIN" | grep -qE "Login State:.+1"; then
      elevenLogJSON info "starting ${APP_NAME} (${APP_VERSION})"
      set -- "GoSungrow" \
        mqtt \
        sync
    else
      elevenLogJSON error "could not login to SunGrow!"
    fi
  fi

  exec "$@"