#!/bin/sh
VM_NAME=Windows11

sudo virsh shutdown "$VM_NAME"
while true; do
    STATE=$(sudo virsh domstate "$VM_NAME")
    
    if [[ "$STATE" == "shut off" ]]; then
        echo "$VM_NAME has been shut down."
        break
    fi
    
    sleep 2
done
sudo ./host_attach_gpu.sh
