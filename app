#!/bin/bash

case "$1" in
  server)
    hugo server \
      --port=${HUGO_PORT} \
      --baseURL=http://localhost:${HUGO_PORT} \
      --bind=0.0.0.0 \
      --watch=false \
      --destination=/usr/share/generated \
      --disableRSS \
      --disableSitemap
  ;;
  compile)
    /usr/share/blog/specs/java/compile.sh /usr/bin/swagger-codegen-cli-2.2.3.jar
  ;;
  test)
    /usr/share/blog/specs/java/test.sh /usr/bin/swagger-codegen-cli-2.2.3.jar "${@:2}"
  ;;
  *)
    exit 1
  ;;
esac
