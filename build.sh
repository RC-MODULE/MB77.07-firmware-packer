#!/bin/bash

[ "$DISTRO" == "" ] && DISTRO="debian_jessie"
[ "$FLAVOR" == "" ] && FLAVOR="mb7707_minimal"

[ -d firmware-package ] && rm -Rfv firmware-package/ 
mkdir firmware-package

for file in `ls|grep -v "*.sh"|grep -v firmware-package | grep -v output`; do
    cp $file firmware-package/
done

cd firmware-package

#Fetch all the components
echo "Fetching the latest MB77.07 kernel and dtb"
wget http://www.module.ru/mb7707/ci/mboot/latest/mboot-signed.bin   -O mboot-signed.bin
wget http://www.module.ru/mb7707/ci/mboot/latest/mboot-uemd.bin     -O mboot-uemd.bin
wget http://www.module.ru/mb7707/ci/kernel/latest/uImage            -O uImage
wget http://www.module.ru/mb7707/ci/kernel/latest/module-mb7707.dtb -O 7707.dtb
wget http://www.module.ru/mb7707/ci/rootfs/${DISTRO}/${FLAVOR}/latest/rootfs-${DISTRO}-jessie.ubifs -O filesystem.ubifs

cd ..

DATE=`date +%d%m%Y`
mv firmware-package fw-${DISTRO}-${FLAVOR}-${DATE}
tar cvpzf fw-${DISTRO}-${FLAVOR}-${DATE}.tgz fw-${DISTRO}-${FLAVOR}-${DATE}
