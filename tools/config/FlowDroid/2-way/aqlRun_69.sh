#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aplength 20 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo AUTO --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --maxcallbackspercomponent 600 --maxcallbacksdepth 110 --nocallbacks --noexceptions --pathalgo CONTEXTINSENSITIVE --onesourceatatime --onecomponentatatime --enablereflection --staticmode CONTEXTFLOWSENSITIVE --taintwrapper EASY -t /home/asm140830/Documents/git/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-android/EasyTaintWrapperSource.txt > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
