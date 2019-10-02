FROM argoproj/argocd:v1.2.3

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
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/3.2.0/sops-3.2.0.linux \
    && chmod +x /usr/local/bin/sops 

# Helper script to run in pre
ADD scripts/* /usr/local/bin/

# Switch back to non-root user
USER argocd
