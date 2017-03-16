#!/bin/bash

# notes:
  # A list of names is required 
  # will add getops to pass a list flag 
  # right now it just takes one arg

LIST=$1
VG_NAME=$(vgs --noheadings -o vg_name)

function create_vms {
  yes | lvcreate -L+15G -n $NAME $VG_NAME
  virt-install \
    --name $NAME \
    --ram 512 \
    --vcpus 2 \
    --disk path=/dev/$VG_NAME/$NAME \
    --network bridge=br0 \
    --os-type linux \
    --os-variant rhel6 \
    --location /images/CentOS-7-x86_64-DVD-1611.iso \
    --initrd-inject=/images/ks.cfg \
    --extra-args='ks=file:/ks.cfg console=tty0 console=ttyS0,115200n8 serial'
}


for NAME in $(cat $LIST)
do
  create_vms
done
