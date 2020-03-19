#!/bin/bash

# Parameter:
# 1: .apk file
# 2: App name without .apk

# Export paths
export DROIDSAFE_SRC_HOME=/home/asm140830/Documents/git/AndroidTAEnvironment/tools/DroidSafe/droidsafe-src
export ANDROID_SDK_HOME=/home/asm140830/Documents/Android/platforms

# Create folder structure
mkdir /home/asm140830/Documents/git/AndroidTAEnvironment/tools/DroidSafe/runs/${2}_${3}
cd /home/asm140830/Documents/git/AndroidTAEnvironment/tools/DroidSafe/runs/${2}_${3}
cp ${1} .

# Create Makefile
printf "NAME := ${2}\nAPK  := ${2}.apk\n\n" > Makefile
printf 'ifndef DROIDSAFE_SRC_HOME\n\t$(error DROIDSAFE_SRC_HOME is undefined)\nendif\n\ninclude $(DROIDSAFE_SRC_HOME)/android-apps/Makefile.common\n' >> Makefile
printf 'DSARGS ?= --apicalldepth 0 --filetransforms --ignoreexceptionflows --ignorenocontextflows --implicitflow --kobjsens 18 --multipassfb --noarrayindex --noclinitcontext --noclonestatics --preciseinfoflow --pta paddle --transfertaintfield --typesforcontext\n' >> Makefile
# Run DroidSafe analysis
make specdump-apk
