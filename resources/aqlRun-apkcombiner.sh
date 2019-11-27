#! /bin/bash

rm -rf workspace
rm -rf workspace_apps

sleep 5

./runApkCombiner.sh ${*:2}

mv *.apk results/${1}_combined.apk
