#!/bin/bash

# Parameter:
# 1: .apk file
# 2: App name without .apk

# Export paths
export DROIDSAFE_SRC_HOME=/home/asm140830/AndroidTA/AndroidTAEnvironment/tools/DroidSafe/droidsafe-src

# Create folder structure
mkdir /home/asm140830/AndroidTA/AndroidTAEnvironment/tools/DroidSafe/runs/${2}
cd /home/asm140830/AndroidTA/AndroidTAEnvironment/tools/DroidSafe/runs/${2}
cp ${1} .

# Create Makefile
printf "NAME := ${2}\nAPK  := ${2}.apk\n\n" > Makefile
printf 'ifndef DROIDSAFE_SRC_HOME\n\t$(error DROIDSAFE_SRC_HOME is undefined)\nendif\n\ninclude $(DROIDSAFE_SRC_HOME)/android-apps/Makefile.common' >> Makefile
printf 'DSARGS ?= --apicalldepth 5 --filetransforms --ignorenocontextflows --implicitflow --imprecisestrings --kobjsens 20 --limitcontextforgui --limitcontextforstrings --multipassfb --nojsa --nova --precision 2 --preciseinfoflow --pta spark --transfertaintfield --typesforcontext'
# Run DroidSafe analysis
make specdump-apk
