#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 10 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo GEOM --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks --implicit ARRAYONLY --maxcallbackspercomponent 100 --maxcallbacksdepth 200 --noexceptions --pathalgo CONTEXTSENSITIVE --onesourceatatime --onecomponentatatime --enablereflection --singlejoinpointabstraction --staticmode NONE --taintwrapper EASY -t /home/issta2021/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-android/EasyTaintWrapperSource.txt > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
