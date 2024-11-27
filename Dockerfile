FROM ubuntu:22.04 AS builder
# # Rebuild the source code only when needed
# FROM base AS builder

RUN apt-get update && apt-get install -y \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV RYE_HOME="/opt/rye"
ENV PATH="$RYE_HOME/shims:$PATH"

RUN curl -sSf https://rye.astral.sh/get | RYE_TOOLCHAIN_VERSION="3.12.3" RYE_INSTALL_OPTION="--yes" bash

COPY . /

RUN rye build --wheel --clean

FROM python:3.12-slim

COPY --from=builder /dist /dist

RUN apt-get update -y && \
    apt-get install -y build-essential && \
    pip install --no-cache-dir uv
RUN uv pip install --system --no-cache /dist/*.whl

COPY .env* .

EXPOSE 7860
CMD ["sodeda-era5", "dashboard". "--host", "0.0.0.0", "--port", "7860"]
