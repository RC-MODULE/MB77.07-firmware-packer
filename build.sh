#!/bin/bash

set -e

[ "$DISTRO" == "" ] && DISTRO="debian_jessie"

[ -d firmware-package ] && rm -Rfv firmware-package/
mkdir firmware-package

for file in `ls|grep -v build.sh| grep -v "fw-*" | grep -v firmware-package | grep -v output`; do
    cp $file firmware-package/
done

cd firmware-package

#Fetch all the components
echo "Fetching the latest MB77.07 kernel and dtb"
wget http://www.module.ru/mb7707/ci/mboot/latest/mboot-signed.bin   -O mboot-signed.bin
wget http://www.module.ru/mb7707/ci/mboot/latest/mboot-uemd.bin     -O mboot-uemd.bin

if [ "$VARIANT" == "matlab" ]; then
wget http://www.module.ru/mb7707/ci/kernel-matlab/latest/uImage                   -O uImage
wget http://www.module.ru/mb7707/ci/kernel-matlab/latest/rcm-k1879xb1-mb7707.dtb  -O 7707.dtb
else
wget http://www.module.ru/mb7707/ci/kernel/latest/uImage            -O uImage
wget http://www.module.ru/mb7707/ci/kernel/latest/module-mb7707.dtb -O 7707.dtb
fi

wget http://www.module.ru/mb7707/ci/rootfs/${DISTRO}/latest/rootfs.ubifs -O filesystem.ubifs

cd ..

DATE=`date +%d%m%Y`
mv firmware-package fw-${DISTRO}-${VARIANT}-${DATE}
tar cvpzf fw-${DISTRO}-${VARIANT}-${DATE}.tgz fw-${DISTRO}-${VARIANT}-${DATE}
