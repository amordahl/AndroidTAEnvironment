#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins  --aplength 1 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONST --cgalgo SPARK --callbacksourcemode ALL --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --layoutmode NONE --maxcallbackspercomponent 4 --maxcallbacksdepth 6 --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode NONE --enablereflection  --singlejoinpointabstraction  --staticmode NONE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
