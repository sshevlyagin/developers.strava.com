#!/bin/bash

scripts/generate_swagger_spec.sh local static/swagger

mvn --file codegen/pom.xml package

java -classpath codegen/target/static-html-codegen-1.0.0.jar:$1 \
  io.swagger.codegen.SwaggerCodegen \
  generate \
  --input-spec static/swagger/swagger.json \
  --config config/strava-html.json \
  --lang strava-html \
  --output content/docs

hugo server --port=$2 \
  --baseURL=http://localhost:$2 \
  --bind 0.0.0.0 \
  --watch=true \
  --disableRSS \
  --disableSitemap
