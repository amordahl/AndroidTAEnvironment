#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins  --aplength 8 --callbackanalyzer FAST --codeelimination PROPAGATECONST --cgalgo GEOM --callbacksourcemode NONE --dataflowsolver CONTEXTFLOWSENSITIVE --analyzeframeworks  --implicit ALL --layoutmode ALL --maxcallbackspercomponent 10 --maxcallbacksdepth 7 --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode PRECISE --enablereflection  --staticmode CONTEXTFLOWSENSITIVE --taintwrapper EASY > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
