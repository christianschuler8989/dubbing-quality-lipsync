#!/bin/bash

# Current working directory
#currentDirectory=$(pwd)

# Default directory in case of missing input: CurrentWorkingDirectory
currentDirectory=${1:$(pwd)}

#######################################
# Create a testset for each directory #
#######################################
for testDirectory in ${currentDirectory}"/*" ;
do
  #############################################
  # Read video-file-names for current testset #
  #############################################
  for filename in ${testDirectory}"*.mp4";
  do
    echo "${filename}" >> ${currentDirectory}"/"
  done

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
  },{
    "Name": "Non-functional Test",
    "TestID": "004",
    "Files": {
      "Reference": "video/004_noRepeat_condition_02/visu_2021-01-09_Hoffnung_a2.0_001_0_cut.mp4",
      "1": "video/004_noRepeat_condition_02/audi_2021-01-09_Hoffnung_a2.0_002_0_0.60cut.mp4",
      "2": "video/004_noRepeat_condition_02/audi_2021-01-09_Hoffnung_a2.0_002_0_1.50cut.mp4",
      "3": "video/004_noRepeat_condition_02/visu_2021-01-09_Hoffnung_a2.0_002_4_cut.mp4",
      "4": "video/004_noRepeat_condition_02/visu_2021-01-09_Hoffnung_a2.0_002_6_cut.mp4",
      "5": "video/004_noRepeat_condition_02/visu_2021-01-09_Hoffnung_w2.0_001_7_cut.mp4",
    }
  },{
    "Name": "Test-naming Test",
    "TestID": "005",
    "Files": {
      "Reference": "video/005_repeat_condition_02/visu_2021-01-09_Tempo_a2.0_001_0_cut.mp4",
      "1": "video/005_repeat_condition_02/audi_2021-01-09_Tempo_o2.0_001_0_2.00cut.mp4",
      "2": "video/005_repeat_condition_02/audi_2021-01-09_Tempo_t2.0_001_0_2.00cut.mp4",
      "3": "video/005_repeat_condition_02/visu_2021-01-09_Tempo_o2.0_001_5_cut.mp4",
      "4": "video/005_repeat_condition_02/visu_2021-01-09_Tempo_t2.0_001_4_cut.mp4",
      "5": "video/005_repeat_condition_02/visu_2021-01-09_Tempo_t2.0_001_6_cut.mp4",
    }
  },{
    "Name": "Corona Test",
    "TestID": "006",
    "Files": {
      "Reference": "video/006_repeat_condition_02/visu_2021-01-09_Tempo_a2.0_001_0_cut.mp4",
      "1": "video/006_repeat_condition_02/audi_2021-01-09_Tempo_m2.0_001_0_1.50cut.mp4",
      "2": "video/006_repeat_condition_02/audi_2021-01-09_Tempo_o2.0_001_0_2.00cut.mp4",
      "3": "video/006_repeat_condition_02/visu_2021-01-09_Tempo_m2.0_001_4_cut.mp4",
      "4": "video/006_repeat_condition_02/visu_2021-01-09_Tempo_m2.0_001_6_cut.mp4",
      "5": "video/006_repeat_condition_02/visu_2021-01-09_Tempo_o2.0_001_5_cut.mp4",
    }
  },{
    "Name": "Sanity Test",
    "TestID": "007",
    "Files": {
      "Reference": "video/007_noRepeat_condition_05/visu_2021-01-09_Weihnachten_a2.0_001_0_cut.mp4",
      "1": "video/007_noRepeat_condition_05/visu_2021-01-09_Weihnachten_a2.0_002_6_cut.mp4",
      "2": "video/007_noRepeat_condition_05/visu_2021-01-09_Weihnachten_d2.0_001_6_cut.mp4",
      "3": "video/007_noRepeat_condition_05/visu_2021-01-09_Weihnachten_g2.0_001_6_cut.mp4",
      "4": "video/007_noRepeat_condition_05/visu_2021-01-09_Weihnachten_m2.0_001_6_cut.mp4",
      "5": "video/007_noRepeat_condition_05/visu_2021-01-09_Weihnachten_v2.0_001_6_cut.mp4",
    }
  }
]
'
