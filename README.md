# AndroidTAEnvironment
This repository contains the experimental artifacts to run our experiments in our *ISSTA 2021* paper, *Rethinking Android Taint Analysis Evaluation: A Study on the Impact of Tool Configuration Spaces*.

The directory structure is as follows.

## BREW and AQL-System
Contains our modified version of BREW from Pauck et al.'s *ESEC/FSE 2018* work, *Do Android Taint Analysis Tools Keep Their Promises?*.

## BrewRunner
Contains the utility we use to simplify running of BREW on multiple configuration files.

## Configurations
Contains the single-option and two-way configurations for *FlowDroid* and *DroidSafe*.

## Resources
Contains the various python and shell scripts we use to make running utilities and data analysis easier.

## Tools
Contains FlowDroid and DroidSafe. Furthermore, the *tools/config* subdirectory contains the different scripts that are used to run the various configurations of the two tools. These scripts are invoked by the configurations in the *configurations* file.

## Results
Contains the results from our experimental runs.

## Preprocessor
Contains APKCombiner, which is used to combine APKs for IAC detection.
