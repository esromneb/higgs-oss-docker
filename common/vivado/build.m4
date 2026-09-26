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

