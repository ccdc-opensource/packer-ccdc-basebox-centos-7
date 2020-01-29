#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pushd $DIR

echo 'pulling latest version of bento repository'
git submodule update --remote bento

echo 'creating output directory'
mkdir -p output

echo 'building base images'
pushd bento/packer_templates/centos/
packer build \
  -only=virtualbox-iso \
  -var 'build_directory=../../../output/' \
  -var 'disk_size=400000' \
  -var 'cpus=2' \
  -var 'memory=4096' \
  -var 'box_basename=ccdc-basebox/centos-7.7' \
  ./centos-7.7-x86_64.json

popd
echo popped
pwd
pushd output
echo pushed
pwd
mv ccdc-basebox/centos-7.7.virtualbox.box ccdc-basebox/centos-7.7.$(date +%Y%m%d).0.virtualbox.box
ls