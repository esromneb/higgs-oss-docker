.DEFAULT_GOAL := all

.PHONY: all dockerfile clean

all: Dockerfile
	docker build --progress=plain --build-arg UBUNTU_UID=1000 -t localhost/riscv-verilator-4-222:v1 .

dockerfile: Dockerfile

Dockerfile: Dockerfile.m4 ../common/verilator/v4-222/riscv-toolchain.m4 ../common/verilator/v4-222/packages.m4 ../common/verilator/v4-222/verilator.m4 ../common/verilator/v4-222/final.m4
	m4 -I ../common Dockerfile.m4 > Dockerfile

clean:
	rm Dockerfile
