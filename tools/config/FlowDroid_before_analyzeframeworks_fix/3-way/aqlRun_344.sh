#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins --aplength 2 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo VTA --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 8 --maxcallbacksdepth 100 --nocallbacks --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
