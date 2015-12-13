import os
import sys

inLIST = sys.argv[1]
outDICT = sys.argv[2]

file = open(inLIST)
inlines = file.readlines()
file.close()

outlines = []
null_words = ['!ENTER', '!EXIT']
for eachline in inlines:
  curphone = eachline.replace(os.linesep, '')
  if curphone in null_words:
    curline = curphone
    outlines.append(curline + '\t' + '[]' + '\t' + 'sil')
  else:
    curline = curphone + '\t\t' + curphone
    outlines.append(curline)

file = open(outDICT, 'w')
for eachline in outlines:
	file.write(eachline + os.linesep)
file.close()

