# syntax=docker/dockerfile:1
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
FROM ubuntu:noble-20260911 AS final

ARG DEBIAN_FRONTEND=noninteractive

USER root

COPY --from=riscv-toolchain /opt/riscv /opt/riscv
COPY --from=verilator-build /usr/local /usr/local

RUN apt-get update && apt-get install -y --no-install-recommends \
        bsdextrautils \
        build-essential \
        ca-certificates \
        cmake \
        g++ \
        gdb \
        git \
        libfl2 \
        libmpc3 \
        libzmq3-dev \
        make \
        nodejs \
        perl \
        python-is-python3 \
        ripgrep \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

ENV RISCV=/opt/riscv
ENV PATH=${RISCV}/bin:${PATH}

RUN apt-get update && apt-get install -y --no-install-recommends sudo && \
    rm -rf /var/lib/apt/lists/* && \
    usermod --append --groups dialout ubuntu && \
    printf '%s\n' 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu && \
    visudo -cf /etc/sudoers.d/ubuntu

RUN printf '%s\n' 'export RISCV=/opt/riscv' >> /home/ubuntu/.bashrc

USER ubuntu
WORKDIR /home/ubuntu
