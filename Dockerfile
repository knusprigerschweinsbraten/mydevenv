FROM ubuntu:bionic

ARG KUBECTX_VERSION=0.9.4
ARG KUBENS_VERSION=0.9.4
ARG CLOUDFLARE_VERSION=1.6.1

# Install a few basic packages
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl git bash-completion \
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl \
    && rm -rf /var/lib/apt/lists/*

# Install helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install kubectx
RUN curl -fsSLO https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz \
    && tar -C /tmp/ -zxvf kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz \
    && rm kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz \
    && mv /tmp/kubectx /usr/local/bin/kubectx \
    && chmod +x /usr/local/bin/kubectx

# Install kubens
RUN curl -fsSLO https://github.com/ahmetb/kubectx/releases/download/v${KUBENS_VERSION}/kubens_v${KUBENS_VERSION}_linux_x86_64.tar.gz \
    && tar -C /tmp/ -zxvf kubens_v${KUBENS_VERSION}_linux_x86_64.tar.gz \
    && rm kubens_v${KUBENS_VERSION}_linux_x86_64.tar.gz \
    && mv /tmp/kubens /usr/local/bin/kubens \
    && chmod +x /usr/local/bin/kubens

# Enable bash autocompletion
RUN echo source /usr/share/bash-completion/bash_completion >> ~/.bashrc

# Enable kubectl autocompletion
RUN echo 'source <(kubectl completion bash)' >>~/.bashrc

# Enable kubectx autocompletion
RUN curl -fsSLo /usr/share/bash-completion/kubectx_completion https://raw.githubusercontent.com/ahmetb/kubectx/v${KUBECTX_VERSION}/completion/kubectx.bash \
    && echo source /usr/share/bash-completion/kubectx_completion >> ~/.bashrc

# Enable kubens autocompletion
RUN curl -fsSLo /usr/share/bash-completion/kubens_completion https://raw.githubusercontent.com/ahmetb/kubectx/v${KUBENS_VERSION}/completion/kubens.bash \
    && echo source /usr/share/bash-completion/kubens_completion >> ~/.bashrc

# Add a bunch of useful Helm repositories
RUN helm repo add hashicorp https://helm.releases.hashicorp.com

# Install cloudflare ssl toolset
RUN curl -fsSLo /usr/local/bin/cfssl https://github.com/cloudflare/cfssl/releases/download/v${CLOUDFLARE_VERSION}/cfssl_${CLOUDFLARE_VERSION}_linux_amd64 \
    && chmod +x /usr/local/bin/cfssl \
    && curl -fsSLo /usr/local/bin/cfssljson https://github.com/cloudflare/cfssl/releases/download/v${CLOUDFLARE_VERSION}/cfssljson_${CLOUDFLARE_VERSION}_linux_amd64 \
    && chmod +x /usr/local/bin/cfssljson

# Install nslookup
RUN apt-get update && apt-get instally -y dnsutils \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["bash"]