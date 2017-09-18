FROM java:8-jdk
ARG MODE=prod

## Supporting packages

RUN apt-get -qq update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends maven python-pygments git ca-certificates asciidoc ruby \
	&& rm -rf /var/lib/apt/lists/*

## Swagger

RUN mkdir -p /usr/bin
ADD https://oss.sonatype.org/content/repositories/releases/io/swagger/swagger-codegen-cli/2.2.3/swagger-codegen-cli-2.2.3.jar \
  /usr/bin/swagger-codegen-cli-2.2.3.jar

## Hugo

# Download and install Hugo
ENV HUGO_VERSION 0.22
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb

ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN dpkg -i /tmp/hugo.deb \
	&& rm /tmp/hugo.deb

## Mustache

RUN gem install mustache

## Content setup

RUN mkdir /usr/share/blog
WORKDIR /usr/share/blog
COPY . /usr/share/blog

# Compiles the documentation generator
RUN mvn -f codegen/pom.xml package

# Generates the Swagger spec itself
RUN scripts/generate_swagger_spec.sh $MODE static/swagger

# Generate the documentation
# We need to regenerate the Swagger spec in local mode to make sure we pick
# up the changes that are packaged in this container. The
# static/swagger/swagger.json configuration is canonical for production and
# may refer to production models and endpoints, whereas this container may be
# built locally
RUN scripts/generate_swagger_spec.sh local /tmp/swagger
RUN java -classpath codegen/target/static-html-codegen-1.0.0.jar:/usr/bin/swagger-codegen-cli-2.2.3.jar \
  io.swagger.codegen.Codegen \
  --input-spec /tmp/swagger/swagger.json \
  --config config/strava-html.json \
  --lang strava-html \
  --output content/docs

# Final command configuration
ENV HUGO_PORT 1313
EXPOSE ${HUGO_PORT}
ENTRYPOINT ["./app"]
