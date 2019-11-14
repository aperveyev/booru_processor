import string, sys, os, getopt
from os.path import *

def dir_size (start, my_depth, max_depth):
        total = 0
        fcnt = 0
        try:
                dir_list = os.listdir (start)
        except:
                if isdir (start):
                      print( "99;\"" + start + "\";0;0" )
                return 0
        for item in dir_list:
                path = '%s/%s' % (start, item)
                try:
                        stats = os.stat (path)
                except:
                        print( "99;\"" + path + "\";0;0" )
                        continue
                if not isdir (path):
                        total += stats[6]
                        fcnt += 1
                if isdir (path):
                        bytes, fls = dir_size (path, my_depth + 1, max_depth)
                        total += bytes
                        fcnt += fls
                        if (my_depth < max_depth):
                             print( str(my_depth+1) + ";\"" + path + "\";" + str(bytes) + ";" + str(fcnt) )
        return (total,fcnt)

# list only top level sums WHILE searching on full depth
depth = 3

for path in sys.argv[1:]:
    bytes, fls = dir_size (path, 0, depth)
    print( "0;\"" + path + "\";" + str(bytes) + ";" + str(fls) )
