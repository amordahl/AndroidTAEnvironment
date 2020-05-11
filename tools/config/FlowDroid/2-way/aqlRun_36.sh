#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 7 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo VTA --dataflowsolver FLOWINSENSITIVE --analyzeframeworks --implicit ALL --maxcallbackspercomponent 120 --maxcallbacksdepth 80 --noexceptions --nothischainreduction --pathalgo CONTEXTINSENSITIVE --onesourceatatime --pathspecificresults --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
