#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 7 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo CHA --dataflowsolver FLOWINSENSITIVE --implicit NONE --layoutmode NONE --maxcallbackspercomponent 8 --maxcallbacksdepth 10 --nocallbacks --noexceptions --pathalgo SOURCESONLY --pathreconstructionmode NONE --pathspecificresults --enablereflection --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}