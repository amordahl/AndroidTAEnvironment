#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aliasflowins --aplength 2 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo SPARK --dataflowsolver CONTEXTFLOWSENSITIVE --implicit NONE --layoutmode PWD --maxcallbackspercomponent 8 --maxcallbacksdepth 20 --noexceptions --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --pathspecificresults --singlejoinpointabstraction --staticmode CONTEXTFLOWSENSITIVE --taintwrapper EASY -t /home/asm140830/Documents/git/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-android/EasyTaintWrapperSource.txt > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
