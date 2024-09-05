# mongodb-docker

Docker image of MongoDB database.

## Goal

Since version 5, MongoDB supports only processors with AVX instructions extensions.  
If you try to run it on an old processor, then you'll get an error like below:
```
/opt/bitnami/scripts/libos.sh: line 346:    58 Illegal instruction     (core dumped) "$@" > /dev/null 2>&1
```
So, the goal of the project is to provide the ability to run an application on generic `amd64` architecture.

## Images

Our images are based on Bitnami's and published in [Quay](https://quay.io/repository/flakybitnet/mongodb-server),
[GHCR](https://github.com/flakybitnet/nextcloud-docker/pkgs/container/mongodb-server), [AWS](https://gallery.ecr.aws/flakybitnet/mongodb/server) and Harbor registries.

They also contain the [healthcheck utility written in Rust](https://github.com/syndikat7/mongodb-rust-ping).

## Usage

You can use it in Docker as simple as:
```
$ docker run -d quay.io/flakybitnet/mongodb-server
$ docker run -d ghcr.io/flakybitnet/mongodb-server
$ docker run -d public.ecr.aws/flakybitnet/mongodb/server
$ docker run -d harbor.flakybit.net/mongodb/server
```

## Binaries

Binaries are compiled by following [the instruction](./Build.md) and are available [there](https://dist.flakybit.net/mongodb/).

## Source

Source code are available at [Gitea](https://gitea.flakybit.net/flakybit/mongodb-docker) and mirrored to [GitHub](https://github.com/flakybitnet/mongodb-docker).

## Links

1. [MongoDB Platform Support](https://www.mongodb.com/docs/manual/administration/production-notes/#platform-support)
2. [Mongo 5.0.0 crashes but 4.4.6 works](https://github.com/docker-library/mongo/issues/485)
3. [MongoDB v5.0 requires CPU AVX instructions](https://github.com/turnkeylinux/tracker/issues/1724)
4. [libos.sh: line 344 error when installing ReplicaSet](https://github.com/bitnami/charts/issues/12834)
5. [mongodb can't be installed by helm install](https://github.com/bitnami/charts/issues/10255)
6. [Bitnami MongoDB](https://github.com/bitnami/containers/tree/main/bitnami/mongodb/7.0/debian-12)
7. [MongoDB Rust Ping](https://github.com/syndikat7/mongodb-rust-ping)
