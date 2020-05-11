#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo LAZY --aliasflowins  --aplength 7 --callbackanalyzer DEFAULT --codeelimination PROPAGATECONST --cgalgo RTA --callbacksourcemode NONE --dataflowsolver FLOWINSENSITIVE --implicit ALL --layoutmode ALL --maxcallbackspercomponent 3 --maxcallbacksdepth 2 --nothichainreduction  --pathalgo SOURCESONLY --pathreconstructionmode FAST --pathspecificresults  --enablereflection  --singlejoinpointabstraction  --staticmode CONTEXTFLOWINSENSITIVE --taintwrapper STUBDROID > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
