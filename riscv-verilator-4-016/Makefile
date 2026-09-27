.DEFAULT_GOAL := all

.PHONY: all dockerfile clean

all: Dockerfile
	docker build --progress=plain --build-arg UBUNTU_UID=1000 -t localhost/riscv-verilator-4-016:v1 .

dockerfile: Dockerfile

Dockerfile: Dockerfile.m4 ../common/verilator/v4-016/riscv-toolchain.m4 ../common/verilator/v4-016/packages.m4 ../common/verilator/v4-016/verilator.m4 ../common/verilator/v4-016/final.m4
	m4 -I ../common Dockerfile.m4 > Dockerfile

clean:
	rm Dockerfile
