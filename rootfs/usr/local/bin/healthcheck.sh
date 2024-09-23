#!/bin/ash
  SUNGROW_HEALTHCHECK=$(GoSungrow api ls healthcheck)
  echo "$SUNGROW_HEALTHCHECK" | grep -qE "Login State:.+1"