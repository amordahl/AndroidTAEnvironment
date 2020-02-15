#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins --aplength 20 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo GEOM --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --maxcallbackspercomponent 80 --maxcallbacksdepth 50 --nocallbacks --nothischainreduction --pathalgo CONTEXTINSENSITIVE --onesourceatatime --onecomponentatatime --pathspecificresults --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
