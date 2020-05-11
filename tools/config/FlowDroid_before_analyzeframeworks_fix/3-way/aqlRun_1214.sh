#!/bin/bash

java -Xmx${1}g -jar $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt --aliasalgo PTSBASED --aliasflowins --aplength 6 --callbackanalyzer DEFAULT --codeelimination REMOVECODE --cgalgo RTA --dataflowsolver FLOWINSENSITIVE --implicit ALL --layoutmode PWD --maxcallbackspercomponent 6 --maxcallbacksdepth 100 --nocallbacks --nothischainreduction --pathalgo CONTEXTINSENSITIVE --pathreconstructionmode PRECISE --pathspecificresults --enablereflection --staticmode CONTEXTFLOWSENSITIVE --taintwrapper NONE > ${4} 2>&1

python $ANDROID_TA_ENVIRONMENT_HOME/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
