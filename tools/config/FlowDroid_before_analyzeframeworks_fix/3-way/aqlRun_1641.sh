#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 8 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo SPARK --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode ALL --maxcallbackspercomponent 5 --maxcallbacksdepth 7 --nocallbacks --noexceptions --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --pathspecificresults --enablereflection --singlejoinpointabstraction --staticmode NONE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
