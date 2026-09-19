.PHONY: all

all:
	test -f amd-credentials.exp
	docker build --progress=plain --secret id=amd_credentials,src=amd-credentials.exp -f Dockerfile -t localhost/vivado-2025.2:v1 ..
