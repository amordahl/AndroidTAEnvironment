#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 50 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo VTA --dataflowsolver CONTEXTFLOWSENSITIVE --implicit NONE --layoutmode NONE --maxcallbackspercomponent 5 --maxcallbacksdepth 8 --nocallbacks --noexceptions --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode FAST --pathspecificresults --enablereflection --singlejoinpointabstraction --staticmode NONE --taintwrapper EASY -t /home/asm140830/Documents/git/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-android/EasyTaintWrapperSource.txt > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
