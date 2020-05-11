#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 1 --callbackanalyzer FAST --codeelimination REMOVECODE --cgalgo CHA --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --maxcallbackspercomponent 120 --maxcallbacksdepth 150 --pathalgo CONTEXTINSENSITIVE --onecomponentatatime --enablereflection --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper DEFAULT > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
