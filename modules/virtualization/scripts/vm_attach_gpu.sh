#!/bin/sh
echo "0000:01:00.0" > "/sys/bus/pci/devices/0000:01:00.0/driver/unbind"
echo "0000:01:00.0" > "/sys/bus/pci/drivers/vfio-pci/bind"

# echo "0000:01:00.1" > "/sys/bus/pci/devices/0000:01:00.1/driver/unbind"
# echo "0000:01:00.1" > "/sys/bus/pci/drivers/vfio-pci/bind"
