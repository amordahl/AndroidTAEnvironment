#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 20 --callbackanalyzer FAST --codeelimination NONE --cgalgo VTA --dataflowsolver FLOWINSENSITIVE --implicit NONE --layoutmode ALL --maxcallbackspercomponent 1 --maxcallbacksdepth 9 --nocallbacks --noexceptions --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode FAST --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
