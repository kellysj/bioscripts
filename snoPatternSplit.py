"""
snoPatternSplit
HBoxes:
	ANANNA - flanked by 2 large hairpin formations
"""
import sys
import re

seqre = re.compile(r'^[UuNnATGCatgc]+')
hboxre = re.compile(r'(^[UuNnATGCatgc]*)([Aa][UuNnATGCatgc][Aa][UuNnATGCatgc][UuNnATGCatgc][Aa]){3}([UuNnATGCatgc]*)')
headerre = re.compile(r'>(.*)')

nseq = 0
nmatch = 0
nheader = 0
nlines = 0
totallength = 0
nshort = 0
shortTH = 50
for line in open(sys.argv[1]):
	nlines += 1
	header = re.search(headerre, str(line))
	seq = re.search(seqre, str(line))
	if header:
		#print header.group(0)
		nheader += 1
	if seq:
		totallength = totallength + len(seq.group(0))
		nseq += 1
		if (len(seq.group(0))<shortTH):
			nshort += 1		
		#print seq.group(0)
		hbox = re.search(hboxre, seq.group(0))		
		if hbox:			
			nmatch += 1
			#print hbox.group(1)
			#print hbox.group(2)
			#print hbox.group(3)
			#print "\n"
		
print "total lines:", nlines
print "total seqs: ", nseq
print "total headers: ", nheader
print "total matches: ", nmatch

percmatchL = 100*(float(nmatch)/float(totallength))
permatchS = 100*(float(nmatch)/float(nseq))
lenavg = float(totallength)/float(nseq)
print "total length: ", totallength
print "average length: ", lenavg
print "% matching of length: ", percmatchL
print "% matching sequences: ", permatchS
print "number short seqs: ", nshort