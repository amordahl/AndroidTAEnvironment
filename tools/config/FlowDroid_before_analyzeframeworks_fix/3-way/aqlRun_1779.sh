#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 8 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo VTA --dataflowsolver FLOWINSENSITIVE --implicit ALL --layoutmode NONE --maxcallbackspercomponent 50 --maxcallbacksdepth 10 --nothischainreduction --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --pathspecificresults --staticmode NONE --taintwrapper EASY -t /home/asm140830/Documents/git/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-android/EasyTaintWrapperSource.txt > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
