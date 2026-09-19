FROM ubuntu:noble-20260911 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        file \
        libasound2t64 \
        libfontconfig1 \
        libfreetype6 \
        libice6 \
        libnss3 \
        libsm6 \
        libtinfo6 \
        libx11-6 \
        libxext6 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxtst6 \
        locales \
        make \
        sudo \
        tar \
        unzip \
        wget \
        x11-utils \
        xauth \
        zip && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

RUN printf '%s\n' \
        'export LC_ALL=en_US.UTF-8' \
        >> /root/.bashrc

FROM base AS build

WORKDIR /tmp/vivado-installer

COPY common/vivado/FPGAs_AdaptiveSoCs_Unified_SDI_2025.2_1114_2157_Lin64.bin ./
COPY common/vivado/md5.txt ./

RUN md5sum --check md5.txt && \
    chmod +x FPGAs_AdaptiveSoCs_Unified_SDI_2025.2_1114_2157_Lin64.bin && \
    ./FPGAs_AdaptiveSoCs_Unified_SDI_2025.2_1114_2157_Lin64.bin \
        --nox11 --noexec --keep --target extracted && \
    ./extracted/xsetup \
        --agree XilinxEULA,3rdPartyEULA \
        --batch Install \
        --product Vivado \
        --edition "Vivado ML Standard" \
        --location /opt/amd && \
    rm -rf /tmp/vivado-installer

FROM base AS final

COPY --from=build /opt/amd /opt/amd

ENV XILINX_VIVADO=/opt/amd/Vivado/2025.2
ENV PATH=${XILINX_VIVADO}/bin:${PATH}

WORKDIR /work
