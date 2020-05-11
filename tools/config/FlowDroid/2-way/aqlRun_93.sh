#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 7 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo SPARK --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks --implicit ALL --maxcallbackspercomponent 90 --maxcallbacksdepth 200 --nocallbacks --nothischainreduction --pathalgo CONTEXTINSENSITIVE --onesourceatatime --pathspecificresults --enablereflection --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper DEFAULT > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
