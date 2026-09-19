# Vivado 2025.2 Docker image

Build from this directory:

```sh
make
```

The build context is the repository root so the Dockerfile can consume the
untracked AMD installer at
`common/vivado/FPGAs_AdaptiveSoCs_Unified_SDI_2025.2_1114_2157_Lin64.bin`.
The installer checksum in `common/vivado/md5.txt` is verified before the
unattended Vivado ML Standard installation runs.

Run Vivado in the completed image:

```sh
docker run --rm -it -v "$PWD:/work" localhost/vivado-2025.2:v1 vivado
```
