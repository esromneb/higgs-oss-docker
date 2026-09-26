include(`verilator/v4-016/riscv-toolchain.m4')dnl
include(`verilator/v4-016/packages.m4')dnl
include(`verilator/v4-016/verilator.m4')dnl
dnl # which image will the final stage start from?
define(`BASE_IMAGE', `localhost/vivado-2025.2:v1')dnl
include(`verilator/v4-016/final.m4')dnl

RUN printf '%s\n' 'export RISCV=/opt/riscv' >> /home/ubuntu/.bashrc

USER ubuntu

WORKDIR /home/ubuntu
