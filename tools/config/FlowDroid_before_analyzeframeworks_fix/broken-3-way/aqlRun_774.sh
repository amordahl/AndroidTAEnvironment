#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo NONE --aliasflowins  --aplength 8 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONST --cgalgo SPARK --callbacksourcemode ALL --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit ARRAYONLY --layoutmode ALL --maxcallbackspercomponent 8 --maxcallbacksdepth 5 --noexceptions  --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode FAST --pathspecificresults  --enablereflection  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
