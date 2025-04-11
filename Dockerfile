FROM docker.io/bitnami/minideb:bookworm

ARG MONGO_VERSION
ARG MONGO_BINARIES_VERSION
ARG MONGO_SHELL_VERSION
ARG MONGO_TOOLS_VERSION
ARG MONGO_RUST_PING_VERSION
ARG YQ_VERSION
ARG WAIT_PORT_VERSION
ARG RENDER_TEMPLATE_VERSION

ENV APP_NAME="mongodb" \
    APP_VERSION=$MONGO_VERSION \
    HOME="/opt/bitnami/mongodb" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    UID=1001 \
    GID=1001 \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mongodb/bin:$PATH"

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
    install_packages ca-certificates libbrotli1 libcom-err2 libcurl4 libffi8 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 \
    libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 liblzma5 \
    libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl3 libtasn1-6 libunistring2 numactl procps zlib1g

# Install required system packages and dependencies
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; \
    cd /tmp/bitnami/pkg/cache/ ; \
    install_packages curl ; \
    # Install Bitnami components
    BITNAMI_COMPONENTS=( \
      "mongodb-shell-${MONGO_SHELL_VERSION}-linux-${OS_ARCH}-${OS_FLAVOUR}" \
      "yq-${YQ_VERSION}-linux-${OS_ARCH}-${OS_FLAVOUR}" \
      "wait-for-port-${WAIT_PORT_VERSION}-linux-${OS_ARCH}-${OS_FLAVOUR}" \
      "render-template-${RENDER_TEMPLATE_VERSION}-linux-${OS_ARCH}-${OS_FLAVOUR}" \
    ) ; \
    for COMPONENT in "${BITNAMI_COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        echo "Downloading $COMPONENT" ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
    done ; \
    # Install custom MongoDB \
    COMPONENT="mongodb-${MONGO_BINARIES_VERSION}-linux-${OS_ARCH}-${OS_FLAVOUR}" ; \
    echo "Downloading $COMPONENT" ; \
    curl -SsLf "https://dist.flakybit.net/mongodb/${COMPONENT}.tar.gz" -O ; \
    curl -SsLf "https://dist.flakybit.net/mongodb/${COMPONENT}.tar.gz.sha256" -O ; \
    sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
    tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami/mongodb/bin --no-same-owner ; \
    # Install MongoDB tools
    COMPONENT="mongodb-database-tools-debian12-x86_64-${MONGO_TOOLS_VERSION}" ; \
    echo "Downloading $COMPONENT" ; \
    curl -SsLf "https://fastdl.mongodb.org/tools/db/${COMPONENT}.tgz" -O ; \
    tar -zxf "$COMPONENT.tgz" -C /opt/bitnami/mongodb/bin --no-same-owner --strip-components=2 ${COMPONENT}/bin ; \
    # Install rust-ping
    COMPONENT='mongodb-rust-ping-x86_64-unknown-linux-gnu' ; \
    echo "Downloading $COMPONENT" ; \
    curl -SsLf "https://github.com/syndikat7/mongodb-rust-ping/releases/download/v${MONGO_RUST_PING_VERSION}/${COMPONENT}.tar.gz" -O ; \
    tar -zxf "$COMPONENT.tar.gz" -C /usr/bin --no-same-owner ; \
    # Remove unused packages and clean cache
    apt-get autoremove --purge -y curl && \
    apt-get clean && \
    rm -rf /tmp/bitnami/pkg/cache /var/lib/apt/lists /var/cache/apt/archives ; \
    # Fix permissions
    chmod g+rwX /opt/bitnami ; \
    find / -perm /6000 -type f -exec chmod a-s {} \; || true ; \
    /opt/bitnami/mongodb/scripts/postunpack.sh

USER $UID:$GID
EXPOSE 27017
ENTRYPOINT [ "/opt/bitnami/mongodb/scripts/entrypoint.sh" ]
CMD [ "/opt/bitnami/mongodb/scripts/run.sh" ]
