#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aplength 6 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo GEOM --callbacksourcemode NONE --dataflowsolver CONTEXTFLOWSENSITIVE --implicit NONE --layoutmode ALL --maxcallbackspercomponent 7 --maxcallbacksdepth 9 --nocallbacks  --pathalgo SOURCESONLY --pathreconstructionmode NONE --pathspecificresults  --singlejoinpointabstraction  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
