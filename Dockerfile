FROM python:3.10-slim AS base

RUN apt update -y && \
    apt install -y jq && \
    pip install --no-cache-dir cfn-policy-validator

COPY templates /templates
COPY policies /policies
COPY scripts/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
