#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 20 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo SPARK --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --maxcallbackspercomponent 150 --maxcallbacksdepth 120 --noexceptions --nothischainreduction --pathalgo SOURCESONLY --onesourceatatime --onecomponentatatime --singlejoinpointabstraction --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper DEFAULTFALLBACK > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
