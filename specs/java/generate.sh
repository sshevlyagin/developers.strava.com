#!/usr/bin/env bash
set -e

# First parameter: The path to the Swagger Codegen JAR file
# Second parameter: The path to output files to

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TMP_DIR="$( mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir' )"
API_SPECIFICATION=$TMP_DIR/apispec
$BASEDIR/../../scripts/generate_swagger_spec.sh local $API_SPECIFICATION

java -classpath $1 \
  io.swagger.codegen.Codegen \
  --input-spec $API_SPECIFICATION/swagger.json \
  --config $BASEDIR/config.json \
  --lang java \
  --output $2
