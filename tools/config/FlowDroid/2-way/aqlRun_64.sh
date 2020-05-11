#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 3 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONSTS --cgalgo AUTO --dataflowsolver FLOWINSENSITIVE --analyzeframeworks --implicit ARRAYONLY --maxcallbackspercomponent 100 --maxcallbacksdepth 110 --nocallbacks --pathalgo CONTEXTSENSITIVE --onecomponentatatime --enablereflection --singlejoinpointabstraction --staticmode NONE --taintwrapper DEFAULT > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
