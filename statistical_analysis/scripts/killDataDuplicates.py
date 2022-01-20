#!/usr/bin/env python
#
# Input: Bunch of .txt files (results) with the gradings of study-participants
#
# Output: A neat .csv for easy statistical analysis
#
# Author: Christian (Doofnase) Schuler
# Date: 2021 Nov
################################################################################

######## Preperation ###########################################################
# Name of study-run as variable input-parameter
study_run = "all" # "yellow", "red", "purple"

# Define path to input-txt-files
pathInputTextfiles = "./../data/" + study_run + "/data_still_twitching/"

from os import listdir
from os.path import isfile, join

######## Read file-paths #######################################################
# Only take names of files not of directories
pathInputTextfilesArray = [pathInputTextfiles+f for f in listdir(pathInputTextfiles) if isfile(join(pathInputTextfiles, f))]

# Define path to output-csv-files
pathOutputCsv = "./../data/" + study_run + "/data_preprocessed/"
outputCsv = pathOutputCsv + "data_preprocessed.csv"

# Ugly globally used variable to generate unique identifier for rows (observations)
ResultIDCounter = 0
# Coutner to generate unique UserNames for empty instances of this field
generated_name_counter = 1

# [TODO]: Path for intermediate txt-files:
pathOutputTextfiles = "./../data/" + study_run + "/data_raw/"


######## Read file-contents ####################################################

#############################################################
# Read all the result of the participants for preprocessing #
#############################################################
import json

def resultTxtReader(inputTextfile):
    with open(inputTextfile) as inputTxt:
        data = inputTxt.read()

    # Reconstructing the data as a dictonary (does not work with the current format of results...)
    #dataJsonDictionary = json.loads(data)
    # Load the results of all the trials into a list
    dataList = json.loads(data)

    # Trial-Results of a single participant
    userData = []

    for element in dataList:
        # Drop all trials that were not part of this participants session
        if element != None:
            userData.append(element)

    userMeta = userData[-1]
    userData = userData[:-1]

    return userMeta, userData

tempUserMetasAndUserDatasAll = []

print("Read input-textfiles containing trial-results from: " + str(pathInputTextfiles))
for inputTextfile in pathInputTextfilesArray:
    userMeta, userData = resultTxtReader(inputTextfile)
    tempUserMetasAndUserDatasAll.append([userMeta, userData, inputTextfile])

# => # tempUserMetasAndUserDatasAll = [ [result01], [result02], ... ]

#########################################################
# Only consider the last result per session (SessionID) #
#########################################################
# Read SessionIDs
sessionIDs = []
for currentResult in tempUserMetasAndUserDatasAll:
    if currentResult[0]["SessionID"] not in sessionIDs:
        sessionIDs.append(currentResult[0]["SessionID"])
################################################################################

userMetasAndUserDatas = []

# Insert entry for each session
for sessionID in sessionIDs:
    userMetasAndUserDatas.append([sessionID])

# First check if there already is a prior-result with this SessionID
for currentResult in tempUserMetasAndUserDatasAll:
    currentSessionID = currentResult[0]["SessionID"]
    indexOfThisSession = sessionIDs.index(currentSessionID)
    if len(userMetasAndUserDatas[indexOfThisSession]) == 1:
        # This is the first result with this SessionID
        userMetasAndUserDatas[indexOfThisSession].append(currentResult)
    else:
        # There is already a prior-result that has to be compared
        currentSeqNum = currentResult[0]["SeqNum"]
        priorSeqNum = userMetasAndUserDatas[indexOfThisSession][1][0]["SeqNum"]
        # Compare the SeqNum of current and prior result
        if currentSeqNum > priorSeqNum:
            # Remove/Replace the prior result with the current one
            userMetasAndUserDatas[indexOfThisSession][1] = currentResult

################################################################################
# userMetasAndUserDatas = [ [session01], [session02], [session03], ...]
#             session01 = [SessionID, [userMeta], [userData], textFilename]
#              userMeta = [[Trial01], [Trial02], [Trial03], ... ]
#               Trial01 = [{"TestID":"tempo_all_aL",
#                           "Runtime":49157,
#                           "rating":{"1":0,"2":0,"3":0,"4":0,"5":0,"Reference":0},
#                           "filename":{"1":"video/audioMod_2021-01-09_Tempo_p_001_shiftLeft0_0.90cut.mp4",
#                                       "2":"video/audioMod_2021-01-09_Tempo_p_001_shiftLeft4_0.90cut.mp4",
#                                       "3":"video/audioMod_2021-01-09_Tempo_w_001_shiftLeft4_0.90cut.mp4",
#                                       "4":"video/mixMod_2021-01-09_Tempo_p_001_shiftLeft4_0.90cut.mp4",
#                                       "5":"video/multiMod_2021-01-09_Tempo_p_001_shiftRight4_0.90cut.mp4",
#                                       "Reference":"video/audioMod_2021-01-09_Tempo_a_001_shiftLeft4_0.90cut.mp4"}
#                         }]
#userMetasAndUserDatas = []
################################################################################






################################################################################
#
################################################################################
#
################################################################################
#
# [TODO]: Write into txt-file instead of directly into csv-file
#         to ease bug-checking later on
#
################################################################################
#
################################################################################
#
################################################################################

#####################################################
# Get filename of input-textfile for each SessionId #
#####################################################
#for sessionID in sessionIDs:
#    indexOfCurrentID = sessionIDs.index(sessionID)
#    currentSessionSeqNum = userMetasAndUserDatas[indexOfCurrentID][1][0]["SeqNum"]

##########################################################
# Write the result of the participants for preprocessing #
##########################################################
#def resultTxtWriter(resultToBeSavedData, resultToBeSavedMeta, outputTextfileName):
#    with open(outputTextfileName) as outputTxt:
#        outputTxt.write(str(resultToBeSavedData))
#        outputTxt.write(str(resultToBeSavedMeta))
#
#
#print("Save trial-results into separate textfiles again.")
#for pairOfUserData in userMetasAndUserDatas:
#    # pairOfUserData = [SessionID, [ [userMeta], [userData], textfileName ] ]
#    resultTxtWriter(pairOfUserData[1][1], pairOfUserData[1][0], pairOfUserData[1][2])

################################################################################
#
################################################################################
#
################################################################################



######################################################################################################################################
# Transform the information from the .txt into the corresponding dictionary as optimal format for .csv (which in turn is good for R) #
######################################################################################################################################
def txtToDictTransformer(userMeta, userData):
    # Each combination of userMeta and userData should correspond to a unique session inside the study

    ############
    # UserName #
    ############
    # In case no UserName was given, set a generic one
    if userMeta["UserName"] == "":
        global generated_name_counter
        current_username = "Urist_Mc_" + str(generated_name_counter)
        generated_name_counter += 1
    #elif len(userMeta["UserName"]) > 13:        # !!! # This generates duplicates for long UserNames...
    #    current_username = "Urist_" + userMeta["UserName"][0:5] + "_" + str(generated_name_counter)
    #    generated_name_counter += 1
    else:
        current_username = userMeta["UserName"]

    ################
    # UserLanguage #
    ################
    # If no UserLanguage has been provided it is assumed to be german, as instructed
    if userMeta["UserLanguage"] == "":
        current_userlanguage = "deutsch"
    else:
        current_userlanguage = userMeta["UserLanguage"]
    ################
    # UserEyesight #
    ################
    # If no UserEyesight has been provided it is assumed to be unimpaired
    if userMeta["UserEyesight"] == "":
        current_usereyesight = "Unimpaired"
    else:
        current_usereyesight = userMeta["UserEyesight"]
    ###############
    # UserHearing #
    ###############
    # If no UserHearing has been provided it is assumed to be unimpaired
    if 'userHearing' in userMeta:
        if userMeta["UserHearing"] == "":
            current_userhearing = "Unimpaired"
        else:
            current_userhearing = userMeta["UserHearing"]
    else:
        current_userhearing = "Unimpaired"
    ###############
    # UserComment #
    ###############
    if "UserComment" in userMeta:
    #if userMeta["UserComment"] != None:
        current_comment = userMeta["UserComment"]
    else:
        current_comment = "Dein Kommentar..."
    ##############
    # User EMail #
    ##############
    if "UserEmail" in userMeta:
    #if userMeta["UserEmail"] != None:
        if userMeta["UserEmail"] != "":
            current_mail = userMeta["UserEmail"]
        else:
            current_mail = "None"
    else:
        current_mail = "None"

    ###########################
    # Processing of a session #
    ###########################
    userDictArray = []
    for trialResult in userData:
        # => trialResult =
        # { 'TestID': 'tempo_all_aL',
        #   'Runtime': 340443,
        #   'rating': { '1': 100,
        #               '2': 64,
        #               '3': 38,
        #               '4': 45,
        #               '5': 41,
        #               'Reference': 77},
        #   'filename': {   '1': 'video/audioMod_2021-01-09_Tempo_p_001_shiftLeft0_0.90cut.mp4',
        #                   '2': 'video/audioMod_2021-01-09_Tempo_p_001_shiftLeft4_0.90cut.mp4',
        #                   '3': 'video/audioMod_2021-01-09_Tempo_w_001_shiftLeft4_0.90cut.mp4',
        #                   '4': 'video/mixMod_2021-01-09_Tempo_p_001_shiftLeft4_0.90cut.mp4',
        #                   '5': 'video/multiMod_2021-01-09_Tempo_p_001_shiftRight4_0.90cut.mp4',
        #                   'Reference': 'video/audioMod_2021-01-09_Tempo_a_001_shiftLeft4_0.90cut.mp4'}}
        #print("trialResult")
        #print(trialResult)
        #########################################
        # Picking apart 'filename' and 'rating' #
        #########################################
        # Extracting filename of excerpt and TestID
        current_excerpt = trialResult["filename"]['1'].split("_")[2]
        current_testID = trialResult["TestID"]
        current_trial_modification = current_testID.split("_")[2] # For adjusting reference-data
        # => = "aL" | "aR" | "mixL" | "mixR" | "mulL" | "mulR" | "vL" | "vR" | "a"/"p"/"w" (special-case: all):
        #       => "tempo_all_a_left", "tempo_all_a_right", "tempo_all_p_left", "tempo_all_p_right", "tempo_all_w_left", "tempo_all_w_right" . . .
        #####################################################################
        # Handling of differing naming for the trials anchors (mid and low) #
        #####################################################################
        if current_trial_modification == "mixL":
            current_trial_modification = "iL"
        elif current_trial_modification == "mixR":
            current_trial_modification = "iR"
        elif current_trial_modification == "mulL":
            current_trial_modification = "uL"
        elif current_trial_modification == "mulR":
            current_trial_modification = "uR"

        #boolean_mixedTrialOfAll = False

        # Then the values corresponding to the current item (trial-object-attribute) are filled in

        # This happens by iterating through the items of the dictionary "rating"
        current_filenames = trialResult["filename"]
        current_gradings = trialResult["rating"]
        view_on_grading = current_gradings.items()
        # => view_on_rating = ([("1", 99), ("2", 15), ("3", 77), ...])

        ###################################################
        # Determine study corresponding to trial (TestID) #
        ###################################################
        current_study = "Unknown"

        ######## Green = Anchors #
        if current_testID == "tempo_all_aL" or \
        current_testID == "tempo_all_vR":
            current_study = "Green"

        ######## Blue #
        if current_testID == "anfang_a_aL_big" or \
        current_testID == "anfang_a_aR_big" or \
        current_testID == "anfang_a_vR" or \
        current_testID == "euro_p_aL_big" or \
        current_testID == "euro_p_aR_big" or \
        current_testID == "euro_p_mixR" or \
        current_testID == "euro_p_vL_big" or \
        current_testID == "euro_p_vR_big" or \
        current_testID == "paar_w_vL" or \
        current_testID == "paar_w_vR" or \
        current_testID == "pandemie_p_aL_big" or \
        current_testID == "pandemie_p_aR_big" or \
        current_testID == "pandemie_p_mixL" or \
        current_testID == "pandemie_p_vL_big" or \
        current_testID == "pandemie_p_vR_mid" or \
        current_testID == "tempo_all_vL" or \
        current_testID == "tempo_a_vL" or \
        current_testID == "tempo_a_vR" or \
        current_testID == "tempo_p_aL_big" or \
        current_testID == "tempo_p_aR_big" or \
        current_testID == "tempo_p_mixR" or \
        current_testID == "tempo_p_vL_big" or \
        current_testID == "tempo_p_vR_big":
            current_study = "Blue"

        ######## Yellow #
        if current_testID == "anfang_a_aL_mid" or \
        current_testID == "anfang_a_aR_mid" or \
        current_testID == "anfang_a_vL" or \
        current_testID == "euro_p_aL_mid" or \
        current_testID == "euro_p_mixL" or \
        current_testID == "euro_p_vR_mid" or \
        current_testID == "paar_w_aL" or \
        current_testID == "paar_w_mulR" or \
        current_testID == "pandemie_p_aL_mid" or \
        current_testID == "pandemie_p_aR_mid" or \
        current_testID == "pandemie_p_mixR" or \
        current_testID == "pandemie_p_vL_mid" or \
        current_testID == "tempo_a_aL" or \
        current_testID == "tempo_a_aR" or \
        current_testID == "tempo_all_a_right" or \
        current_testID == "tempo_all_p_left" or \
        current_testID == "tempo_all_p_right" or \
        current_testID == "tempo_p_aL_mid" or \
        current_testID == "tempo_p_aR_mid" or \
        current_testID == "tempo_p_mulL" or \
        current_testID == "tempo_p_vL_mid" or \
        current_testID == "tempo_w_mulL" or \
        current_testID == "tempo_w_vR":
            current_study = "Yellow"

        ######## Red #
        if current_testID == "anfang_a_aR_tin" or \
        current_testID == "anfang_a_mixL" or \
        current_testID == "anfang_a_mulL" or \
        current_testID == "euro_p_aR_mid" or \
        current_testID == "euro_p_mulL" or \
        current_testID == "euro_p_vL_tin" or \
        current_testID == "euro_p_vR_tin" or \
        current_testID == "paar_w_mixR" or \
        current_testID == "paar_w_mulL" or \
        current_testID == "pandemie_p_aR_tin" or \
        current_testID == "pandemie_p_mulL" or \
        current_testID == "pandemie_p_vR_big" or \
        current_testID == "tempo_all_a_left" or \
        current_testID == "tempo_all_w_right" or \
        current_testID == "tempo_a_mixR" or \
        current_testID == "tempo_a_mulR" or \
        current_testID == "tempo_p_aL_tin" or \
        current_testID == "tempo_p_mulR" or \
        current_testID == "tempo_p_vR_mid" or \
        current_testID == "tempo_w_aL" or \
        current_testID == "tempo_w_aR" or \
        current_testID == "tempo_w_mixL" or \
        current_testID == "tempo_w_mulR":
            current_study = "Red"

        ######## Purple #
        if current_testID == "anfang_a_aL_tin" or \
        current_testID == "anfang_a_mixR" or \
        current_testID == "anfang_a_mulR" or \
        current_testID == "euro_p_aL_tin" or \
        current_testID == "euro_p_aR_tin" or \
        current_testID == "euro_p_mulR" or \
        current_testID == "euro_p_vL_mid" or \
        current_testID == "paar_w_aR" or \
        current_testID == "paar_w_mixL" or \
        current_testID == "pandemie_p_aL_tin" or \
        current_testID == "pandemie_p_mulR" or \
        current_testID == "pandemie_p_vL_tin" or \
        current_testID == "pandemie_p_vR_tin" or \
        current_testID == "tempo_all_aR" or \
        current_testID == "tempo_all_w_left" or \
        current_testID == "tempo_a_mixL" or \
        current_testID == "tempo_a_mulL" or \
        current_testID == "tempo_p_aR_tin" or \
        current_testID == "tempo_p_mixL" or \
        current_testID == "tempo_p_vL_tin" or \
        current_testID == "tempo_p_vR_tin" or \
        current_testID == "tempo_w_mixR" or \
        current_testID == "tempo_w_vL":
            current_study = "Purple"

        ######## Orange #
        if current_testID == "anfang_p_aR_tin" or \
        current_testID == "anfang_p_mulL" or \
        current_testID == "anfang_p_vL_big" or \
        current_testID == "anfang_p_vR_big" or \
        current_testID == "euro_a_aR_big" or \
        current_testID == "euro_a_vL_big" or \
        current_testID == "impf_w_aL_mid" or \
        current_testID == "impf_w_mixR" or \
        current_testID == "paar_a_vL_big" or \
        current_testID == "paar_a_vR_mid" or \
        current_testID == "paar_p_aL_tin" or \
        current_testID == "paar_p_aR_big" or \
        current_testID == "paar_p_mulL" or \
        current_testID == "paar_p_vL_big" or \
        current_testID == "paar_w_aL_big" or \
        current_testID == "paar_w_vR_big" or \
        current_testID == "pandemie_a_aL_mid" or \
        current_testID == "pandemie_a_mulL" or \
        current_testID == "tempo_a_aR_mid" or \
        current_testID == "tempo_a_vR_big" or \
        current_testID == "tempo_w_aR_mid" or \
        current_testID == "tempo_w_vL_mid" or \
        current_testID == "zusammen_a_vL_big" or \
        current_testID == "zusammen_a_vR_mid":
            current_study = "Orange"

        ######## Teal #
        if current_testID == "anfang_a_vR_mid" or \
        current_testID == "anfang_p_aL_big" or \
        current_testID == "anfang_p_aL_tin" or \
        current_testID == "euro_a_vL_mid" or \
        current_testID == "euro_a_vR_big" or \
        current_testID == "impf_w_mulR" or \
        current_testID == "impf_w_vL_mid" or \
        current_testID == "paar_a_aR_mid" or \
        current_testID == "paar_a_mixL" or \
        current_testID == "paar_a_vR_big" or \
        current_testID == "paar_p_aL_big" or \
        current_testID == "paar_p_aR_tin" or \
        current_testID == "paar_p_mixL" or \
        current_testID == "paar_p_mulR" or \
        current_testID == "paar_p_vR_big" or \
        current_testID == "pandemie_a_aL_big" or \
        current_testID == "pandemie_a_mulR" or \
        current_testID == "pandemie_a_vR_big" or \
        current_testID == "tempo_a_aR_big" or \
        current_testID == "tempo_a_vL_big" or \
        current_testID == "tempo_w_aL_mid" or \
        current_testID == "zusammen_a_mixL" or \
        current_testID == "zusammen_a_vR_big":
            current_study = "Teal"

        ######## Grey #
        if current_testID == "anfang_a_vL_big" or \
        current_testID == "anfang_p_aR_mid" or \
        current_testID == "anfang_p_mixR" or \
        current_testID == "anfang_p_vL_mid" or \
        current_testID == "euro_a_aR_mid" or \
        current_testID == "euro_a_mulL" or \
        current_testID == "impf_w_aR_big" or \
        current_testID == "impf_w_vR_mid" or \
        current_testID == "paar_a_aR_big" or \
        current_testID == "paar_a_mulL" or \
        current_testID == "paar_a_vL_mid" or \
        current_testID == "paar_p_mixR" or \
        current_testID == "paar_w_aL_mid" or \
        current_testID == "paar_w_vR_mid" or \
        current_testID == "pandemie_a_mixR" or \
        current_testID == "pandemie_a_vR_mid" or \
        current_testID == "tempo_a_vL_mid" or \
        current_testID == "tempo_w_vL_big" or \
        current_testID == "tempo_w_vR_mid" or \
        current_testID == "zusammen_a_aL_big" or \
        current_testID == "zusammen_a_aR_mid" or \
        current_testID == "zusammen_a_mulR" or \
        current_testID == "zusammen_a_vL_mid":
            current_study = "Grey"

        ######## Mustard #
        if current_testID == "anfang_a_vR_big" or \
        current_testID == "anfang_p_aR_big" or \
        current_testID == "anfang_p_vR_mid" or \
        current_testID == "euro_a_aL_big" or \
        current_testID == "euro_a_mixL" or \
        current_testID == "euro_a_mulR" or \
        current_testID == "impf_w_aR_mid" or \
        current_testID == "impf_w_mulL" or \
        current_testID == "impf_w_vL_big" or \
        current_testID == "paar_a_aL_big" or \
        current_testID == "paar_a_mulR" or \
        current_testID == "paar_p_aL_mid" or \
        current_testID == "paar_p_vR_mid" or \
        current_testID == "paar_w_aR_mid" or \
        current_testID == "paar_w_vL_mid" or \
        current_testID == "pandemie_a_aR_mid" or \
        current_testID == "pandemie_a_mixL" or \
        current_testID == "pandemie_a_vL_big" or \
        current_testID == "tempo_a_aL_big" or \
        current_testID == "tempo_a_vR_mid" or \
        current_testID == "tempo_w_aR_big" or \
        current_testID == "zusammen_a_aL_mid" or \
        current_testID == "zusammen_a_mixR":
            current_study = "Mustard"

        ######## Olive #
        if current_testID == "anfang_a_vL_mid" or \
        current_testID == "anfang_p_aL_mid" or \
        current_testID == "anfang_p_mixL" or \
        current_testID == "anfang_p_mulR" or \
        current_testID == "euro_a_aL_mid" or \
        current_testID == "euro_a_mixR" or \
        current_testID == "euro_a_vR_mid" or \
        current_testID == "impf_w_aL_big" or \
        current_testID == "impf_w_mixL" or \
        current_testID == "impf_w_vR_big" or \
        current_testID == "paar_a_aL_mid" or \
        current_testID == "paar_a_mixR" or \
        current_testID == "paar_p_aR_mid" or \
        current_testID == "paar_p_vL_mid" or \
        current_testID == "paar_w_aR_big" or \
        current_testID == "paar_w_vL_big" or \
        current_testID == "pandemie_a_aR_big" or \
        current_testID == "pandemie_a_vL_mid" or \
        current_testID == "tempo_a_aL_mid" or \
        current_testID == "tempo_w_aL_big" or \
        current_testID == "tempo_w_vR_big" or \
        current_testID == "zusammen_a_aR_big" or \
        current_testID == "zusammen_a_mulL":
            current_study = "Olive"


        #################################################################
        # Processing the 6 different ratings/items of the current trial #
        #################################################################
        for key, value in view_on_grading:
            item_grading = value
            item_filename = current_filenames[key]
            item_attribute = current_filenames[key].split("_")[-2][-1:]
            # => "video/multiMod_2021-01-09_Anfang_a_002_shiftRight[#[4]#]_0.90cut.mp4" = "4"
            current_object = item_filename.split("_")[3]
            item_modification_name = (current_filenames[key].split("/")[1].split("_")[0] + "_" + current_filenames[key].split("/")[1].split("_")[5])[:-1]
            item_modification_operation = item_modification_name.split("_")[0]
            item_modification_direction = item_modification_name.split("_")[1]
            item_modification = ""
            if item_attribute == "0" and \
            current_trial_modification != "a" and \
            current_trial_modification != "p" and \
            current_trial_modification != "w":
             # First check for adjusting reference-data
             # The other 3 checks for handling the special-case of the "all" excerpts
                item_modification = current_trial_modification
            else:
                if item_modification_operation == "audioMod":
                    item_modification = "a"
                    #if current_trial_modification == "aL": # For adjusting reference-data
                    #    item_modification = "aL"
                    #elif current_trial_modification == "aR":
                    #    item_modification = "aR" # How to handle the other direction considering the next if-case adding another "R"????
                    #elif current_trial_modification ==
                elif item_modification_operation == "visualMod":
                    item_modification = "v"
                elif item_modification_operation == "mixMod":
                    item_modification = "i"
                elif item_modification_operation == "multiMod":
                    item_modification = "u"
                if item_modification_direction == "shiftLeft":
                    item_modification = item_modification + "L"
                elif item_modification_direction == "shiftRight":
                    item_modification = item_modification + "R"
                # => "video/[#[multiMod]#]_2021-01-09_Anfang_a_002_[#[shiftRight]#]4_0.90cut.mp4" = "multiMod_shiftRight"

            # Increase "unique" ID (as name for this "observation" (row) inside the R-dataframe)
            global ResultIDCounter
            ResultIDCounter += 1
            userDict = dict([
                ("ResultID", ResultIDCounter),
                ("Excerpt", current_excerpt),
                ("TestID", current_testID),
                ("Item", current_testID+"_"+current_object+"_"+item_modification+"_"+item_attribute),
                ("Modification", item_modification),
                ("ModificationName", item_modification_name),
                ("Attribute", item_attribute),
                ("Grade", item_grading),
                ("File", item_filename),
                ("Runtime", trialResult["Runtime"]),
                ("SubjectName", current_username),
                ("SubjectAge", userMeta["UserAge"]),
                ("SubjectSex", userMeta["UserSex"]),
                ("SubjectInterest", userMeta["UserInterest"]),
                ("SubjectLanguage", current_userlanguage),
                ("SubjectEyesight", current_usereyesight),
                ("SubjectHearing", current_userhearing),
                ("SubjectComment", current_comment),
                ("SubjectEMail", current_mail),
                ("SessionID", userMeta["SessionID"]),
                ("SeqNum", userMeta["SeqNum"]),
                ("Study", current_study),
                ("Object", current_object)
            ])
            userDictArray.append(userDict)
    return userDictArray


userDictArrays = []

print("Transform trial-results into arrays of dictionaries.")
for pairOfUserData in userMetasAndUserDatas:
    # pairOfUserData = [SessionID, [ [userMeta], [userData] ] ]
    currentUserDictArray = txtToDictTransformer(pairOfUserData[1][0], pairOfUserData[1][1])
    userDictArrays.append(currentUserDictArray)
# => userDictArrays = [[[user01Dict01], [user01Dict02], ...], [[user02Dict01], ...], ...]



#########################################################################################
# The input result.txt-files are already in dictionary-format, but need some adjustment #
#########################################################################################
# Input looks like this:
# [ {
#       "TestID":"tempo_all_aL",
#       "Runtime":318,
#       "rating":
#       {
#           "1":5,
#           "2":63,
#           "3":99,
#           "4":78,
#           "5":25,
#           "Reference":100
#       },
#       "filename":
#       {
#           "1":"video/audioMod_2021-01-09_Tempo_p_001_shiftLeft0_90cut.mp4",
#           "2":"video/audioMod_2021-01-09_Tempo_p_001_shiftLeft4_90cut.mp4",
#           "3":"video/audioMod_2021-01-09_Tempo_w_001_shiftLeft4_90cut.mp4",
#           "4":"video/mixMod_2021-01-09_Tempo_p_001_shiftLeft4_0.90cut.mp4",
#           "5":"video/multiMod_2021-01-09_Tempo_p_001_shiftRight4_0.90cut.mp4",
#           "Reference":"video/audioMod_2021-01-09_Tempo_a_001_shiftLeft4_0.90cut.mp4"
#       }
#   },
#   {"TestID":"temp...",... ,"rating": {"1":62, ... }, "filename": {"1":"video..."} },
#   null,
#   null,
#   {"TestID":"anfa...",... ,"rating": {"1":29, ... }, "filename": {"1":"video..."} }
#   null,
#   {
#       "UserName":"",
#       "SingleComments":[],
#       "UserAge":"none",
#       "UserInterest":"none",
#       "UserLanguage":"",
#       "UserEyesight":"",
#       "SessionID":"af11e47d-a1b4-4451-522e-75558bef96ba",
#       "SeqNum":8
#   }
# ]


#############################################################################
# variableColumnNames of the output.csv that are of interest at this point: #
#############################################################################
# "Excerpt",                # Name of excerpt (used video-clip in this trial) => "Tempo" or "Anfang"
# "TestID",                 # Identifier for applied modifications => "base_tempo_p_aL_big" or "base_paar_w_aL"
# "Item",                   # TBD
# "AttributeLow",           # Low-Anchor impulse => "MixLeft4"
# "AttributeMid",           # Mid-Anchor impulse => "MulRight4"
# "Attribute0",             # High-Anchor impulse (Hidden-Reference) => 0
# "Attribute1",             # Strength of impulse => 1
# "Attribute2",             # Strength of impulse => 2
# "Attribute3",             # Strength of impulse => 3
# "Attribute4",             # Strength of impulse => 4
# "Attribute5",             # Strength of impulse => 5
# "Attribute6",             # Strength of impulse => 6
# "GradeLow",               # Grading for Low-Anchor => 0 or 15
# "GradeMid",               # Grading for Mid-Anchor => 40 or 65
# "Grade0",                 # Grading for High-Anchor => 95 or 100
# "Grade1",                 # Grading 1
# "Grade2",                 # Grading 2
# "Grade3",                 # Grading 3
# "Grade4",                 # Grading 4
# "Grade5",                 # Grading 5
# "Grade6",                 # Grading 6
# "FileLow",                # Filename of Low-Anchor
# "FileMid",                # Filename of Mid-Anchor
# "File0",                  # Filename of High-Anchor
# "File1",                  # Filename 1
# "File2",                  # Filename 2
# "File3",                  # Filename 3
# "File4",                  # Filename 4
# "File5",                  # Filename 5
# "File6",                  # Filename 6
# "Runtime",                # Runtime of this trial => 37458
# "Study",                  # Part of study => "blue" or "yellow" or "red" or "purple"
# "SubjectName",            # Name or pseudonym => "All bets are off- anything can happen here..."
# "SubjectSingleComments",  # ?? => ??
# "SubjectAge",             # Age-group => "none" or "20-29 Jahre"
# "SubjectSex",             # Not 'that' kind! => "male" or "female" or "apache helicopter"
# "SubjectInterest",        # Also field of study => "arts"
# "SubjectLanguage",        # Native language => "English" or "Maya"
# "SubjectEyesight",        # Eyesight impairments => "I am a pirate with just one eye."
# "SessionID",              # ?? => "af11e47d-a1b4-4451-522e-75558bef96ba"
# "SeqNum",                 # ?? => 8
# "SubjectComment",         # ?? => ??
# "Objects", "ObjectLengths" and "ObjectTypes" are coupled to the excerpt and can/will be added in the final steps of preprocessing.


###################################
# Write dictionaries to .csv-file #
###################################
# class csv.DictWriter() # => # https://docs.python.org/3/library/csv.html
import csv
def dictToCsvWriter(userDictArrays):
    with open(outputCsv, 'w', newline='') as csvfile:
        variableColumnNames = [
        "ResultID",
        "Excerpt",
        "TestID",
        "Item",
        "Attribute",
        "Grade",
        "Modification",
        "ModificationName",
        "Study",
        "Runtime",
        "SubjectName",
        "SubjectAge",
        "SubjectSex",
        "SubjectInterest",
        "SubjectLanguage",
        "SubjectEyesight",
        "SubjectHearing",
        "SubjectComment",
        "SubjectEMail",
        "SessionID",
        "SeqNum",
        "Object",
        "File"
        ]

        writer = csv.DictWriter(csvfile, fieldnames=variableColumnNames)

        writer.writeheader()
        for userDictArray in userDictArrays:
            for row in userDictArray:
                writer.writerow(row)

print("Write arrays of dictionaries into output-csv-file in: " + str(pathOutputCsv))
dictToCsvWriter(userDictArrays)

print("Number of rows (ResultIDCounter): " + str(ResultIDCounter))
