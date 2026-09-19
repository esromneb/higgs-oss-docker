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

The default account is the non-root `user`, with passwordless `sudo` and a
home directory at `/home/user`. SSH is configured for public-key
authentication, with password and root login disabled. Add a public key before
exposing the container:

```sh
docker cp ~/.ssh/id_ed25519.pub CONTAINER:/tmp/id_ed25519.pub
docker exec CONTAINER sudo sh -c \
  'cat /tmp/id_ed25519.pub >> /home/user/.ssh/authorized_keys &&
   chown user:user /home/user/.ssh/authorized_keys &&
   chmod 600 /home/user/.ssh/authorized_keys'
```

Start SSH explicitly as root when needed:

```sh
docker exec --user root CONTAINER start-sshd
```

For a dedicated SSH container, run
`docker run --user root -p 2222:22 ... start-sshd`, then connect using
`ssh -p 2222 user@localhost`.
