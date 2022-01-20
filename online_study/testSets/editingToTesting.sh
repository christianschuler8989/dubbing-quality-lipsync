#!/bin/bash

# Current working directory
#currentDirectory=$(pwd)

# Default directory in case of missing input: CurrentWorkingDirectory
currentDirectory=${1:-$PWD}

#testCounter=%03d # ZERO-PADDING?!
testCounter=95

# Variable Test-Names?
testName="TestName"

echo "" > ${currentDirectory}"/testSets.txt"

#######################################
# Create a testset for each directory #
#######################################
for testsetDirectory in ${currentDirectory}"/actualTestSets_hiddenRef_midAnchor_lowAnchor"/* ;
do
  # Extract name of test from directory-name
  testName=${testsetDirectory#*"base_"}
  # Start of every testset
  #echo '{ "Name": "'${testName}'", "TestID": "'`printf "%03d" "${testCounter}"`'", "Files": {' >> ${currentDirectory}"/tempTest.txt"
  # Alternative version ID <=> Name
  echo -e '{ \n' "\t"'"Name": "'`printf "%03d" "${testCounter}"`'", \n \t"TestID": "'${testName}'", \n \t"Files": \n\t{' >> ${currentDirectory}"/testSets.txt"
  #############################################
  # Read video-file-names for current testset #
  #############################################
  itemCounter=0
  for filename in ${testsetDirectory}/*".mp4";
  do
    # Strip the filename of its path
    actualName=$(basename ${filename})
    # If it is the fist item (=0), then it is the reference
    if [[ ${itemCounter} = 0 ]]; then
      echo -e "\t""\t"'"Reference": "video/'${actualName}'",' >> ${currentDirectory}"/testSets.txt"
    # If it is not the first item, use the itemCounter for naming
    else
      echo -e "\t""\t"'"'${itemCounter}'": "video/'${actualName}'",' >> ${currentDirectory}"/testSets.txt"
    fi
    # Next file in this testset
    let itemCounter++
  done
  echo -e "\t"'} \n},' >> ${currentDirectory}"/testSets.txt"
  # Next testset (directory)
  let testCounter++
done

################################
# Write testsets to output.txt #
################################


###################################################
# Transfer testsets into the beaglejs config-file #
###################################################
# For the time being done manually with the good old Copy-Paste-Combo



############
# Template #
############
: '
"Testsets": [
  //
  {
    "Name": "Function Test",
    "TestID": "001",
    "Files": {
      "Reference": "video/001_noRepeat_condition_01/visu_2021-01-09_Ziel_b2.0_001_0_cut.mp4",
      "1": "video/001_noRepeat_condition_01/audi_2021-01-09_Ziel_b2.0_001_0_2.00cut.mp4",
      "2": "video/001_noRepeat_condition_01/visu_2021-01-09_Ziel_b2.0_001_2_cut.mp4",
      "3": "video/001_noRepeat_condition_01/visu_2021-01-09_Ziel_b2.0_001_4_cut.mp4",
      "4": "video/001_noRepeat_condition_01/visu_2021-01-09_Ziel_b2.0_001_6_cut.mp4",
      "5": "video/001_noRepeat_condition_01/visu_2021-01-09_Ziel_b2.0_001_7_cut.mp4",
    }
  },{
    "Name": "Stress Test",
    "TestID": "002",
    "Files": {
      "Reference": "video/002_repeat_condition_01/visu_2021-01-09_Start_m2.0_001_0_cut.mp4",
      "1": "video/002_repeat_condition_01/visu_2021-01-09_Start_m2.0_001_1_cut.mp4",
      "2": "video/002_repeat_condition_01/visu_2021-01-09_Start_m2.0_001_2_cut.mp4",
      "3": "video/002_repeat_condition_01/visu_2021-01-09_Start_m2.0_001_3_cut.mp4",
      "4": "video/002_repeat_condition_01/visu_2021-01-09_Start_m2.0_001_4_cut.mp4",
      "5": "video/002_repeat_condition_01/visu_2021-01-09_Start_m2.0_001_7_cut.mp4",
    }
  },{
    "Name": "Black-box Test",
    "TestID": "003",
    "Files": {
      "Reference": "video/003_repeat_condition_01/visu_2021-01-09_Start_t2.0_001_0_cut.mp4",
      "1": "video/003_repeat_condition_01/audi_2021-01-09_Start_t2.0_001_0_0.60cut.mp4",
      "2": "video/003_repeat_condition_01/audi_2021-01-09_Start_t2.0_001_0_2.00cut.mp4",
      "3": "video/003_repeat_condition_01/visu_2021-01-09_Start_t2.0_001_3_cut.mp4",
      "4": "video/003_repeat_condition_01/visu_2021-01-09_Start_t2.0_001_5_cut.mp4",
      "5": "video/003_repeat_condition_01/visu_2021-01-09_Start_t2.0_001_7_cut.mp4",
    }
  },
]
'
