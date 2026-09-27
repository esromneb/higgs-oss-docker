# syntax=docker/dockerfile:1
include(`verilator/v4-016/riscv-toolchain.m4')dnl
include(`verilator/v4-016/packages.m4')dnl
include(`verilator/v4-016/verilator.m4')dnl
define(`BASE_IMAGE', `ubuntu:noble-20260911')dnl
include(`verilator/v4-016/final.m4')dnl

ARG UBUNTU_UID=1001
ARG SBT_VERSION=0.13.16

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        openjdk-17-jdk \
        sudo && \
    curl --fail --location --retry 3 \
        "https://repo.scala-sbt.org/scalasbt/debian/sbt-${SBT_VERSION}.deb" \
        --output /tmp/sbt.deb && \
    dpkg --install /tmp/sbt.deb && \
    rm -f /tmp/sbt.deb && \
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
