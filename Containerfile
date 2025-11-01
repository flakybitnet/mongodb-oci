ARG MONGO_VERSION
FROM quay.io/mongodb/mongodb-community-server:$MONGO_VERSION-ubi9

COPY --chmod=755 dist/mongodb-rust-ping /usr/bin/mongodb-rust-ping
