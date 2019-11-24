FROM argoproj/argocd:v1.3.0

# Switch to root for the ability to perform install
USER root

# Install tools needed for your repo-server to retrieve & decrypt secrets, render manifests 
# (e.g. curl, awscli, gpg, sops)
RUN apt-get update \
    && apt-get install -y \
        curl \
        gpg \
        python3-yaml \
    && apt-get clean \
    && curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/3.2.0/sops-3.2.0.linux \
    && chmod +x /usr/local/bin/sops \
    && curl -o /tmp/helm3.tar.gz -L https://get.helm.sh/helm-v3.0.0-linux-amd64.tar.gz \
    && tar zxvf /tmp/helm3.tar.gz -C /tmp \
    && mv /tmp/linux-amd64/helm /usr/local/bin/helm3 \
    && chmod +x /usr/local/bin/helm3 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 


# Helper script to run in pre
ADD scripts/* /usr/local/bin/

# Switch back to non-root user
USER argocd
