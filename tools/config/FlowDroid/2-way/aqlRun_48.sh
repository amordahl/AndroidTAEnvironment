#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins --aplength 3 --callbackanalyzer FAST --codeelimination NONE --cgalgo GEOM --dataflowsolver FLOWINSENSITIVE --implicit NONE --maxcallbackspercomponent 200 --maxcallbacksdepth 90 --nocallbacks --nothischainreduction --pathalgo CONTEXTSENSITIVE --onesourceatatime --enablereflection --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper DEFAULT > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
