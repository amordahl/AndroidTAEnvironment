#!/bin/bash

java -Xmx${1}g -jar /home/asm140830/Documents/git/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a ${2} -p ${3} -s /home/asm140830/Documents/git/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-android/SourcesAndSinks.txt -al 0 > ${4} 2>&1

python /home/asm140830/Documents/git/AndroidTAEnvironment/tools/FlowDroid/soot-infoflow-cmd/target/manipulateOutput.py ${4}
