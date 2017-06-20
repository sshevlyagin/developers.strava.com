FROM java:8-jre

## Supporting packages

RUN apt-get -qq update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends maven python-pygments git ca-certificates asciidoc \
	&& rm -rf /var/lib/apt/lists/*

## Swagger

RUN mkdir -p /usr/bin
ADD https://oss.sonatype.org/content/repositories/releases/io/swagger/swagger-codegen-cli/2.2.2/swagger-codegen-cli-2.2.2.jar \
  /usr/bin/swagger-codegen-cli-2.2.2.jar

## Hugo

# Download and install Hugo
ENV HUGO_VERSION 0.22
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb

ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN dpkg -i /tmp/hugo.deb \
	&& rm /tmp/hugo.deb

## Content setup

RUN mkdir /usr/share/blog
WORKDIR /usr/share/blog

COPY . /usr/share/blog

# Generate code, documentation and the site itself
RUN mvn -f codegen/pom.xml package
RUN java -classpath codegen/target/static-html-codegen-1.0.0.jar:/usr/bin/swagger-codegen-cli-2.2.2.jar \
  io.swagger.codegen.Codegen \
  --input-spec static/swagger/swagger.json \
  --config config/strava-html.json \
  --lang strava-html \
  --output content/docs

# Final command configuration
ENV HUGO_PORT 1313
EXPOSE ${HUGO_PORT}
CMD hugo server \
  --port=${HUGO_PORT} \
  --baseURL=http://localhost:${HUGO_PORT} \
  --bind=0.0.0.0 \
  --watch=false \
  --destination=/usr/share/generated \
  --disableRSS \
  --disableSitemap
