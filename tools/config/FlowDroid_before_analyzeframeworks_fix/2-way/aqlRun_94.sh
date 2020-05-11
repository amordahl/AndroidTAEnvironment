#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins --aplength 10 --callbackanalyzer FAST --codeelimination PROPAGATECONSTS --cgalgo GEOM --dataflowsolver FLOWINSENSITIVE --implicit ALL --maxcallbackspercomponent 100 --maxcallbacksdepth 200 --nocallbacks --noexceptions --pathalgo CONTEXTSENSITIVE --onesourceatatime --pathspecificresults --staticmode CONTEXTFLOWSENSITIVE --taintwrapper DEFAULTFALLBACK > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
