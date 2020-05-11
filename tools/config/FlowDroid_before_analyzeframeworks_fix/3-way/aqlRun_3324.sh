#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aplength 100 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo GEOM --dataflowsolver FLOWINSENSITIVE --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 30 --maxcallbacksdepth 10 --nocallbacks --nothischainreduction --pathalgo SOURCESONLY --pathreconstructionmode FAST --pathspecificresults --enablereflection --staticmode NONE --taintwrapper EASY -t /home/asm140830/Documents/git/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-android/EasyTaintWrapperSource.txt > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
