# Vivado, RISC-V GCC, and Verilator 4.016

Build the image:

```sh
make
```

The image starts from `localhost/vivado-2025.2:v1`, copies `/opt/riscv` from
the immutable
`ghcr.io/base-band/docker-images/verilator-4-016@sha256:7b7f4401300a08d42883feb77209b05f530e07b2833669291d0dc6d1823f30d1`
image. Verilator is built from the upstream `v4.016` tag in an Ubuntu 18.04
builder stage using the same `autoconf`, `configure`, and `make install` flow
as the published source image, then copied into the Vivado-based final image.

The RISC-V compiler is available through `PATH` with `RISCV=/opt/riscv`.
Verilator is installed under `/usr/local`.
