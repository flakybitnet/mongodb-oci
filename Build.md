## Building binaries

Binaries are available [there](https://gitlab.flakybit.net/fb/mongodb-oci/-/packages/) and were built against [Debian 12 (bookworm)](https://hub.docker.com/_/debian):
```
apt update
apt install -y build-essential
apt install -y libcurl4-openssl-dev libssl-dev liblzma-dev
apt install -y python3 python3-venv python-dev-is-python3
apt install -y git wget curl tar

git clone --depth 1 --branch r7.0.x https://github.com/mongodb/mongo.git
cd  mongo

wget https://gitlab.flakybit.net/fb/mongodb-oci/-/raw/7.0/0001-Compile-without-debug-symbols.patch
patch SConstruct 0001-Compile-without-debug-symbols.patch
wget https://gitlab.flakybit.net/fb/mongodb-oci/-/raw/7.0/0002-Removed_AVX-2_CCFLAG_from_mozjs.patch
patch src/third_party/mozjs/SConscript 0002-Removed_AVX-2_CCFLAG_from_mozjs.patch
wget https://gitlab.flakybit.net/fb/mongodb-oci/-/raw/7.0/0003-Disabled_AVX_in_mozjs_SIMD.patch
patch src/third_party/mozjs/extract/mozglue/misc/SIMD.cpp 0003-Disabled_AVX_in_mozjs_SIMD.patch

python3 -m venv .venv --prompt mongo
source .venv/bin/activate
python3 -m pip install -r etc/pip/compile-requirements.txt

python3 buildscripts/scons.py install-servers --config=force \
    -j12 \
    --opt=on \
    --release \
    --dbg=off \
    --linker=gold \
    --disable-warnings-as-errors \
    --variables-files=etc/scons/developer_versions.vars \
    --experimental-optimization=-sandybridge \
    CXXFLAGS="-Wno-interference-size -Wno-overloaded-virtual"

cd build/install/bin/
tar -cvzf mongo.tar.gz mongod mongos
```

## Links

1. [Building MongoDB](https://github.com/mongodb/mongo/blob/v7.0/docs/building.md)
2. [Building Mongodb without avx](https://github.com/GermanAizek/mongodb-without-avx/)
