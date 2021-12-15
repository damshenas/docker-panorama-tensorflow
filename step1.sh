#!/bin/bash
#
# Reference: https://docs.bazel.build/versions/master/install-ubuntu.html#install-with-installer-ubuntu


pip3 uninstall -y tensorboard tensorflow
rm /usr/local/lib/libproto*
rm /usr/local/bin/protoc
pip3 uninstall -y protobuf
rm /usr/local/bin/bazel

set -e

folder=${HOME}/src
mkdir -p $folder

echo "** Install requirements"
apt-get install -y pkg-config zip g++ zlib1g-dev unzip wget curl build-essential
apt-get install -y openjdk-8-jdk

echo "** Download bazel-3.1.0 sources"
pushd $folder
if [ ! -f bazel-3.1.0-dist.zip ]; then
  wget https://github.com/bazelbuild/bazel/releases/download/3.1.0/bazel-3.1.0-dist.zip
fi

echo "** Build and install bazel-3.1.0"
unzip bazel-3.1.0-dist.zip -d bazel-3.1.0-dist
cd bazel-3.1.0-dist
EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" ./compile.sh

cp output/bazel /bin
bazel version

popd

echo "** Build bazel-3.1.0 successfully"


