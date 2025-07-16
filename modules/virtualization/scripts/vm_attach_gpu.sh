#!/bin/sh
# echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/unbind

sudo modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia --first-time

sudo virsh nodedev-detach pci_0000_01_00_0
sudo virsh nodedev-detach pci_0000_01_00_1

sudo modprobe vfio-pci --first-time
