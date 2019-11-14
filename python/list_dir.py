import string, sys, os, getopt
from os.path import *

def dir_size (start, my_depth, max_depth):
        total = 0
        try:
                dir_list = os.listdir (start)
        except:
                if isdir (start):
                      print( "99;\"" + start + "\";0" )
                return 0
        for item in dir_list:
                path = '%s/%s' % (start, item)
                try:
                        stats = os.stat (path)
                except:
                        print( "99;\"" + path + "\";0" )
                        continue
                if not isdir (path):
                        total += stats[6]
                if isdir (path):
                        bytes = dir_size (path, my_depth + 1, max_depth)
                        total += bytes
                        if (my_depth < max_depth):
                             print( str(my_depth+1) + ";\"" + path + "\";" + str(bytes) )
        return total

# list only top level sums WHILE searching on full depth
depth = 3

for path in sys.argv[1:]:
    bytes = dir_size (path, 0, depth)
    print( "0;\"" + path + "\";" + str(bytes) )
