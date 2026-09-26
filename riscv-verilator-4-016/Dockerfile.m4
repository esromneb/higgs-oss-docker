# syntax=docker/dockerfile:1
include(`verilator/v4-016/riscv-toolchain.m4')dnl
include(`verilator/v4-016/packages.m4')dnl
include(`verilator/v4-016/verilator.m4')dnl
define(`BASE_IMAGE', `ubuntu:noble-20260911')dnl
include(`verilator/v4-016/final.m4')dnl

RUN apt-get update && apt-get install -y --no-install-recommends sudo && \
    rm -rf /var/lib/apt/lists/* && \
    usermod --append --groups dialout ubuntu && \
    printf '%s\n' 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu && \
    visudo -cf /etc/sudoers.d/ubuntu

RUN printf '%s\n' 'export RISCV=/opt/riscv' >> /home/ubuntu/.bashrc

USER ubuntu
WORKDIR /home/ubuntu
