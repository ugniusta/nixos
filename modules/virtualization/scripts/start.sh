#!/bin/sh
VM_NAME=Windows11

sudo ./vm_attach_gpu.sh
sudo virsh start "$VM_NAME"
./looking-glass.sh
