#!/bin/bash

swagger-codegen generate -i static/swagger/swagger.json -c config/android.json -l java -o generated/java
swagger-codegen generate -i static/swagger/swagger.json -c config/objc.json -l objc -o generated/objc

mvn -f codegen/pom.xml clean
mvn -f codegen/pom.xml package
java -cp codegen/target/static-html-codegen-1.0.0.jar:/usr/local/Cellar/swagger-codegen/2.2.2/libexec/swagger-codegen-cli.jar io.swagger.codegen.Codegen -i static/swagger/swagger.json -c config/strava-html.json -l strava-html -o content/docs
