#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aliasflowins --aplength 3 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo AUTO --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks --implicit ARRAYONLY --maxcallbackspercomponent 120 --maxcallbacksdepth 100 --nocallbacks --nothischainreduction --pathalgo SOURCESONLY --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper DEFAULTFALLBACK > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
