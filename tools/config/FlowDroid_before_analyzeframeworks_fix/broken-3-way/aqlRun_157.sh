#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 2 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo AUTO --callbacksourcemode SOURCELIST --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit ALL --layoutmode PWD --maxcallbackspercomponent 6 --maxcallbacksdepth 8 --nocallbacks  --noexceptions  --nothichainreduction  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode FAST --pathspecificresults  --singlejoinpointabstraction  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
