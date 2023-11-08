# mongodb-docker

MongoDB Docker images for generic Linux AMD64 architecture

## Goal

Since version 5 MongoDB supports only processors with AVX instructions extensions.  
If you try to run on old processor, then you'll get error like below:
```
/opt/bitnami/scripts/libos.sh: line 346:    58 Illegal instruction     (core dumped) "$@" > /dev/null 2>&1
```
So, the goal of the project is to provide the ability to run an application on generic amd64 architecture.

## Image

You can use it in Docker as:
```
docker pull harbor.flakybit.net/mongodb/server:latest
```

## Building binaries

Binaries are available [here](https://dist.flakybit.net/mongodb/) and were built against Debian 12:
```
apt update
apt install -y build-essential
apt install -y libcurl4-openssl-dev libssl-dev liblzma-dev

apt install -y python3 python3-venv python-dev-is-python3

mkdir src
cd src
apt install -y git
git clone --depth 1 --branch <version> https://github.com/mongodb/mongo.git
cd  mongo

python3 -m venv .venv --prompt mongo
source .venv/bin/activate
python3 -m pip install -r etc/pip/compile-requirements.txt

# Apply patch here

python3 buildscripts/scons.py install-servers --config=force \
    -j16 \
    --opt=on \
    --release \
    --dbg=off \
    --linker=gold \
    --disable-warnings-as-errors \
    --variables-files=etc/scons/developer_versions.vars \
    --experimental-optimization=-sandybridge
    
```

## Links

1. [MongoDB Platform Support](https://www.mongodb.com/docs/manual/administration/production-notes/#platform-support)
2. [Mongo 5.0.0 crashes but 4.4.6 works](https://github.com/docker-library/mongo/issues/485)
3. [MongoDB v5.0 requires CPU AVX instructions](https://github.com/turnkeylinux/tracker/issues/1724)
4. [libos.sh: line 344 error when installing ReplicaSet](https://github.com/bitnami/charts/issues/12834)
5. [mongodb can't be installed by helm install](https://github.com/bitnami/charts/issues/10255)
6. [Building Mongodb without avx](https://github.com/GermanAizek/mongodb-without-avx/)
7. [Building MongoDB](https://github.com/mongodb/mongo/blob/master/docs/building.md)
8. [Bitnami MongoDB](https://github.com/bitnami/containers/tree/main/bitnami/mongodb/7.0/debian-11)
