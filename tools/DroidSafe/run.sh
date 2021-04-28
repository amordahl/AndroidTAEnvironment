#!/bin/bash

# Parameter:
# 1: .apk file
# 2: App name without .apk

# The following environmental variables must be set.
# DROIDSAFE_SRC_HOME, which must point to the droidsafe-src directory.
# ANDROID_SDK_HOME, which must point to the platforms directory.

# Create folder structure
mkdir $DROIDSAFE_SRC_HOME/runs/${2}
cd $DROIDSAFE_SRC_HOME/runs/${2}
cp ${1} .

# Create Makefile
printf "NAME := ${2}\nAPK  := ${2}.apk\n\n" > Makefile
printf 'ifndef DROIDSAFE_SRC_HOME\n\t$(error DROIDSAFE_SRC_HOME is undefined)\nendif\n\ninclude $(DROIDSAFE_SRC_HOME)/android-apps/Makefile.common' >> Makefile

# Run DroidSafe analysis
make specdump-apk
