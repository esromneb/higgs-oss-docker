FROM ubuntu:noble-20260911 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
VIVADO_PACKAGES && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

RUN printf '%s\n' \
        'export LC_ALL=en_US.UTF-8' \
        >> /root/.bashrc

