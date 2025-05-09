FROM docker:24-dind

ENV SELFHOSTYOURTECH_ROOT "/opt/selfhostyourtech"

# Install Docker Compose (v2 CLI plugin is included in docker:24+)
RUN apk add --no-cache bash git curl yq

ENV PATH="${SELFHOSTYOURTECH_ROOT}/bin:${PATH}"

WORKDIR "/opt/selfhostyourtech"
