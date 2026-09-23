FROM ghcr.io/base-band/docker-images/verilator-4-016@sha256:7b7f4401300a08d42883feb77209b05f530e07b2833669291d0dc6d1823f30d1 AS riscv-toolchain

FROM ubuntu:18.04 AS verilator-build

ARG DEBIAN_FRONTEND=noninteractive
ARG VERILATOR_VERSION=v4.016

RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf \
        bison \
        build-essential \
        ca-certificates \
        flex \
        gcc \
        g++ \
        gperf \
        git \
        libfl-dev \
        make && \
    git clone https://github.com/verilator/verilator.git /tmp/verilator && \
    cd /tmp/verilator && \
    git checkout "${VERILATOR_VERSION}" && \
    git submodule update --init --depth 1 && \
    autoconf && \
    ./configure && \
    make -j2 && \
    make install && \
    rm -rf /tmp/verilator /var/lib/apt/lists/*

FROM localhost/vivado-2025.2:v1 AS final

ARG DEBIAN_FRONTEND=noninteractive

USER root

COPY --from=riscv-toolchain /opt/riscv /opt/riscv
COPY --from=verilator-build /usr/local /usr/local

RUN apt-get update && apt-get install -y --no-install-recommends \
        libfl2 \
        libzmq3-dev \
        nodejs \
        perl \
        python-is-python3 && \
    rm -rf /var/lib/apt/lists/*

ENV RISCV=/opt/riscv
ENV PATH=${RISCV}/bin:${PATH}

USER ubuntu

WORKDIR /home/ubuntu
