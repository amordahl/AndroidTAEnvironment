#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo FLOWSENSITIVE --aliasflowins --aplength 4 --callbackanalyzer DEFAULT --codeelimination NONE --cgalgo SPARK --dataflowsolver CONTEXTFLOWSENSITIVE --implicit ARRAYONLY --maxcallbackspercomponent 120 --maxcallbacksdepth 50 --noexceptions --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathspecificresults --enablereflection --staticmode NONE --taintwrapper DEFAULT > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
