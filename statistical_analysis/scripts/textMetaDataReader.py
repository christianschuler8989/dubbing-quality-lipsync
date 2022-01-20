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
# Define path to input-txt-files
pathInputTextfiles = "./../data/meta_text/"

from os import listdir
from os.path import isfile, join

######## Read file-paths #######################################################
# Only take names of files not of directories
pathInputTextfilesArray = [pathInputTextfiles+f for f in listdir(pathInputTextfiles) if isfile(join(pathInputTextfiles, f))]

# Define path to output-csv-files
pathOutputCsv = "./../data/meta/"
outputCsv = pathOutputCsv + "data_meta_text.csv"

# Ugly globally used variable to generate unique identifier for rows (observations)
ResultIDCounter = 0


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

print("Read input-textfiles containing trial-results.")
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
    #print("userData")
    #print(userData)
    #print("userMeta")
    #print(userMeta)
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
        #current_item = current_testID.split("_")[1]
        boolean_mixedTrialOfAll = False

        # Then the values corresponding to the current item (trial-object-attribute) are filled in

        # This happens by iterating through the items of the dictionary "rating"
        current_filenames = trialResult["filename"]
        current_gradings = trialResult["rating"]
        view_on_grading = current_gradings.items()
        # => view_on_rating = ([("1", 99), ("2", 15), ("3", 77), ...])


        for key, value in view_on_grading:
            item_key = key
            item_grading = value
            item_filename = current_filenames[key]
            current_item = item_filename.split("_")[3]
            item_modification_name = (current_filenames[key].split("/")[1].split("_")[0] + "_" + current_filenames[key].split("/")[1].split("_")[5])[:-1]
            item_modification_operation = item_modification_name.split("_")[0]
            item_modification_direction = item_modification_name.split("_")[1]
            item_modification = ""
            if item_modification_operation == "audioMod":
                item_modification = "a"
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
            item_attribute = current_filenames[key].split("_")[-2][-1:]
            # => "video/multiMod_2021-01-09_Anfang_a_002_shiftRight[#[4]#]_0.90cut.mp4" = "4"

            # Metadata of current object (which is the modified part of this trials item item):

            # Initialize with empty values for python not to lose it's shit (global variables are evil!?)
            objLeft3 = ""
            objLeft2 = ""
            objLeft1 = ""
            object = ""
            objRight1 = ""
            objRight2 = ""
            objRight3 = ""
            objLeft3L = 0.00
            objLeft2L = 0.00
            objLeft1L = 0.00
            objectL = 0.00
            objRight1L = 0.00
            objRight2L = 0.00
            objRight3L = 0.00
            objLeft3T = ""
            objLeft2T = ""
            objLeft1T = ""
            objectT = ""
            objRight1T = ""
            objRight2T = ""
            objRight3T = ""

            # Fill in correspondance to the current excerpt
            if current_excerpt == "Anfang":
                objLeft3 = "C"
                objLeft2 = "a"
                objLeft1 = "m"
                object = "a"
                objRight1 = "n"
                objRight2 = "f"
                objRight3 = "a"
                objLeft3L = 0.04
                objLeft2L = 0.1
                objLeft1L = 0.09
                objectL = 0.12
                objRight1L = 0.06
                objRight2L = 0.09
                objRight3L = 0.11
                objLeft3T = "Palatal Fricative Consonant"
                objLeft2T = "Open Vowel"
                objLeft1T = "Bilabial Nasal Consonant"
                objectT = "Open Vowel"
                objRight1T = "Alveolar Nasal Consonant"
                objRight2T = "Labiodental Fricative Consonant"
                objRight3T = "Open Vowel"

            elif current_excerpt == "Europaeisch":
                objLeft3 = "OY"
                objLeft2 = "r"
                objLeft1 = "o"
                object = "p"
                objRight1 = "E:"
                objRight2 = "I"
                objRight3 = "S"
                objLeft3L = 0.06
                objLeft2L = 0.03
                objLeft1L = 0.1
                objectL = 0.1
                objRight1L = 0.15
                objRight2L = 0.03
                objRight3L = 0.05
                objLeft3T = "Open Mid Vowel"
                objLeft2T = "?? Trill Consonant"
                objLeft1T = "Close Mid Vowel"
                objectT = "Bilabial Consonant"
                objRight1T = "Open Mid Vowel"
                objRight2T = "Close Close Mid Vowel"
                objRight3T = "Postalveolar Fricative Consonant"

            elif current_excerpt == "Paar":
                objLeft3 = "a"
                objLeft2 = "r"
                objLeft1 = "t"
                object = "w"
                objRight1 = "?"
                objRight2 = "aI"
                objRight3 = "n"
                objLeft3L = 0.19
                objLeft2L = 0.06
                objLeft1L = 0.03
                objectL = 0.29
                objRight1L = 0.05
                objRight2L = 0.06
                objRight3L = 0.08
                objLeft3T = "Open Vowel"
                objLeft2T = "Uvular Liquid Consonant"
                objLeft1T = "?? Plosive Consonant"
                objectT = "Pause"
                objRight1T = "Glottal Plosive Consonant"
                objRight2T = "Open Vowel"
                objRight3T = "Alveolar Nasal Consonant"

            elif current_excerpt == "Pandemie":
                objLeft3 = "d"
                objLeft2 = "e:"
                objLeft1 = "6"
                object = "p"
                objRight1 = "a"
                objRight2 = "n"
                objRight3 = "d"
                objLeft3L = 0.03
                objLeft2L = 0.05
                objLeft1L = 0.1
                objectL = 0.04
                objRight1L = 0.06
                objRight2L = 0.08
                objRight3L = 0.03
                objLeft3T = "?? Plosive Consonant"
                objLeft2T = "Close Mid Vowel"
                objLeft1T = "Open Open Mid Vowel"
                objectT = "Bilabial Consonant"
                objRight1T = "Open Vowel"
                objRight2T = "Alveolar Nasal Consonant"
                objRight3T = "?? Plosive Consonant"

            elif current_excerpt == "Tempo":
                if current_item == "a":
                    objLeft3 = "6"
                    objLeft2 = "w"
                    objLeft1 = "d"
                    object = "a"
                    objRight1 = "s"
                    objRight2 = "t"
                    objRight3 = "E"
                    objLeft3L = 0.05
                    objLeft2L = 0.77
                    objLeft1L = 0.06
                    objectL = 0.08
                    objRight1L = 0.09
                    objRight2L = 0.06
                    objRight3L = 0.08
                    objLeft3T = "Open Open Mid Vowel"
                    objLeft2T = "Pause"
                    objLeft1T = "?? Plosive Consonant"
                    objectT = "Open Vowel"
                    objRight1T = "Alveolar Fricative Consonant"
                    objRight2T = "?? Plosive Consonant"
                    objRight3T = "Open Mid Vowel"
                elif current_item == "p":
                    objLeft3 = "t"
                    objLeft2 = "E"
                    objLeft1 = "m"
                    object = "p"
                    objRight1 = "o"
                    objRight2 = "v"
                    objRight3 = "I"
                    objLeft3L = 0.06
                    objLeft2L = 0.08
                    objLeft1L = 0.14
                    objectL = 0.03
                    objRight1L = 0.2
                    objRight2L = 0.03
                    objRight3L = 0.01
                    objLeft3T = "?? Plosive Consonant"
                    objLeft2T = "Open Mid Vowel"
                    objLeft1T = "Bilabial Nasal Consonant"
                    objectT = "Bilabial Consonant"
                    objRight1T = "Close Mid Vowel"
                    objRight2T = "Labiodental Fricative Consonant"
                    objRight3T = "Close Close Mid Vowel"
                elif current_item == "w":
                    objLeft3 = "m"
                    objLeft2 = "e:"
                    objLeft1 = "6"
                    object = "w"
                    objRight1 = "d"
                    objRight2 = "a"
                    objRight3 = "s"
                    objLeft3L = 0.08
                    objLeft2L = 0.14
                    objLeft1L = 0.05
                    objectL = 0.77
                    objRight1L = 0.06
                    objRight2L = 0.08
                    objRight3L = 0.09
                    objLeft3T = "Bilabial Nasal Consonant"
                    objLeft2T = "Close Mid Vowel"
                    objLeft1T = "Open Open Mid Vowel"
                    objectT = "Pause"
                    objRight1T = "?? Plosive Consonant"
                    objRight2T = "Open Vowel"
                    objRight3T = "Alveolar Fricative Consonant"
                else:
                    print("Unknown current_item!")

            # Increase "unique" ID (as name for this "observation" (row) inside the R-dataframe)
            global ResultIDCounter
            ResultIDCounter += 1
            userDict = dict([
                ("ResultID", ResultIDCounter),
                ("Excerpt", current_excerpt),
                ("TestID", current_testID),
                ("Item", current_testID+"_"+current_item+"_"+item_attribute),
                ("Modification", item_modification),
                ("ModificationName", item_modification_name),
                ("Attribute", item_attribute),
                ("Grade", item_grading),
                ("File", item_filename),
                ("Runtime", trialResult["Runtime"]),
                ("SubjectName", userMeta["UserName"]),
                ("SubjectAge", userMeta["UserAge"]),
                ("SubjectSex", userMeta["UserSex"]),
                ("SubjectInterest", userMeta["UserInterest"]),
                #("SubjectLanguage", userMeta["UserLanguage"]),
                ("SubjectLanguage", "germanTEMP"),
                ("SessionID", userMeta["SessionID"]),
                ("SeqNum", userMeta["SeqNum"]),
                ("Study", "blue"),
                ("ObjLeft3", objLeft3),
                ("ObjLeft2", objLeft2),
                ("ObjLeft1", objLeft1),
                ("Object", object),
                ("ObjRight1", objRight1),
                ("ObjRight2", objRight2),
                ("ObjRight3", objRight3),
                ("ObjLeftLength3", objLeft3L),
                ("ObjLeftLength2", objLeft2L),
                ("ObjLeftLength1", objLeft1L),
                ("ObjectLength", objectL),
                ("ObjRightLength1", objRight1L),
                ("ObjRightLength2", objRight2L),
                ("ObjRightLength3", objRight3L),
                ("ObjLeftType3", objLeft3T),
                ("ObjLeftType2", objLeft2T),
                ("ObjLeftType1", objLeft1T),
                ("ObjectTye", objectT),
                ("ObjRightType1", objRight1T),
                ("ObjRightType2", objRight2T),
                ("ObjRightType3", objRight3T)
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
# "SubjectEyesight",        # Exesight impairments => "I am a pirate with just one eye."
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
        "SessionID",
        "SeqNum",
        "ObjLeft3",
        "ObjLeft2",
        "ObjLeft1",
        "Object",
        "ObjRight1",
        "ObjRight2",
        "ObjRight3",
        "ObjLeftLength3",
        "ObjLeftLength2",
        "ObjLeftLength1",
        "ObjectLength",
        "ObjRightLength1",
        "ObjRightLength2",
        "ObjRightLength3",
        "ObjLeftType3",
        "ObjLeftType2",
        "ObjLeftType1",
        "ObjectTye",
        "ObjRightType1",
        "ObjRightType2",
        "ObjRightType3",
        "File"
        ]

        writer = csv.DictWriter(csvfile, fieldnames=variableColumnNames)

        writer.writeheader()
        for userDictArray in userDictArrays:
            for row in userDictArray:
                writer.writerow(row)

print("Write arrays of dictionaries into output-csv-file.")
dictToCsvWriter(userDictArrays)

print("Number of rows (ResultIDCounter): " + str(ResultIDCounter))
