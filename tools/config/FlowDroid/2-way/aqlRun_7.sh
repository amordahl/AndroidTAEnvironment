#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 1 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo VTA --dataflowsolver FLOWINSENSITIVE --analyzeframeworks --implicit ARRAYONLY --maxcallbackspercomponent 150 --maxcallbacksdepth 0 --noexceptions --pathalgo CONTEXTSENSITIVE --onesourceatatime --onecomponentatatime --enablereflection --singlejoinpointabstraction --staticmode NONE --taintwrapper EASY -t /home/issta2021/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-android/EasyTaintWrapperSource.txt > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
