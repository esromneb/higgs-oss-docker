FROM BASE_IMAGE AS final

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

RUN printf '%s\n' 'export RISCV=/opt/riscv' >> /home/ubuntu/.bashrc

USER ubuntu

WORKDIR /home/ubuntu
