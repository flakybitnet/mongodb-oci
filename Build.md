## Building binaries

Binaries are available [there](https://dist.flakybit.net/mongodb/) and were built against [Debian 12 (bookworm)](https://hub.docker.com/_/debian):
```
apt update
apt install -y build-essential
apt install -y libcurl4-openssl-dev libssl-dev liblzma-dev
apt install -y python3 python3-venv python-dev-is-python3
apt install -y git wget curl tar

git clone --depth 1000 --branch <version> https://github.com/mongodb/mongo.git
cd  mongo

git config --global user.email "me@local"
git config --global user.name "Me"

git revert --no-edit 6a7c140ee43487f6b596c4825ab3c29451ab9cad
git revert --no-edit b9e3f3c58a092a031405f4704df3b1f3bc368ae5
git revert --no-edit e54f728ad4bbf36533ace66077649afa4f58b6c2
git rm .bazelrc
git rm .gitignore
git rm BUILD.bazel
git rm bazel/wrapper_hook/BUILD.bazel
git rm bazel/wrapper_hook/compiledb.py
git rm bazel/wrapper_hook/wrapper_hook.py
git rm buildscripts/package_test.py
git rm etc/evergreen_yml_components/tasks/compile_tasks.yml
git rm etc/evergreen_yml_components/variants/amazon/test_release.yml
git rm etc/evergreen_yml_components/variants/macos/test_release.yml
git rm etc/evergreen_yml_components/variants/mongot/test_dev.yml
git rm evergreen/generate_evergreen_bazelrc.sh
git rm src/mongo/db/BUILD.bazel
git rm src/mongo/s/BUILD.bazel
git rm src/mongo/util/BUILD.bazel
git revert --continue --no-edit

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
    CXXFLAGS="-Wno-interference-size -Wno-overloaded-virtual -march=x86-64 -msse4.2"

cd build/install/bin/
tar -cvzf mongo.tar.gz mongod mongos
```

## Links

1. [Building MongoDB](https://github.com/mongodb/mongo/blob/master/docs/building.md)
2. [Building Mongodb without avx](https://github.com/GermanAizek/mongodb-without-avx/)
