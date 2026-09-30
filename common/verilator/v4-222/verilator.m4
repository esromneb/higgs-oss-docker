FROM ubuntu:18.04 AS verilator-build

ARG DEBIAN_FRONTEND=noninteractive
ARG VERILATOR_VERSION=v4.222

RUN apt-get update && apt-get install -y --no-install-recommends \
VERILATOR_BUILD_PACKAGES && \
    git clone https://github.com/verilator/verilator.git /tmp/verilator && \
    cd /tmp/verilator && \
    git checkout "${VERILATOR_VERSION}" && \
    git submodule update --init --depth 1 && \
    autoconf && \
    ./configure && \
    make -j2 && \
    make install && \
    rm -rf /tmp/verilator /var/lib/apt/lists/*
