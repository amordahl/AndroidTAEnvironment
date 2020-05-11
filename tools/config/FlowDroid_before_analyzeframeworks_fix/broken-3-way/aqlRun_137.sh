#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aplength 2 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONST --cgalgo SPARK --callbacksourcemode ALL --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit NONE --layoutmode ALL --maxcallbackspercomponent 4 --maxcallbacksdepth 8 --noexceptions  --pathalgo CONTEXTSENSITIVE --pathreconstructionmode NONE --enablereflection  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper MULTI > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
