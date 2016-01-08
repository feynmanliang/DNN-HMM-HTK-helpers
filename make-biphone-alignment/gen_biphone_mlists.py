import os
import sys

boundary = {'sil': 0}
phoneme = []

inLST = sys.argv[1]
outLST = sys.argv[2]

file = open(inLST)
lines = file.readlines()
file.close()

for eachline in lines:
	curphone = eachline.replace(os.linesep, '')
	if phoneme.count(curphone) == 0:
		phoneme.append(curphone)
phoneme.sort()

biphones = []
for eachcp in phoneme:
    if eachcp not in boundary:
        for eachlp in phoneme:
                biphones.append(eachcp + '+' + eachlp)

# add the boundaries
for eachbp in boundary.items():
    biphones.append(eachbp[0])

file = open(outLST, 'w')
for eachtp in biphones:
	file.write(eachtp + os.linesep)
file.close()

