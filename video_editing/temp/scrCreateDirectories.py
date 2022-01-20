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

# Input like: ("material/merkel", "vowels", ["a", "e", "o", ...])
def createDirectories(starting_directory, sub_directory, 
leaf_directories=["a","o","u","aI"]):
#leaf_directories=["a","e","i","o","u","y","aI","aU"]):
	real_starting_dir = path + "/../" + starting_directory
	starting_dirs = os.listdir(real_starting_dir) # Get the directory for each file	
	for starting_dir in starting_dirs:
		#sub_dir = path + "/" + starting_dir + "/" + sub_directory
		sub_dir = real_starting_dir + "/" + starting_dir + "/" + sub_directory # sub_dir = .../merkel/2007-01-13/vowels
		createDir(sub_dir)
		for leaf in leaf_directories:
			createDir(sub_dir + "/" + leaf)
			createDir(sub_dir + "/" + leaf + "/" + "dissected")

# Using sys.argv to receive the input arguments            
# sys.argv[0] = scriptname.py
start = sys.argv[1]
middle = sys.argv[2]
#input_leaves = sys.argv[3] # for specific input
#leaves_map = map(str, input_leaves.strip('[]').split(','))
#leaves = list(leaves_map)

leaves = ["a","e","i","o","u","y","aI","aU"]

createDirectories(start, middle, leaves) 
