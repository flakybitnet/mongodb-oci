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
    libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl3 libtasn1-6 libunistring2 numactl procps zlib1g ; \
    # Remove unused packages and clean cache
    apt-get clean && \
    rm -rf /tmp/bitnami/pkg/cache /var/lib/apt/lists /var/cache/apt/archives

# Install required system packages and dependencies
RUN chmod g+rwX /opt/bitnami ; \
    find / -perm /6000 -type f -exec chmod a-s {} \; || true ; \
    /opt/bitnami/mongodb/scripts/postunpack.sh

USER $UID:$GID
EXPOSE 27017
ENTRYPOINT [ "/opt/bitnami/mongodb/scripts/entrypoint.sh" ]
CMD [ "/opt/bitnami/mongodb/scripts/run.sh" ]
