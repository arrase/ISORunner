#!/bin/bash

ETC=/etc/isorunner
ISO_DIR=$HOME/isorunner

# BOOT CONFIG
grep "dtoverlay=dwc2" /boot/config.txt || (echo "dtoverlay=dwc2" | sudo tee --append /boot/config.txt)
grep "dwc2" /etc/modules || (echo "dwc2" | sudo tee --append /etc/modules)
grep "libcomposite" /etc/modules || (echo "libcomposite" | sudo tee --append /etc/modules)

[ -d $ETC ] || sudo mkdir $ETC
[ -d $ISO_DIR ] || mkdir $ISO_DIR

echo "ISO_DIR=$ISO_DIR" | sudo tee $ETC/isorunner.conf
echo "MOUNT_POINT=/media/isorunner" | sudo tee --append $ETC/isorunner.conf

grep "/usr/bin/isorunner" /etc/rc.local || (awk '/exit\ 0/ && c == 0 {c = 0; print "\n/usr/bin/isorunner\n"}; {print}' /etc/rc.local | sudo tee /etc/rc.local)

sudo cp bin/isorunner.sh /usr/bin/isorunner
sudo chmod 777 isorunner