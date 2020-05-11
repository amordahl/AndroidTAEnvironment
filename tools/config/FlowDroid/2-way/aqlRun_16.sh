#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aplength 2 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo GEOM --dataflowsolver FLOWINSENSITIVE --analyzeframeworks --implicit NONE --maxcallbackspercomponent 120 --maxcallbacksdepth 1 --noexceptions --pathalgo CONTEXTSENSITIVE --onesourceatatime --onecomponentatatime --pathspecificresults --enablereflection --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper DEFAULTFALLBACK > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
