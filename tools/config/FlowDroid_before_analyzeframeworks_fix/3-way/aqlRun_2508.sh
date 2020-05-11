#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aplength 30 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONSTS --cgalgo VTA --dataflowsolver CONTEXTFLOWSENSITIVE --implicit NONE --layoutmode NONE --maxcallbackspercomponent 3 --maxcallbacksdepth 4 --nocallbacks --noexceptions --nothischainreduction --pathalgo CONTEXTSENSITIVE --pathreconstructionmode NONE --pathspecificresults --singlejoinpointabstraction --staticmode NONE --taintwrapper EASY -t /home/asm140830/Documents/git/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-android/EasyTaintWrapperSource.txt > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
