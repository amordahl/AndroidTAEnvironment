#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 20 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo SPARK --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks --implicit NONE --maxcallbackspercomponent 150 --maxcallbacksdepth 120 --nocallbacks --pathalgo SOURCESONLY --onesourceatatime --pathspecificresults --staticmode CONTEXTFLOWSENSITIVE --taintwrapper DEFAULT > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
