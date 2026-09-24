# syntax=docker/dockerfile:1
FROM ubuntu:noble-20260911 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        expect \
        file \
        libasound2t64 \
        libfontconfig1 \
        libfreetype6 \
        libice6 \
        libnss3 \
        libpixman-1-0 \
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
        iproute2 \
        nano \
        curl \
        wget \
        git \
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
COPY --chmod=0555 vivado-2025.2/amd-auth-token.exp /usr/local/bin/amd-auth-token.exp
COPY vivado-2025.2/install-config.txt ./

RUN md5sum --check md5.txt && \
    chmod +x FPGAs_AdaptiveSoCs_Unified_SDI_2025.2_1114_2157_Lin64.bin && \
    ./FPGAs_AdaptiveSoCs_Unified_SDI_2025.2_1114_2157_Lin64.bin \
        --nox11 --noexec --keep --target extracted

RUN --mount=type=secret,id=amd_credentials,target=/tmp/amd-credentials.exp,mode=0400 \
    amd-auth-token.exp ./extracted/xsetup /tmp/amd-credentials.exp

RUN ./extracted/xsetup \
        --agree XilinxEULA,3rdPartyEULA \
        --batch Install \
        --config install-config.txt \
        > /tmp/vivado-install.log 2>&1 || \
        { sed -E 's/Authenticated user .+ successfully/Authenticated user successfully/' \
            /tmp/vivado-install.log; exit 1; } && \
    rm -rf /tmp/vivado-installer

FROM base AS final

RUN apt-get update && apt-get install -y --no-install-recommends openssh-server && \
    rm -rf /var/lib/apt/lists/* /etc/ssh/ssh_host_*_key* && \
    usermod --append --groups dialout ubuntu && \
    install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu/.ssh && \
    install -m 0600 -o ubuntu -g ubuntu /dev/null /home/ubuntu/.ssh/authorized_keys && \
    printf '%s\n' \
        'ubuntu ALL=(ALL) NOPASSWD:ALL' \
        > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu && \
    visudo -cf /etc/sudoers.d/ubuntu && \
    printf '%s\n' \
        'PasswordAuthentication no' \
        'PermitRootLogin no' \
        'PubkeyAuthentication yes' \
        > /etc/ssh/sshd_config.d/ubuntu.conf

COPY --from=build /opt/amd /opt/amd
COPY --chmod=0555 vivado-2025.2/start-sshd.sh /usr/local/bin/start-sshd

ENV XILINX_VIVADO=/opt/amd/2025.2/Vivado
ENV PATH=${XILINX_VIVADO}/bin:${PATH}
ENV HOME=/home/ubuntu

USER ubuntu
WORKDIR /home/ubuntu

EXPOSE 22

CMD ["bash"]
