# syntax=docker/dockerfile:1
include(`verilator/v4-016/riscv-toolchain.m4')dnl
include(`verilator/v4-016/packages.m4')dnl
include(`verilator/v4-016/verilator.m4')dnl
define(`BASE_IMAGE', `ubuntu:noble-20260911')dnl
include(`verilator/v4-016/final.m4')dnl

ARG UBUNTU_UID=1001
ARG SBT_VERSION=0.13.16
ARG TEMURIN_8_VERSION=8u472-b08
ARG TEMURIN_8_ARCHIVE_VERSION=8u472b08
ARG TEMURIN_8_SHA256=5becaa4ac660e844c5a39e2ebc39ff5ac824c37ff1b625af8c8b111dc13c3592

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        openjdk-17-jdk \
        sudo \
        tar && \
    curl --fail --location --retry 3 \
            "https://github.com/adoptium/temurin8-binaries/releases/download/jdk${TEMURIN_8_VERSION}/OpenJDK8U-jdk_x64_linux_hotspot_${TEMURIN_8_ARCHIVE_VERSION}.tar.gz" \
        --output /tmp/temurin-8.tar.gz && \
    echo "${TEMURIN_8_SHA256}  /tmp/temurin-8.tar.gz" | sha256sum --check && \
    install -d /opt/temurin-8 && \
    tar --extract --gzip --file /tmp/temurin-8.tar.gz \
        --strip-components=1 --directory /opt/temurin-8 && \
    rm -f /tmp/temurin-8.tar.gz && \
    curl --fail --location --retry 3 \
        "https://repo.scala-sbt.org/scalasbt/debian/sbt-${SBT_VERSION}.deb" \
        --output /tmp/sbt.deb && \
    dpkg --install /tmp/sbt.deb && \
    rm -f /tmp/sbt.deb && \
    printf '%s\n' \
        '#!/bin/sh' \
        'export JAVA_HOME=/opt/temurin-8' \
        'export PATH="$JAVA_HOME/bin:$PATH"' \
        'exec /usr/bin/sbt "$@"' \
        > /usr/local/bin/sbt && \
    chmod 0555 /usr/local/bin/sbt && \
    rm -rf /var/lib/apt/lists/* && \
    usermod --uid "${UBUNTU_UID}" ubuntu && \
    usermod --append --groups dialout ubuntu && \
    chown -R ubuntu:ubuntu /home/ubuntu && \
    printf '%s\n' 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu && \
    visudo -cf /etc/sudoers.d/ubuntu

RUN printf '%s\n' 'export RISCV=/opt/riscv' >> /home/ubuntu/.bashrc && \
    chown ubuntu:ubuntu /home/ubuntu/.bashrc

USER ubuntu
WORKDIR /home/ubuntu
