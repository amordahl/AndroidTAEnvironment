#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 5 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo AUTO --dataflowsolver CONTEXTFLOWSENSITIVE --implicit NONE --layoutmode ALL --maxcallbackspercomponent 6 --maxcallbacksdepth 5 --nocallbacks --noexceptions --pathalgo CONTEXTSENSITIVE --pathreconstructionmode NONE --pathspecificresults --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}