import sys
import os

# Detect the current working directory and print it
path = os.getcwd()
print ("The current working directory is %s" % path)

# Creation of a single directory
def createDir(dir_path):
	# Define the access rights. 
	# The default setting is 777, which means it is readable and writable by the owner, 
	# group members, and all other users as well. 
	access_rights = 0o755
	try:
		os.mkdir(dir_path, access_rights)
	except OSError:
		print ("Creation of the directory %s failed" % dir_path)
	else:
		print ("Successfully created the directory %s" % dir_path)

# Input like: ("merkel", "vowel", ["a", "e", "o", ...])
def createDirectories(starting_directory, sub_directories):
	real_starting_dir = path + "/" + starting_directory
	starting_dirs = os.listdir(real_starting_dir) # Get the directory for each file	
	for starting_dir in starting_dirs:
		for sub_directory in sub_directories:
			sub_dir = real_starting_dir + "/" + starting_dir + "/" + sub_directory 
			createDir(sub_dir)

# Using sys.argv to receive the input arguments            
# sys.argv[0] = scriptname.py
start = sys.argv[1]
#middle = sys.argv[2]
#input_leaves = sys.argv[3] # for specific input
#leaves_map = map(str, input_leaves.strip('[]').split(','))
#leaves = list(leaves_map)

middle = ["mausG2P", "mausGeneral"]

createDirectories(start, middle) 
