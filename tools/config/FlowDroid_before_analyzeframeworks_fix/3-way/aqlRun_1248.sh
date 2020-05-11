#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 6 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo SPARK --dataflowsolver CONTEXTFLOWSENSITIVE --implicit NONE --layoutmode NONE --maxcallbackspercomponent 9 --maxcallbacksdepth 4 --nocallbacks --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode NONE --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
