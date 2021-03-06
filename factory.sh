#!/bin/bash
# Bits and pieces borrowed from cvpcs and xoomdev build scripts
# Required build variables,  adjust according to your own.
# Path to toolchain
  cco=~/kernel/linaro/bin/arm-eabi-
# Path to build your kernel
  k=~/kernel/grouper
# Directory for the any kernel updater
  t=$k/tools/bbk
# Path to Kernel Factory Out folder
  kout=~/kernel/out/Grouper

# Date to add to zip
  today=$(date +"%m_%d_%Y")

# Clean old builds
   echo "Clean"
     rm -rf $k/out
     rm -rf $k/arch/arm/boot/zImage
     make clean

# Setup the build
 cd $k/arch/arm/configs/BBKconfigs
    for c in *
      do
        cd $k
# Setup output directory
       mkdir -p "out/$c"
          cp -R "$t/system" out/$c
          cp -R "$t/META-INF" out/$c
          cp -R "$t/kernel" out/$c
       mkdir -p "out/$c/system/lib/modules/"

  m=$k/out/$c/system/lib/modules
  z=$c-$today

# Compile Kernels
   echo ""
   echo "Compiling $c"
   echo ""

   export ARCH=arm CROSS_COMPILE=$cco
   cp $k/arch/arm/configs/BBKconfigs/$c "$k/.config"
   make -j8 zImage

# Grab modules & zImage
   echo ""
   echo "<<>><<>>  Collecting modules and zimage <<>><<>>"
   echo ""
   cp $k/arch/arm/boot/zImage out/$c/kernel/zImage
   for mo in $(find . -name "*.ko"); do
		cp "${mo}" $m
   done

# Build Zip
 clear
   echo "Creating $z.zip"
     cd $k/out/$c/
       7z a "$z.zip"
         mv $z.zip $k/out/$z.zip
           rm -rf $k/out/$c
           cp $k/out/$z.zip $kout/$z.zip
# Line below for debugging purposes,  uncomment to stop script after each config is run
#read this
      done
