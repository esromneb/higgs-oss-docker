.DEFAULT_GOAL := all

.PHONY: all dockerfile clean

all: Dockerfile
	test -f amd-credentials.exp
	docker build --progress=plain --secret id=amd_credentials,src=amd-credentials.exp -f Dockerfile -t localhost/vivado-2025.2:v1 ..

dockerfile: Dockerfile

Dockerfile: Dockerfile.m4 ../common/vivado/packages.m4 ../common/vivado/base.m4 ../common/vivado/build.m4 ../common/vivado/final.m4
	m4 -I ../common Dockerfile.m4 > Dockerfile

clean:
	rm Dockerfile
