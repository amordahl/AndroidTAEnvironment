#!/bin/bash

java -Xmx${2}g -jar /home/asm140830/Documents/git/AndroidTAEnvironment/tools/Amandroid/argus-saf_2.12-3.2.0-assembly.jar t -o /home/asm140830/Documents/git/AndroidTAEnvironment/tools/Amandroid/results/${3} --ini config_sifalse_k4.ini --module COMMUNICATION_LEAKAGE --approach COMPONENT_BASED ${1}
