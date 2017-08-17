#!/usr/bin/env bash
set -e

# Verifies that the generated Java code compiles
java -classpath /usr/bin/swagger-codegen-cli-2.2.2.jar \
  io.swagger.codegen.Codegen \
  --input-spec static/swagger/swagger.json \
  --config config/android.json \
  --lang java \
  --output generated/java

mvn --file generated/java/pom.xml compile
