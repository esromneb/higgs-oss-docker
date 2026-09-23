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

COPY --from=higgs_sdr_rev2 --chown=user:user . /home/user/work/higgs_sdr_rev2

RUN sed -i \
        -e 's|addr/4|addr//4|g' \
        -e 's|consume/2|consume//2|g' \
        /home/user/work/higgs_sdr_rev2/libs/riscv-baseband/scripts/hex2mif.py && \
    sed -i \
        -e 's|V_MEM_START/4|V_MEM_START//4|g' \
        -e 's|V_MEM_LEN)/4|V_MEM_LEN)//4|g' \
        -e 's|address / 4|address // 4|g' \
        -e 's|index / 8|index // 8|g' \
        /home/user/work/higgs_sdr_rev2/libs/riscv-baseband/scripts/hex2mif_vmem.py && \
    sed -i '/#include <vector>/a#include <cstdint>' \
        /home/user/work/higgs_sdr_rev2/libs/s-modem/soapy/src/common/FileUtils.hpp

USER user

WORKDIR /home/user/work
