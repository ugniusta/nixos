#!/bin/sh

sudo virsh nodedev-reattach pci_0000_01_00_1
sudo virsh nodedev-reattach pci_0000_01_00_0
echo attached

# sudo modprobe -r vfio-pci --first-time

sudo modprobe nvidia_drm --first-time
sudo modprobe nvidia_modest --first-time
sudo modprobe nvidia_uvm --first-time
sudo modprobe nvidia --first-time

# echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind
