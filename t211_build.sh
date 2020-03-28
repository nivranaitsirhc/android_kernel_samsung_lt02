#!/bin/bash

###### defines ######

local_dir=$PWD

###### defines ######
echo '#############'
echo 'making clean'
echo '#############'
make clean
rm -rf out
echo '#############'
echo 'making defconfig'
echo '#############'
make pxa986_lt023g_zcainine_defconfig
echo '#############'
echo 'making zImage'
echo '#############'
time make -ij32
echo '#############'
echo 'copying files to ./out'
echo '#############'
echo ''
mkdir out
mkdir out/modules
cp arch/arm/boot/zImage out/zImage
# Find and copy modules
find ./drivers -name '*.ko' | xargs -I {} cp {} ./out/modules/
find ./crypto -name '*.ko' | xargs -I {} cp {} ./out/modules/

#cp drivers/scsi/scsi_wait_scan.ko out/modules/scsi_wait_scan.ko
#cp drivers/usb/serial/baseband_usb_chr.ko out/modules/baseband_usb_chr.ko
#cp crypto/tcrypt.ko out/modules/tcrypt.ko
#cp drivers/net/usb/raw_ip_net.ko out/modules/raw_ip_net.ko





echo 'Build anykernel zip'

ANYKERNEL_T211=$HOME/Android_DEV/anykernel_T211_staging
if [ ! -d "$ANYKERNEL_T211" ]; then
	mkdir -p $ANYKERNEL_T211
	mkdir -p $ANYKERNEL_T211/modules/system/lib/modules
else
	echo 'Failed to create directory $ANYKERNEL_T211'
	exit 2
fi

cp -r out/zImage $ANYKERNEL_T211/kernel/
cp -r out/modules/* $ANYKERNEL_T211/system/lib/modules/

cd $ANYKERNEL_T211; zip -r9 lt023g_Cainine-AnyKernel3.zip * -x .git README.md *placeholder
echo 'done'
echo ''

# if [ -a arch/arm/boot/zImage ]; then
# echo '#############'
# echo 'Making Anykernel zip'
# echo '#############'
# echo ''
# cd ~/tab3/anykernel_packing_t211
# . pack_cwm.sh
# if [[ $1 = -d ]]; then
# cp ~/tab3/out/"$zipname" ~/Dropbox/Android/SGT3/stock_kk/"$zipname"
# echo "Copying $zipname to Dropbox"
# fi
# cd $local_dir
# echo ''
# echo '#############'
# echo 'build finished successfully'
# echo '#############'
# else
# echo '#############'
# echo 'build failed!'
# echo '#############'
# fi
