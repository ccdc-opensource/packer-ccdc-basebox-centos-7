#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pushd $DIR
if [[ ! -e ./vsphere-environment-do-not-add ]]
then
  echo "Please add a vsphere-environment-do-not-add file to set up the environment variables required to deploy"
  echo "These vary based on the target VMWare server. The list can be found at the bottom of the packer template."
  return 1
fi
source ./vsphere-environment-do-not-add
echo 'creating output directory'
mkdir -p output

rm -rf ./output//packer-centos-7.7-x86_64-vmware

echo 'building base images'
packer build \
  -only=vmware-iso \
  -except=vagrant,vsphere-template \
  -var 'build_directory=./output/' \
  -var 'disk_size=400000' \
  -var 'cpus=2' \
  -var 'memory=4096' \
  -var 'vmx_remove_ethernet_interfaces=false' \
  -var 'box_basename=ccdc-basebox/centos-7.7' \
  ./centos-7.7-x86_64.json

