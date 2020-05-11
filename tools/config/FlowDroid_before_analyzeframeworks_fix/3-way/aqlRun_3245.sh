#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 100 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONSTS --cgalgo GEOM --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --layoutmode PWD --maxcallbackspercomponent 7 --maxcallbacksdepth 6 --nocallbacks --noexceptions --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode FAST --pathspecificresults --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper EASY -t /home/asm140830/Documents/git/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-android/EasyTaintWrapperSource.txt > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
