#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aplength 3 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo VTA --callbacksourcemode NONE --dataflowsolver FLOWINSENSITIVE --analyzeframeworks  --implicit ALL --layoutmode PWD --maxcallbackspercomponent 2 --maxcallbacksdepth 3 --noexceptions  --pathalgo SOURCESONLY --pathreconstructionmode NONE --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
