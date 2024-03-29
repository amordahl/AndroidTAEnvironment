#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins  --aplength 2 --callbackanalyzer FAST --codeelimination NONE --cgalgo SPARK --callbacksourcemode ALL --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit ALL --layoutmode PWD --maxcallbackspercomponent 1 --maxcallbacksdepth 7 --nocallbacks  --noexceptions  --nothichainreduction  --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode FAST --pathspecificresults  --staticmode NONE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
