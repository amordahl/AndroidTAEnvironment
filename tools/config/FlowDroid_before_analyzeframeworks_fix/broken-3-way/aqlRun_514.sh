#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins  --aplength 6 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo GEOM --callbacksourcemode NONE --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --layoutmode ALL --maxcallbackspercomponent 2 --maxcallbacksdepth 5 --nocallbacks  --noexceptions  --nothichainreduction  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode PRECISE --pathspecificresults  --singlejoinpointabstraction  --staticmode NONE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
