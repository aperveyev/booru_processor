import glob
import os
from pathlib import Path

files = sorted(glob.glob('*.txt'))

for ff in files:
  with open(ff, 'r') as t:
   for line in t:
     print(ff+'\t'+line.strip())
   t.close()   
