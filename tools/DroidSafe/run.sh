#!/bin/bash

# Parameter:
# 1: .apk file
# 2: App name without .apk

# Export paths
export DROIDSAFE_SRC_HOME=/home/reprodroid/reprodroid/tools/DroidSafe/droidsafe-src
export ANDROID_SDK_HOME=/home/reprodroid/reprodroid/Android/platforms

# Create folder structure
mkdir /home/reprodroid/reprodroid/tools/DroidSafe/runs/${2}
cd /home/reprodroid/reprodroid/tools/DroidSafe/runs/${2}
cp ${1} .

# Create Makefile
printf "NAME := ${2}\nAPK  := ${2}.apk\n\n" > Makefile
printf 'ifndef DROIDSAFE_SRC_HOME\n\t$(error DROIDSAFE_SRC_HOME is undefined)\nendif\n\ninclude $(DROIDSAFE_SRC_HOME)/android-apps/Makefile.common' >> Makefile

# Run DroidSafe analysis
make specdump-apk
