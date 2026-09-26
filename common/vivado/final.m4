FROM base AS final

RUN apt-get update && apt-get install -y --no-install-recommends VIVADO_FINAL_PACKAGES && \
    rm -rf /var/lib/apt/lists/* /etc/ssh/ssh_host_*_key* && \
    usermod --append --groups dialout ubuntu && \
    install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu/.ssh && \
    install -m 0600 -o ubuntu -g ubuntu /dev/null /home/ubuntu/.ssh/authorized_keys && \
    printf '%s\n' \
        'ubuntu ALL=(ALL) NOPASSWD:ALL' \
        > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu && \
    visudo -cf /etc/sudoers.d/ubuntu && \
    printf '%s\n' \
        'PasswordAuthentication no' \
        'PermitRootLogin no' \
        'PubkeyAuthentication yes' \
        > /etc/ssh/sshd_config.d/ubuntu.conf

COPY --from=build /opt/amd /opt/amd
COPY --chmod=0555 vivado-2025.2/start-sshd.sh /usr/local/bin/start-sshd

ENV XILINX_VIVADO=/opt/amd/2025.2/Vivado
ENV PATH=${XILINX_VIVADO}/bin:${PATH}
ENV HOME=/home/ubuntu

USER ubuntu
WORKDIR /home/ubuntu

EXPOSE 22

CMD ["bash"]
