# syntax=docker/dockerfile:1
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

ARG ANSIBLE_VERSION="2.19.5"
ARG TERRAFORM_VERSION="1.4.0"
ARG VAULT_VERSION="1.13.0"

ENV TZ=UTC

RUN apt-get update \
 && apt-get install -y --no-install-recommends bash ca-certificates sudo \
    iproute2 iputils-ping  \
    tree \
    python3-pip \
    software-properties-common \
    bash \
    ca-certificates \
    sudo \
    wget \
    unzip \
    curl \
    git \
    net-tools \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get update && apt-get install -y --no-install-recommends python3-venv python3-pip curl \
    && python3 -m venv /opt/ansible \
    && /opt/ansible/bin/pip install --no-cache-dir "ansible-core==${ANSIBLE_VERSION}" \
    && ln -s /opt/ansible/bin/ansible /usr/local/bin/ansible \
    && ln -s /opt/ansible/bin/ansible-playbook /usr/local/bin/ansible-playbook \
    && set -eux; \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform.zip; \
    unzip /tmp/terraform.zip -d /usr/local/bin/; \
    rm /tmp/terraform.zip; \
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -O /tmp/vault.zip; \
    unzip /tmp/vault.zip -d /usr/local/bin/; \
    rm /tmp/vault.zip

# App directory separate from home
WORKDIR /dev-box 

# Copy launcher and supporting folders into /dev-box
COPY src/dev-tricks-launcher.sh /dev-box/dev-tricks-launcher.sh
COPY src/docker-init.sh /usr/local/bin/docker-init.sh
RUN chmod +x /dev-box/dev-tricks-launcher.sh
RUN mkdir -p /home/ubuntu /home/ubuntu/dev /scripts /home/ubuntu/dev/repos \
 && touch /home/ubuntu/.bashrc \
 && chmod +x /usr/local/bin/docker-init.sh \ 
 && echo '#!/usr/bin/env bash\ncd /dev-box && exec /dev-box/dev-tricks-launcher.sh "$@"' \
    > /usr/local/bin/launcher \
 && chmod +x /usr/local/bin/launcher \ 
 && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the non-root user
USER ubuntu
ENV HOME=/home/ubuntu
WORKDIR /home/ubuntu/repos

# SHELL ["/bin/bash", "-c"]
# RUN cd /dev-box && ./dev-tricks-launcher.sh <<< "1"

ENTRYPOINT ["/usr/local/bin/docker-init.sh"]
