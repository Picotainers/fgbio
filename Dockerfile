# syntax=docker/dockerfile:1

FROM debian:bookworm AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    bash \
    openjdk-17-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt -o /usr/local/bin/sbt \
    && chmod +x /usr/local/bin/sbt

WORKDIR /opt
RUN git clone --depth 1 https://github.com/fulcrumgenomics/fgbio.git

WORKDIR /opt/fgbio
RUN sbt -no-colors -batch assembly \
    && JAR="$(find target/scala-2.13 -maxdepth 1 -type f -name 'fgbio-*.jar' ! -name '*-sources.jar' ! -name '*-javadoc.jar' | head -n 1)" \
    && test -n "$JAR" \
    && cp "$JAR" /tmp/fgbio.jar

FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/fgbio.jar /opt/fgbio/fgbio.jar
RUN printf '#!/bin/sh\nexec java -jar /opt/fgbio/fgbio.jar "$@"\n' > /usr/local/bin/fgbio \
    && chmod +x /usr/local/bin/fgbio
RUN printf '%s\n' '#!/bin/sh' \
    'if [ "${1:-}" = "fgbio" ]; then shift; fi' \
    'exec /usr/local/bin/fgbio "$@"' > /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /data
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
