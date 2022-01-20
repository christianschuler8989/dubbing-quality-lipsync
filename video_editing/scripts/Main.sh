#!/bin/bash

##########################
# Required preperations: #
##########################
# /editing/material/movieName/clipName/video.mp4
#                                     /audio.txt
#                                     /audio.TextGrid

#############
# Execution #
#############
# Terminal: conda activate       # Otherwise textgrids can not be imported
# conda install -c conda-forge librosa
# conda install -c conda-forge textgrid (????)
# Terminal: bash ./scrMain.sh

#####################
# Mode of operation #
#####################
# Preperation of material for further processing
#myMode="preperation"
# Explorative experiments to locate phonemes of interest
#myMode="exploration"
# Modifying the video by copying and blending frames from around the phoneme[group]-position
#myMode="visualMod"
# Stretching and compressing the audio of the phoneme[groups] by specified factors
#myMode="audioMod"
# Modifying the audio and the video at the same time
#myMode="multiMod"
# Modifying the audio and the video at the same time but in different directions of each other
#myMod="mixMod"
# [TODO] Create video-clip-compositions with labeled sequences for easier sighting of findings from exploration-mode
#myMode="sighting"
# [TODO] Extract medatada for the phonemes under different conditions
#myMode="metadata"
myMode=$1

######################################
# Subcategory for modes of operation #
######################################
# "copy" copies the frames without modifications resulting in clips with intact lip-synchrony
#myModeFrame="copy"
# "shiftDirection" shifts the time-location of the phoneme by deleting/copying every second frame before/after
#myModeFrame="shiftLeft"
#myModeFrame="shiftRight"
# "meld" replaces the frames of the phoneme by combinations of neighbouring frames
#myModeFrame="meld"
myModeFrame=${2:-copy}          # Default-value if no input given

# "blind" blindly extracts all the phoneme-occurences
myModeFinder="blind"
# "sight" only extracts manually provided list of phoneme-occurences
#myModeFinder="sight"

#########################################################
# Sequence of desired factors for audio-editing process #
#########################################################
declare -a stretchFactors=(0.90)
#declare -a stretchFactors=(0.50) # Minimalistic testing
  #declare -a stretchFactors=(0.50 1.00 1.50)
  #stretchFactors=$(LANG=en seq -f '%1.2f' 0.50 0.10 1.50)
  #FACTORS=$(LANG=en seq -f '%1.2f' 0.50 0.10 1.50)
# Like [ 0.50, 0.60, 0.70, 0.80, 0.90, 1.00, 1.10, 1.20, 1.30, 1.40, 1.50 ]

######################################
# Phoneme-Groups for editing process #
######################################
# Random Explatory declare -a phonemeNames=("a" "E" "o" "O" "U" "I" "p" "b" "m" "f" "v" "6" "d" "s" "S" "t" "n" "N" "@" "l" "g" "h" "r" "z" "C" "w") # w = <p:> manually renamed in input-files
# Open Vowels declare -a phonemeNames=("a" "&" "A" "Q" "6")
# Open-mid Vowels declare -a phonemeNames=("E" "9" "3" "V" "O" "@")
# Close-mid Vowels declare -a phonemeNames=("e" "2" "8" "7" "o" "I" "Y" "U")
# Close Vowels declare -a phonemeNames=("i" "y" "1" "M" "u")
# Bilabial Consonants declare -a phonemeNames=("p" "b" "m" "B")
# Labiodental Consonants declare -a phonemeNames=("f" "v" "F")
# Alveolar Consonants declare -a phonemeNames=("t" "d" "n" "r" "s" "z" "l")
# Palatal Consonants declare -a phonemeNames=("c" "J" "C" "j" "L")
# Velar Consonants declare -a phonemeNames=("k" "g" "N" "x" "G")
# Glotal Consonants declare -a phonemeNames=("?" "h")
# At least one selected of almost all groups and additionally pauses (In TextGrid = <p:>)
# One phoneme from each group of interest:
# declare -a phonemeNames=("a" "E" "o" "i" "p" "b" "m" "f" "v" "t" "d" "k" "g" "h" "w") # w = <p:> manually renamed in input-files
#declare -a phonemeNames=("a" "p" "w") # w = <p:> manually renamed in input-files
#declare -a phonemeNames=("a" "p" "w") # Minimalistic testing
declare -a phonemeNames=("w")

#################################################
# Assumed frames-per-second of processed videos #
#################################################
myFPS=25

#################################################################
# Number of samples to be created under different circumstances #
#################################################################
# samplesize decides how many seconds should be in front of and right after the phoneme in the final clip
#declare -a samplesizes=(1 2 3 4 5)
declare -a samplesizes=(1.5)
size=2.0 # Default size of 1.5 (especially for visualMod) ### ! For cutting of buffer integer values needed as long as working with ffmpeg ! ###

# shiftFactor decides how many frames the phoneme should be moved to the left/beginning of the clip
declare -a shiftFactors=(0)
#declare -a shiftFactors=(0 2) # Minimalistic testing
shiftFactor=0 # Default value for no shift (especially for audioMod)

##############################
# Path to material-directory #
##############################
materialDirectory=$PWD/../material/


##############################################
##############################################
## Preprocessing including forced alignment ##
##############################################
##############################################
: '
# For the time being done by hand #

#############################
# G2P (Grapheme to Phoneme) #
#############################
# https://clarin.phonetik.uni-muenchen.de/BASWebServices/interface/Grapheme2Phoneme
# This web service G2P converts an orthographic text input into a canonical phonological transcript (standard pronunciation)
# Input: audio.txt
# Output: audio.par
########################### Service options
# Input format            = txt
# Input TextGrid tier     = ort
# Sample rate             = 16000
# Language                = German (DE)
# Imap mapping file       = No file selected
# Imap: case insensitive  = yes
# Output format           = bpf
# Output Symbol inventory = sampa
# Word stress             = no
# Syllabification         = no
# Text normalization      = no
# Keep annotation markers = no
# Alignment               = no
# Tool embedding          = no
# Feature set             = standard

###################
# WebMAUS General #
###################
# https://clarin.phonetik.uni-muenchen.de/BASWebServices/interface/WebMAUSGeneral
# This web service computes a phonetic segmentation and labeling for several languages based on the speech signal and a phonological transcript encoded in SAM-PA.
# Input: audio.wav && audio.par     # (.mp3 for german? .wav leads to ERROR)
# Output: audio.TextGrid
################### Service options
Language          = German (DE)
MAUS modus        = Language dependent default modus
Input Encoding    = X-SAMPA (ASCII)
Output format     = Praat (TextGrid)

##################################################################
# webMAUS application using .txt and .wav (.mp3 for not german?) #
##################################################################
# INPUT: audio.txt & audio.wav (audio.mp3 for not german?)
# OUTPUT: audio.par & audio.TextGrid
'

#########################################################
#########################################################
## Start of preperation of data for further processing ##
#########################################################
#########################################################
if [[ $myMode == "preperation" ]]
then
  ############################################################################
  # Convert video-clips to audio-files (.wav and .mp3) and create timestamps #
  ############################################################################
  # INPUT: video.mp4 & audio.TextGrid
  # OUTPUT: audio.wav & audio.mp3 & timestampsAll.txt
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      mkdir -p ${clipDirectory}"/outputCombined"
      mkdir -p ${clipDirectory}"/preperation"
      ffmpeg -loglevel warning -i $clipDirectory/video.mp4 $clipDirectory/preperation/audio.wav
      ffmpeg -loglevel warning -i $clipDirectory/video.mp4 $clipDirectory/preperation/audio.mp3
      python ./prepTextgridToTimestamp.py $clipDirectory/ $clipDirectory/preperation/ $myFPS
    done
  done
  ##################################################
  # Convert video.mp4 to sequence of images (.png) #
  ##################################################
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      bash ./prepVideoToFrames.sh $clipDirectory $myFPS
    done
  done
fi

##################################################
##################################################
## Start of processing-pipeline for exploration ##
##################################################
##################################################
# Extracting video-clips with a specified time-window around the searched phonemes
if [[ $myMode == "exploration" ]]
then
  ##################################
  # Create phoneme sub-directories #
  ##################################
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      for phoneme in "${phonemeNames[@]}" ; do
        mkdir -p $clipDirectory/exploration/$phoneme
      done
    done
  done
  #####################################
  # Create timewindow sub-directories #
  #####################################
  echo "Create all sub-directories for further processing:"
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      for phonemeDirectory in $clipDirectory/exploration/* ; do
        for size in "${samplesizes[@]}" ; do
          pathTimewindow=$phonemeDirectory/sec0$size
          mkdir -p $pathTimewindow
        done
      done
    done
  done

  #################################################
  # Find and create phoneme-window-timestamps.txt #
  #################################################
  echo "Find and create phoneme-window-timestamps.txt:"
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      for phonemeDirectory in $clipDirectory/exploration/* ; do
        phonemeName=${phonemeDirectory: -1}
        for size in "${samplesizes[@]}" ; do
          pathTimewindow=$phonemeDirectory/sec0$size
          pathTimestamps=$phonemeDirectory/../../preperation
          python explPhonemeWindowFinder.py $pathTimewindow $size $pathTimestamps $phonemeName $myModeFinder
        done
      done
    done
  done

  #######################################################
  # Create phoneme-window-clips.mp4 from timestamps.txt #
  #######################################################
  echo "Create phoneme-window-clips.mp4 from timestamps.txt "
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      clipName=${clipDirectory: -10}
      # This is where the marker positions should be calculated ONCE but then for for-loops break for some reason(?)
      for phonemeDirectory in $clipDirectory/exploration/* ; do
        phonemeName=${phonemeDirectory: -1}
        echo "Create timewindow-clips for $phonemeName"
        for size in "${samplesizes[@]}" ; do
          pathTimewindow=$phonemeDirectory/sec0$size
          # Check if directory exists (which will fail, if the videoclip does not contain this phoneme)
          if [ -d "$pathTimewindow" ]; then
            for timewindow in $pathTimewindow/* ; do
              for shiftFactor in "${shiftFactors[@]}" ; do
                bash explPhonemeWindowCreator.sh $timewindow $phonemeName $myFPS $size $myModeFrame $shiftFactor $clipName $myMode
              done
            done
          fi
        done
      done
    done
  done
fi

################################################################
################################################################
## Start of processing-pipeline for video-frame-manipulations ##
################################################################
################################################################
if [[ $myMode == "visualMod" ]]
then
  ###############################################################################################
  # Handling of special case where the shiftFactor does not matter for less processing overhead #
  ###############################################################################################
  if [[ $myModeFrame == "meld" ]]
  then
    declare -a shiftFactors=(0)
  fi
  ##################################
  # Create phoneme sub-directories #
  ##################################
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      clipName=${clipDirectory: -10}
      if [ -d "${clipDirectory}/visualMod" ]; then
        echo "Delete visualMod-directory before creating new one for clean processing."
        rm -r "${clipDirectory}/visualMod" # Gotta also delete sub-directories for this to work properly(!?)
      fi
      mkdir -p ${clipDirectory}"/visualMod"
      pathTimestampsAll=${clipDirectory}"/preperation"
      ####################################################################
      # Transfer information about interesting times into subdirectories #
      ####################################################################
      inputFile=${clipDirectory}"/interestingTimes.txt"
      while read line
      do
        echo "Read and save: ${line}"
        videoLine=( ${line} )
        videoName=${videoLine[0]}
        videoStart=${videoLine[1]}
        videoEnd=${videoLine[2]}
        videoDuration=${videoLine[3]}
        videoDirectory=${clipDirectory}"/visualMod/"${videoName}    # /Tempo
        mkdir -p ${videoDirectory}
        echo "${line}" > ${videoDirectory}"/tempLine.txt"           # /Tempo/tempLine.txt
      done < ${inputFile}
      ###############################################
      # For each "interesting" video(-subdirectory) #
      ###############################################
      for videoDirectory in ${clipDirectory}"/visualMod/"* ; do
        line=$(head -n 1 ${videoDirectory}"/tempLine.txt")
        echo "Start processing of: ${line}"
        videoLine=( ${line} )
        videoName=${videoLine[0]}
        videoStart=${videoLine[1]}
        videoEnd=${videoLine[2]}
        videoDuration=${videoLine[3]}
      #while IFS= read -r line
      #do
      #  echo "Start processing of: ${line}"
      #  videoLine=( ${line} )
      #  videoName=${videoLine[0]}
      #  videoStart=${videoLine[1]}
      #  videoEnd=${videoLine[2]}
      #  videoDuration=${videoLine[3]}
      #  videoDirectory=${clipDirectory}"/visualMod/"${videoName}
      #  mkdir -p ${videoDirectory}
      #  pathTimestampsAll=${clipDirectory}"/preperation"
        #########################################################
        # Create new timestampsVideo.txt from timestampsAll.txt #
        #########################################################
        python videoWindowFinder.py ${videoDirectory} $size $pathTimestampsAll $videoStart $videoEnd
        ##################################
        # Create phoneme-sub-directories #
        ##################################
        for phoneme in "${phonemeNames[@]}" ; do
          echo "The current phoneme is: ${phoneme}"
          pathPhoneme=${videoDirectory}"/"${phoneme}
          #mkdir -p ${pathPhoneme} # Moved into visualPhonemeWindowFinder.py (only directory for found phonemes)
          python phonemeWindowFinder.py ${pathPhoneme} $size ${videoDirectory} $phoneme $myModeFinder $videoStart $videoEnd
          #####################################################
          # Create different variations of the specified clip #
          #####################################################
          # This is where the marker positions should be calculated ONCE but then for for-loops break for some reason(?)
          # Check if directory exists (which will fail, if the videoclip does not contain this phoneme)
          if [ -d "$pathPhoneme" ]; then
            # For each occurence of this phoneme inside the video-clip
            for phonemeDirectory in ${pathPhoneme}/* ; do
              echo "Create timewindow-clips for ${phoneme}"
              for shiftFactor in "${shiftFactors[@]}" ; do
                bash visualPhonemeWindowCreator.sh $phonemeDirectory $phoneme $myFPS $size $myModeFrame $shiftFactor $clipName $videoDuration $videoName $myMode
              done
            done
          fi
        done
      done
      #done < ${inputFile}
    done
  done
fi

##########################################################
##########################################################
## Start of processing-pipeline for audio-manipulations ##
##########################################################
##########################################################
if [[ $myMode == "audioMod" ]]
then
  ##################################
  # Create phoneme sub-directories #
  ##################################
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      clipName=${clipDirectory: -10}
      if [ -d "${clipDirectory}/audioMod" ]; then
        echo "Delete audioMod-directory before creating new one for clean processing."
        rm -r "${clipDirectory}/audioMod" # Gotta also delete sub-directories for this to work properly(!?)
      fi
      mkdir -p ${clipDirectory}"/audioMod"
      pathTimestampsAll=${clipDirectory}"/preperation"
      inputFile=${clipDirectory}"/interestingTimes.txt"
      #while IFS= read -r line
      while read line
      do
        echo "Read and save: ${line}"
        videoLine=( ${line} )
        videoName=${videoLine[0]}
        videoStart=${videoLine[1]}
        videoEnd=${videoLine[2]}
        videoDuration=${videoLine[3]}
        videoDirectory=${clipDirectory}"/audioMod/"${videoName}
        mkdir -p ${videoDirectory}
        echo "${line}" > ${videoDirectory}"/tempLine.txt"
      done < ${inputFile}
      for videoDirectory in ${clipDirectory}"/audioMod/"* ; do
        line=$(head -n 1 ${videoDirectory}"/tempLine.txt")
        echo "Start processing of: ${line}"
        videoLine=( ${line} )
        videoName=${videoLine[0]}
        videoStart=${videoLine[1]}
        videoEnd=${videoLine[2]}
        videoDuration=${videoLine[3]}
        #########################################################
        # Create new timestampsVideo.txt from timestampsAll.txt #
        #########################################################
        python videoWindowFinder.py ${videoDirectory} ${size} ${pathTimestampsAll} ${videoStart} ${videoEnd}
        ##################################
        # Create phoneme-sub-directories #
        ##################################
        for phoneme in "${phonemeNames[@]}" ; do
          echo "The current phoneme is: ${phoneme}"
          pathPhoneme=${videoDirectory}"/"${phoneme}
          #mkdir -p ${pathPhoneme} # Moved into visualPhonemeWindowFinder.py (only directory for found phonemes)
          python phonemeWindowFinder.py ${pathPhoneme} $size ${videoDirectory} $phoneme $myModeFinder $videoStart $videoEnd
          #####################################################
          # Create different variations of the specified clip #
          #####################################################
          # This is where the marker positions should be calculated ONCE but then for for-loops break for some reason(?)
          # Check if directory exists (which will fail, if the videoclip does not contain this phoneme)
          if [ -d "$pathPhoneme" ]; then
            # For each occurence of this phoneme inside the video-clip [001, 002, 003, ...]
            for phonemeDirectory in ${pathPhoneme}/* ; do
              echo "Create timewindow-clips for ${phoneme} ${phonemeDirectory: -3}"
              ###################################################################################
              # Sort the content of the timestamps.txt in accending order in regard to column 2 #
              ###################################################################################
              sort -n -k 2 -o ${phonemeDirectory}"/timestamps.txt" ${phonemeDirectory}"/timestamps.txt"
              ################################################################################
              # Create directory for and then extract the audio-snippets from original audio #
              ################################################################################
              pathSnippets=${phonemeDirectory}"/snippets"
              mkdir -p ${pathSnippets}
              bash audioCreateSnippets.sh $phonemeDirectory $clipDirectory $pathSnippets"/"
              for stretchFactor in "${stretchFactors[@]}" ; do
                for shiftFactor in "${shiftFactors[@]}" ; do
                  ####################################################
                  # Create one variation of the clip for each factor #
                  ####################################################
                  bash audioPhonemeWindowCreator.sh $phonemeDirectory $phoneme $myFPS $size $myModeFrame $shiftFactor $clipName $videoDuration $videoName $stretchFactor $myMode
                done
              done
            done
          fi
        done
      done
    done
  done
fi


####################################################################################
####################################################################################
## Start of processing-pipeline for audio- and video-manipulations same direction ##
####################################################################################
####################################################################################
if [[ $myMode == "multiMod" ]]
then
  #####################################
  # Starting with audio-modifications #
  #####################################
  # Create phoneme sub-directories #
  ##################################
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      clipName=${clipDirectory: -10}
      if [ -d "${clipDirectory}/audioMod" ]; then
        echo "Delete audioMod-directory before creating new one for clean processing."
        rm -r "${clipDirectory}/audioMod" # Gotta also delete sub-directories for this to work properly(!?)
      fi
      mkdir -p ${clipDirectory}"/audioMod"
      pathTimestampsAll=${clipDirectory}"/preperation"
      inputFile=${clipDirectory}"/interestingTimes.txt"
      #while IFS= read -r line
      while read line
      do
        echo "Read and save: ${line}"
        videoLine=( ${line} )
        videoName=${videoLine[0]}
        videoStart=${videoLine[1]}
        videoEnd=${videoLine[2]}
        videoDuration=${videoLine[3]}
        videoDirectory=${clipDirectory}"/audioMod/"${videoName}
        mkdir -p ${videoDirectory}
        echo "${line}" > ${videoDirectory}"/tempLine.txt"
      done < ${inputFile}
      for videoDirectory in ${clipDirectory}"/audioMod/"* ; do
        line=$(head -n 1 ${videoDirectory}"/tempLine.txt")
        echo "Start processing of: ${line}"
        videoLine=( ${line} )
        videoName=${videoLine[0]}
        videoStart=${videoLine[1]}
        videoEnd=${videoLine[2]}
        videoDuration=${videoLine[3]}
        #########################################################
        # Create new timestampsVideo.txt from timestampsAll.txt #
        #########################################################
        python videoWindowFinder.py ${videoDirectory} ${size} ${pathTimestampsAll} ${videoStart} ${videoEnd}
        ##################################
        # Create phoneme-sub-directories #
        ##################################
        for phoneme in "${phonemeNames[@]}" ; do
          echo "The current phoneme is: ${phoneme}"
          pathPhoneme=${videoDirectory}"/"${phoneme}
          #mkdir -p ${pathPhoneme} # Moved into visualPhonemeWindowFinder.py (only directory for found phonemes)
          python phonemeWindowFinder.py ${pathPhoneme} $size ${videoDirectory} $phoneme $myModeFinder $videoStart $videoEnd
          #####################################################
          # Create different variations of the specified clip #
          #####################################################
          # This is where the marker positions should be calculated ONCE but then for for-loops break for some reason(?)
          # Check if directory exists (which will fail, if the videoclip does not contain this phoneme)
          if [ -d "$pathPhoneme" ]; then
            # For each occurence of this phoneme inside the video-clip [001, 002, 003, ...]
            for phonemeDirectory in ${pathPhoneme}/* ; do
              echo "Create timewindow-clips for ${phoneme} ${phonemeDirectory: -3}"
              ###################################################################################
              # Sort the content of the timestamps.txt in accending order in regard to column 2 #
              ###################################################################################
              sort -n -k 2 -o ${phonemeDirectory}"/timestamps.txt" ${phonemeDirectory}"/timestamps.txt"
              ################################################################################
              # Create directory for and then extract the audio-snippets from original audio #
              ################################################################################
              pathSnippets=${phonemeDirectory}"/snippets"
              mkdir -p ${pathSnippets}
              bash audioCreateSnippets.sh $phonemeDirectory $clipDirectory $pathSnippets"/"
              for stretchFactor in "${stretchFactors[@]}" ; do
                for shiftFactor in "${shiftFactors[@]}" ; do
                  ####################################################
                  # Create one variation of the clip for each factor #
                  ####################################################
                  bash audioPhonemeWindowCreator.sh $phonemeDirectory $phoneme $myFPS $size $myModeFrame $shiftFactor $clipName $videoDuration $videoName $stretchFactor $myMode
                done
              done
            done
          fi
        done
      done
    done
  done
fi


##########################################################################################
##########################################################################################
## Start of processing-pipeline for audio- and video-manipulations different directions ##
##########################################################################################
##########################################################################################
if [[ $myMode == "mixMod" ]]
then
  #####################################
  # Starting with audio-modifications #
  #####################################
  # Create phoneme sub-directories #
  ##################################
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      clipName=${clipDirectory: -10}
      if [ -d "${clipDirectory}/audioMod" ]; then
        echo "Delete audioMod-directory before creating new one for clean processing."
        rm -r "${clipDirectory}/audioMod" # Gotta also delete sub-directories for this to work properly(!?)
      fi
      mkdir -p ${clipDirectory}"/audioMod"
      pathTimestampsAll=${clipDirectory}"/preperation"
      inputFile=${clipDirectory}"/interestingTimes.txt"
      #while IFS= read -r line
      while read line
      do
        echo "Read and save: ${line}"
        videoLine=( ${line} )
        videoName=${videoLine[0]}
        videoStart=${videoLine[1]}
        videoEnd=${videoLine[2]}
        videoDuration=${videoLine[3]}
        videoDirectory=${clipDirectory}"/audioMod/"${videoName}
        mkdir -p ${videoDirectory}
        echo "${line}" > ${videoDirectory}"/tempLine.txt"
      done < ${inputFile}
      for videoDirectory in ${clipDirectory}"/audioMod/"* ; do
        line=$(head -n 1 ${videoDirectory}"/tempLine.txt")
        echo "Start processing of: ${line}"
        videoLine=( ${line} )
        videoName=${videoLine[0]}
        videoStart=${videoLine[1]}
        videoEnd=${videoLine[2]}
        videoDuration=${videoLine[3]}
        #########################################################
        # Create new timestampsVideo.txt from timestampsAll.txt #
        #########################################################
        python videoWindowFinder.py ${videoDirectory} ${size} ${pathTimestampsAll} ${videoStart} ${videoEnd}
        ##################################
        # Create phoneme-sub-directories #
        ##################################
        for phoneme in "${phonemeNames[@]}" ; do
          echo "The current phoneme is: ${phoneme}"
          pathPhoneme=${videoDirectory}"/"${phoneme}
          #mkdir -p ${pathPhoneme} # Moved into visualPhonemeWindowFinder.py (only directory for found phonemes)
          python phonemeWindowFinder.py ${pathPhoneme} $size ${videoDirectory} $phoneme $myModeFinder $videoStart $videoEnd
          #####################################################
          # Create different variations of the specified clip #
          #####################################################
          # This is where the marker positions should be calculated ONCE but then for for-loops break for some reason(?)
          # Check if directory exists (which will fail, if the videoclip does not contain this phoneme)
          if [ -d "$pathPhoneme" ]; then
            # For each occurence of this phoneme inside the video-clip [001, 002, 003, ...]
            for phonemeDirectory in ${pathPhoneme}/* ; do
              echo "Create timewindow-clips for ${phoneme} ${phonemeDirectory: -3}"
              ###################################################################################
              # Sort the content of the timestamps.txt in accending order in regard to column 2 #
              ###################################################################################
              sort -n -k 2 -o ${phonemeDirectory}"/timestamps.txt" ${phonemeDirectory}"/timestamps.txt"
              ################################################################################
              # Create directory for and then extract the audio-snippets from original audio #
              ################################################################################
              pathSnippets=${phonemeDirectory}"/snippets"
              mkdir -p ${pathSnippets}
              bash audioCreateSnippets.sh $phonemeDirectory $clipDirectory $pathSnippets"/"
              for stretchFactor in "${stretchFactors[@]}" ; do
                for shiftFactor in "${shiftFactors[@]}" ; do
                  ####################################################
                  # Create one variation of the clip for each factor #
                  ####################################################
                  bash audioPhonemeWindowCreator.sh $phonemeDirectory $phoneme $myFPS $size $myModeFrame $shiftFactor $clipName $videoDuration $videoName $stretchFactor $myMode
                done
              done
            done
          fi
        done
      done
    done
  done
fi

#################################################
#################################################
## Start of extraction of metadata of phonemes ##
#################################################
#################################################
if [[ $myMode == "metadata" ]]
then
  #####################################################
  # Create all sub-directories for further processing #
  #####################################################
  # INPUT:
  # OUTPUT:
  # TERMINAL: bash scrCreateFramesFromVideo.sh pathToVideoFile
  #: '
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      for phoneme in "${phonemeNames[@]}" ; do
        mkdir -p $clipDirectory/metadata/$phoneme
      done
      for group in "${phonemeGroups[@]}" ; do
        mkdir -p $clipDirectory/phonemeGroups/$group
      done
    done
  done
fi

#############################################################
#############################################################
## Start of processing the video-clips for easier sighting ##
#############################################################
#############################################################
if [[ $myMode == "sighting" ]]
then
  ####################################################
  # Create video-clip-sequences.mp4 for each phoneme #
  ####################################################
  echo "Create video-clip-sequence.mp4 for each phoneme "
  for movieDirectory in $materialDirectory*/ ; do
    for clipDirectory in $movieDirectory* ; do
      # Create "sightings"-directory for each video-clip
      sightingsDirectory=$clipDirectory/sightings
      mkdir -p $sightingsDirectory
      for phonemeDirectory in $clipDirectory/phonemes/* ; do
        phonemeName=${phonemeDirectory: -1}
        echo "Create video-clip-sequence for $phonemeName"
        #for size in "${samplesizes[@]}" ; do
        pathTimewindow=$phonemeDirectory/exploration/finds
          # Check if directory exists (which will fail, if the videoclip does not contain this phoneme)
        bash sightCreateClipSequence.sh $pathTimewindow $phonemeName $myFPS $samplesizes $shiftFactors
          #if [ -d "$pathTimewindow" ]; then
          #  for timewindow in $pathTimewindow/* ; do
          #    for shiftFactor in "${shiftFactors[@]}" ; do
          #      bash sightPhonemeWindowCreator.sh $timewindow $phonemeName $myFPS $size $myModeFrame $shiftFactor
          #    done
          #  done
          #fi
        #done
      done
    done
  done
fi
