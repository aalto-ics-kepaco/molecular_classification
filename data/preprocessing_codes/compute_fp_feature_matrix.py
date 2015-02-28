

#!/usr/bin/env python


import os, re, sys, time, commands




# parse figure print
# input fpt file
# otuput binary figure print
def parse_figureprint(fname):
	mark = 0
	fin = open(fname)
	fpt = ''
	# read in figure print
	for line in fin:
		if line.startswith('>'):
			continue
		fpt = fpt + re.sub(' ', '', line.strip())
	fin.close()
	# binarize the figure print
	return('%s' % bin(int(fpt, 16))[2:])


def get_babel_features(srcfolder, labelfile, featurefile):
	print "Read in mol file names ..."
	mollist = []
	fin = open(labelfile)
	for line in fin:
		mollist.append(line.strip()+'.fp3')
	fin.close()
        #
	print "Parse results and write to one file ..."
	fout = open(featurefile, 'w')
	for mol in mollist:
		fptname = srcfolder + mol
		feature = parse_figureprint(fptname)
		fout.write("%s\n" % feature)
	fout.close()


if __name__ == '__main__':
	srcfolder = "../structures/FPfiles/" #sys.argv[1]
	labelfile = "../DTPNCI2015/results/ncicancer_labels" #sys.argv[2]
	featurefile = "../DTPNCI2015/results/ncicancer_features_fp3" #sys.argv[3]
	kernelfile = "../DTPNCI2015/results/ncicancer_kernel_fp3" #sys.argv[3]
	#get_babel_features(srcfolder, labelfile, featurefile)
        os.system("perl compute_tanimoto_kernel.pl %s %s" % (featurefile,kernelfile))
	
	
	
