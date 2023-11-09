FROM docker.io/bitnami/minideb:bookworm

ARG VERSION
LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
  org.opencontainers.image.title="mongodb" \
  org.opencontainers.image.version="${VERSION}"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    UID=1001 \
    GID=1001

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbrotli1 libcom-err2 libcurl4 libffi8 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 \
    libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 liblzma5 \
    libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl3 libtasn1-6 libunistring2 numactl procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "mongodb-shell-2.0.2-0-linux-${OS_ARCH}-${OS_FLAVOUR}" \
      "yq-4.35.2-3-linux-${OS_ARCH}-${OS_FLAVOUR}" \
      "wait-for-port-1.0.7-2-linux-${OS_ARCH}-${OS_FLAVOUR}" \
      "render-template-1.0.6-2-linux-${OS_ARCH}-${OS_FLAVOUR}" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done && \
    curl -SsLf "https://dist.flakybit.net/mongodb/mongodb-${VERSION}-0-linux-${OS_ARCH}-${OS_FLAVOUR}.tar.gz" -O && \
    curl -SsLf "https://dist.flakybit.net/mongodb/mongodb-${VERSION}-0-linux-${OS_ARCH}-${OS_FLAVOUR}.tar.gz.sha256" -O && \
    sha256sum -c "mongodb-${VERSION}-0-linux-${OS_ARCH}-${OS_FLAVOUR}.tar.gz.sha256" && \
    tar -zxf "mongodb-${VERSION}-0-linux-${OS_ARCH}-${OS_FLAVOUR}.tar.gz" -C /opt/bitnami/mongodb/bin --no-same-owner && \
    rm -rf "mongodb-${VERSION}-0-linux-${OS_ARCH}-${OS_FLAVOUR}".tar.gz{,.sha256}
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN groupadd --gid $GID mongo && \
    useradd --uid $UID --gid $GID --no-create-home --home-dir /opt/bitnami/mongodb mongo
RUN /opt/bitnami/scripts/mongodb/postunpack.sh
ENV APP_VERSION="${VERSION}" \
    BITNAMI_APP_NAME="mongodb" \
    PATH="/opt/bitnami/mongodb/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 27017

USER $UID:$GID
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb/run.sh" ]
