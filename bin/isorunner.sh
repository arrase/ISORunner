#!/bin/bash

. /etc/isorunner/isorunner.conf

[ -f $ISO_DIR/run.iso ] || exit

C=1

cd /sys/kernel/config/usb_gadget/
mkdir -p g1
cd g1

echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2

mkdir -p strings/0x409
echo "fedcba0123456789" > strings/0x409/serialnumber
echo "Parasite Team" > strings/0x409/manufacturer
echo "ISORunner" > strings/0x409/product

mkdir -p configs/c.$C/strings/0x409
echo "Config $C: ECM network" > configs/c.$C/strings/0x409/configuration
echo 250 > configs/c.$C/MaxPower

# STORAGE
mkdir -p functions/mass_storage.usb0
echo 1 > functions/mass_storage.usb0/stall
echo 0 > functions/mass_storage.usb0/lun.0/removable
echo 1 > functions/mass_storage.usb0/lun.0/cdrom
echo 1 > functions/mass_storage.usb0/lun.0/ro
echo 0 > functions/mass_storage.usb0/lun.0/nofua

echo $ISO_DIR/run.iso > functions/mass_storage.usb0/lun.0/file

ln -s functions/mass_storage.usb0 configs/c.$C/
# End STORAGE

ls /sys/class/udc > UDC


