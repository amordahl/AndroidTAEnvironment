#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 20 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo RTA --dataflowsolver FLOWINSENSITIVE --analyzeframeworks --implicit ARRAYONLY --maxcallbackspercomponent 50 --maxcallbacksdepth 110 --nocallbacks --nothischainreduction --pathalgo CONTEXTSENSITIVE --pathspecificresults --enablereflection --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper DEFAULTFALLBACK > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
