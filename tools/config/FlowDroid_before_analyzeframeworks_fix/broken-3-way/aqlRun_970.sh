#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins  --aplength 10 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo AUTO --callbacksourcemode ALL --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit NONE --layoutmode ALL --maxcallbackspercomponent 8 --maxcallbacksdepth 1 --noexceptions  --nothichainreduction  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode NONE --enablereflection  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
