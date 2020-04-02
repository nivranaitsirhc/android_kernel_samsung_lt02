#!/bin/bash
echo ''
echo 'Building anykernel zip'

# define
ZIMAGE=$(pwd)/arch/arm/boot/zImage
ERR="Error :"
# stage build directory
if [ ! -d out ];then mkdir out;fi
if [ ! -d out ];then mkdir out/modules;fi

# copy zImage
if [ ! -e $ZIMAGE ]; then echo "$ERR zImage not found in $ZIMAGE";exit 2; else cp arch/arm/boot/zImage out/zImage;fi

# copy modules
find ./drivers -name '*.ko' | xargs -I {} cp {} ./out/modules/
find ./crypto -name '*.ko' | xargs -I {} cp {} ./out/modules/

# define
ANYKERNEL_T211=$HOME/Android_DEV/anykernel_T211_staging
ANYKERNEL_T211_KERNEL=$ANYKERNEL_T211/kernel
ANYKERNEL_T211_MODULES=$ANYKERNEL_T211/system/lib/modules
ANYKERNEL_ZIPNAME=lt023g_Cainine-AnyKernel3.zip

# check staging directory
[ ! -d "$ANYKERNEL_T211" ] &&\
(mkdir -p $ANYKERNEL_T211_KERNEL || echo "$ERR Failed to create directory $ANYKERNEL_T211_KERNEL" && exit 2)
[ ! -d "$ANYKERNEL_T211_MODULES" ] &&\
(mkdir -p $ANYKERNEL_T211_MODULES || echo "$ERR Failed to create directory '$ANYKERNEL_T211_MODULES" && exit 2)

# clean anykernel staging directory
rm -f $ANYKERNEL_T211_KERNEL/zImage
rm -f $ANYKERNEL_T211_MODULES/*
rm -f $ANYKERNEL_ZIPNAME

# copy binaries to anykernel staging directory
cp -r out/zImage $ANYKERNEL_T211_KERNEL/zImage
cp -r out/modules/* $ANYKERNEL_T211_MODULES

# build
cd $ANYKERNEL_T211; zip -r9 $ANYKERNEL_ZIPNAME * -x .git README.md *placeholder .cmd

if [ ! -e $ANYKERNEL_ZIPNAME ];then echo "$ERR Failed to compress $ANYKERNEL_ZIPNAME";exit 2;fi
echo 'Done..'