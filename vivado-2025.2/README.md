# Vivado 2025.2 Docker image

Build from this directory:

```sh
make
```

Before building, replace the two placeholder values in `amd-credentials.exp`.
This two-line credentials file is ignored by Git and is mounted only for the
authentication build step; it is not copied into an image layer.

The build context is the repository root so the Dockerfile can consume the
untracked AMD installer at
`common/vivado/FPGAs_AdaptiveSoCs_Unified_SDI_2025.2_1114_2157_Lin64.bin`.
The installer checksum in `common/vivado/md5.txt` is verified before the
unattended Vivado ML Standard installation runs. The image installs the Kintex
and Virtex UltraScale and UltraScale+ device families configured in
`install-config.txt`.

Run Vivado in the completed image:

```sh
docker run --rm -it -v "$PWD:/work" localhost/vivado-2025.2:v1 vivado
```
