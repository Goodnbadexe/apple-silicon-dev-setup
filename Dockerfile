FROM alpine:3.20

LABEL org.opencontainers.image.title="apple-silicon-dev-setup" \
      org.opencontainers.image.description="Idempotent Apple Silicon (arm64) macOS developer setup, templates, and audit scripts" \
      org.opencontainers.image.url="https://www.goodnbad.info" \
      org.opencontainers.image.source="https://github.com/Goodnbadexe/apple-silicon-dev-setup" \
      org.opencontainers.image.licenses="MIT"

RUN apk add --no-cache bash zsh

WORKDIR /opt/apple-silicon-dev-setup
COPY Brewfile LICENSE README.md bootstrap.sh ./
COPY scripts/ ./scripts/
COPY templates/ ./templates/

ENTRYPOINT ["/bin/bash"]
