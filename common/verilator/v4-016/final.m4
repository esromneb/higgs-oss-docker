FROM BASE_IMAGE AS final

ARG DEBIAN_FRONTEND=noninteractive

USER root

COPY --from=riscv-toolchain /opt/riscv /opt/riscv
COPY --from=verilator-build /usr/local /usr/local

RUN apt-get update && apt-get install -y --no-install-recommends \
VERILATOR_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

ENV RISCV=/opt/riscv
ENV PATH=${RISCV}/bin:${PATH}
