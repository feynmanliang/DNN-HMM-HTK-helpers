import os
import sys

inLST = sys.argv[1]
outHED = sys.argv[2]

file = open(inLST)
lines = file.readlines()
file.close()

phonelist = []
for eachline in lines:
	curphone = eachline.replace(os.linesep, '')
	phonelist.append(curphone)

outlines = ['RC']
REcmd = 'RE sil'
for phone in phonelist:
    curbisil = 'sil+' + phone
    outlines.append(REcmd + ' ' + curbisil)


file = open(outHED, 'w')
for eachline in outlines:
	file.write(eachline + os.linesep)
file.close()

