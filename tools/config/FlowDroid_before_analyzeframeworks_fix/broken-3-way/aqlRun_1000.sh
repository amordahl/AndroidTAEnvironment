#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aplength 1 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONST --cgalgo AUTO --callbacksourcemode SOURCELIST --dataflowsolver FLOWINSENSITIVE --implicit NONE --layoutmode NONE --maxcallbackspercomponent 4 --maxcallbacksdepth 10 --nocallbacks  --noexceptions  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode FAST --pathspecificresults  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
