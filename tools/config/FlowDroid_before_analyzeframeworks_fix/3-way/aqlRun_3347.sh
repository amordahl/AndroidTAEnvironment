#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 100 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo VTA --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --layoutmode ALL --maxcallbackspercomponent 50 --maxcallbacksdepth 3 --nocallbacks --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
