# syntax=docker/dockerfile:1

FROM eclipse-temurin:21-jre-jammy

ARG FGBIO_VERSION=4.0.0
ARG FGBIO_JAR_URL=https://github.com/fulcrumgenomics/fgbio/releases/download/${FGBIO_VERSION}/fgbio-${FGBIO_VERSION}.jar

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "$FGBIO_JAR_URL" -o /usr/local/bin/fgbio.jar

RUN printf '%s\n' '#!/usr/bin/env bash' 'set -euo pipefail' 'exec java -jar /usr/local/bin/fgbio.jar "$@"' > /usr/local/bin/fgbio \
    && chmod +x /usr/local/bin/fgbio

WORKDIR /data
ENTRYPOINT ["/usr/local/bin/fgbio"]
