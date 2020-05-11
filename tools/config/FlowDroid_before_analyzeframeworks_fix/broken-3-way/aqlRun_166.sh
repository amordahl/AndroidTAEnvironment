#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins  --aplength 2 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONST --cgalgo SPARK --callbacksourcemode SOURCELIST --dataflowsolver FLOWINSENSITIVE --implicit NONE --layoutmode NONE --maxcallbackspercomponent 7 --maxcallbacksdepth 7 --nocallbacks  --pathalgo SOURCESONLY --pathreconstructionmode NONE --pathspecificresults  --enablereflection  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
