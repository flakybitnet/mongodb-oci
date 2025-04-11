## Building binaries

Binaries are available [there](https://dist.flakybit.net/mongodb/) and were built against [Debian 12 (bookworm)](https://hub.docker.com/_/debian):
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

apt install -y wget
wget https://gitea.flakybit.net/flakybit/mongodb-docker/raw/branch/main/0001-Compile-without-debug-symbols.patch
patch SConstruct 0001-Compile-without-debug-symbols.patch
wget https://gitea.flakybit.net/flakybit/mongodb-docker/raw/branch/main/0002-Removed_AVX-2_CCFLAG_from_mozjs.patch
patch src/third_party/mozjs/SConscript 0002-Removed_AVX-2_CCFLAG_from_mozjs.patch
wget https://gitea.flakybit.net/flakybit/mongodb-docker/raw/branch/main/0003-Disabled_AVX_in_mozjs_SIMD.patch
patch src/third_party/mozjs/extract/mozglue/misc/SIMD.cpp 0003-Disabled_AVX_in_mozjs_SIMD.patch

python3 -m venv .venv --prompt mongo
source .venv/bin/activate
python3 -m pip install 'poetry==2.0.0'
python3 -m poetry install --no-root --sync

python3 buildscripts/scons.py install-servers --config=force \
    -j12 \
    --opt=on \
    --release \
    --dbg=off \
    --linker=gold \
    --disable-warnings-as-errors \
    --variables-files=etc/scons/developer_versions.vars \
    --experimental-optimization=-sandybridge \
    CXXFLAGS="-Wno-interference-size -march=x86-64 -msse4.2"

apt install -y tar
cd build/install/bin/
tar -cvzf mongo.tar.gz mongod mongos
```

## Links

1. [Building MongoDB](https://github.com/mongodb/mongo/blob/master/docs/building.md)
2. [Building Mongodb without avx](https://github.com/GermanAizek/mongodb-without-avx/)
