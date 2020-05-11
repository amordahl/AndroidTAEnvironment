#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aplength 3 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo AUTO --callbacksourcemode ALL --dataflowsolver CONTEXTFLOWSENSITIVE --implicit NONE --layoutmode NONE --maxcallbackspercomponent 9 --maxcallbacksdepth 9 --noexceptions  --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode FAST --singlejoinpointabstraction  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
