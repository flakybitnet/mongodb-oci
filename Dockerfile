FROM docker.io/bitnami/minideb:bookworm

ENV APP_NAME="mongodb" \
    APP_VERSION="7.0.12" \
    HOME="/opt/bitnami/mongodb" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    UID=1001 \
    GID=1001

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
  org.opencontainers.image.title="${APP_NAME}" \
  org.opencontainers.image.version="${APP_VERSION}" \
  org.opencontainers.image.licenses="Apache-2.0"

COPY rootfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
RUN groupadd --gid $GID mongo && \
    useradd --uid $UID --gid $GID --no-create-home --home-dir $HOME mongo

# Update and install required system packages and dependencies
RUN apt-get update && apt-get upgrade -y && \
    install_packages ca-certificates curl libbrotli1 libcom-err2 libcurl4 libffi8 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 \
    libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 liblzma5 \
    libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl3 libtasn1-6 libunistring2 numactl procps zlib1g

# Install required system packages and dependencies
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; \
    cd /tmp/bitnami/pkg/cache/ ; \
    # Install Bitnami components
    BITNAMI_COMPONENTS=( \
      "mongodb-shell-2.2.5-0-linux-${OS_ARCH}-${OS_FLAVOUR}" \
      "yq-4.43.1-1-linux-${OS_ARCH}-${OS_FLAVOUR}" \
      "wait-for-port-1.0.7-11-linux-${OS_ARCH}-${OS_FLAVOUR}" \
      "render-template-1.0.6-11-linux-${OS_ARCH}-${OS_FLAVOUR}" \
    ) ; \
    for COMPONENT in "${BITNAMI_COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done ; \
    # Install custom MongoDB and tools
    COMPONENTS=( \
      "mongodb-${APP_VERSION}-0-linux-${OS_ARCH}-${OS_FLAVOUR}" \
      "mongo-tools-100.9.4-linux-${OS_ARCH}" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://dist.flakybit.net/mongodb/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://dist.flakybit.net/mongodb/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami/mongodb/bin --no-same-owner ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done ; \
    # Install rust-ping
    curl -SsLf "https://github.com/syndikat7/mongodb-rust-ping/releases/download/v0.2.1/mongodb-rust-ping-linux-x64.tar.gz" -O ; \
    tar -zxf "mongodb-rust-ping-linux-x64.tar.gz" -C /usr/bin --no-same-owner ; \
    rm -rf "mongodb-rust-ping-linux-x64.tar.gz"

# Remove unused packages and clean APT cache
RUN apt-get autoremove --purge -y curl && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives /tmp/bitnami/pkg/cache

# Fix permissions
RUN chmod g+rwX /opt/bitnami ; \
    find / -perm /6000 -type f -exec chmod a-s {} \; || true ; \
    /opt/bitnami/mongodb/scripts/postunpack.sh

USER $UID:$GID
EXPOSE 27017
ENTRYPOINT [ "/opt/bitnami/mongodb/scripts/entrypoint.sh" ]
CMD [ "/opt/bitnami/mongodb/scripts/run.sh" ]
