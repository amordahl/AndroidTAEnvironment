#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 10 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo AUTO --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --maxcallbackspercomponent 110 --maxcallbacksdepth 0 --nocallbacks --pathalgo SOURCESONLY --onesourceatatime --onecomponentatatime --singlejoinpointabstraction --staticmode CONTEXTFLOWSENSITIVE --taintwrapper DEFAULTFALLBACK > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
