# MongoDB Community Server OCI

Container images of MongoDB Community Server.

## Goal

To bake [healthcheck utility written in Rust](https://github.com/syndikat7/mongodb-rust-ping) into the image.

## Images

Our images are based on Bitnami's and published in [Quay](https://quay.io/repository/flakybitnet/mongodb-community-server),
[GHCR](https://github.com/flakybitnet/mongodb-oci/pkgs/container/mongodb-community-server), [AWS](https://gallery.ecr.aws/flakybitnet/mongodb/community-server) and [GitLab](https://gitlab.flakybit.net/fb/mongo/oci/container_registry) registries.

They also contain the [healthcheck utility written in Rust](https://github.com/syndikat7/mongodb-rust-ping).

## Usage

You can use it in Docker as simple as:
```
$ docker run -d quay.io/flakybitnet/mongodb-community-server:<version>
$ docker run -d ghcr.io/flakybitnet/mongodb-community-server:<version>
$ docker run -d public.ecr.aws/flakybitnet/mongodb/community-server:<version>
$ docker run -d registry.flakybit.net/fb/mongo/oci/community-server:<version>
```

## Source

Source code are available at [GitLab](https://gitlab.flakybit.net/fb/mongo/oci) and mirrored to [GitHub](https://github.com/flakybitnet/mongodb-oci).
