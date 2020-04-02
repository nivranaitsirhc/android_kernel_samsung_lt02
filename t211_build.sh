#!/bin/bash
# define GCC
export CROSS_COMPILE="/mnt/d/.Active_Work/arm-eabi-4.6/bin/arm-eabi-"
export ARCH="arm"

echo '#############'
echo 'making clean'
echo '#############'
make clean
echo '#############'
echo 'making defconfig'
echo '#############'
make pxa986_lt023g_cainine_opti_defconfig
echo '#############'
echo 'making zImage'
echo '#############'
time make -j8 V=0

# build zip
. ./t211_zip.sh