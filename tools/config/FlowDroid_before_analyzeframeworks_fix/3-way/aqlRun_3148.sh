#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins --aplength 50 --callbackanalyzer FAST --codeelimination NONE --cgalgo VTA --dataflowsolver FLOWINSENSITIVE --implicit NONE --layoutmode PWD --maxcallbackspercomponent 100 --maxcallbacksdepth 50 --nocallbacks --noexceptions --nothischainreduction --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
