#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 6 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo VTA --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 6 --maxcallbacksdepth 4 --nocallbacks --noexceptions --pathalgo CONTEXTSENSITIVE --pathreconstructionmode FAST --enablereflection --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
