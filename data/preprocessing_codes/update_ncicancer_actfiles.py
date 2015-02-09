
"""
"""


#!/usr/bin/env python

import re, urllib, os

#basefolder = "/cs/taatto/group/urenzyme/workspace/molecular_classification/data/"
basefolder = "../"
tmpfolder = basefolder + "/DTPNCI2015/tmpfolder/"
zipfilesfolder = tmpfolder + "0000001_0001000/"
bioassfilesfolder = tmpfolder + "bioassfiles/"

def get_aid_list():
	aidlist = []
	print "Obtaining AID list ..."
	ifname = basefolder + "/DTPNCI2015/otherfiles/pcassay"
	fin = open(ifname)
        append_flag = 0
	for line in fin:
                if len(line.strip())==0 or line.startswith('Source'):
                        continue
		if not len(re.findall("^AID: ", line.strip())) == 0 and append_flag == 1:
                        aid = re.sub('^AID: ','',line.strip())
			aidlist.append(aid)
                        append_flag = 0
                if not len(re.findall("NCI human tumor cell", line.strip())) == 0:
                        append_flag = 1
	fin.close()
	return aidlist
	
def download_actfiles():
	"""
		download zipfiles
		unpack zipfiles -> a group of files
	"""
	print "Downloading ziped files ..."
	url = "ftp://ftp.ncbi.nlm.nih.gov/pubchem/Bioassay/CSV/Data/0000001_0001000.zip"
	if os.path.isdir(tmpfolder):
		os.system("rm -rf %s" % tmpfolder)
	os.system("mkdir %s" % tmpfolder)
	urllib.urlretrieve(url, tmpfolder + "0000001_0001000.zip")
	print "Unzipping ..."
	if os.path.isdir(zipfilesfolder):
		os.system("rm -rf %s" % (zipfilesfolder))
	os.system("cd %s; unzip %s; cd .." % (tmpfolder, "0000001_0001000.zip"))


def select():
	"""
		select human tumore cell line csv.gz file
		unzip
		to bioassfiles/
	"""
	aidlist = get_aid_list()
	print "Selecting ..."
	if os.path.isdir(bioassfilesfolder):
		os.system("rm -rf %s" % bioassfilesfolder)
	os.system("mkdir %s" % bioassfilesfolder)
	for aid in aidlist:
		print("\tunziping AID %s" % aid)
		srcfile = zipfilesfolder + aid + '.csv.gz'
		os.system("cp %s tmp; gunzip %s; cp tmp %s" % (srcfile, srcfile, srcfile))
	os.system("rm tmp")
	os.system("mv %s*.csv %s" % (zipfilesfolder, bioassfilesfolder))


def summarize():
	"""
		aid -> NSC_id -> score -> outcome
	"""
	cpdact = {}
	print "Summarizing ..."
	aidlist = get_aid_list()
	for aid in aidlist:
		print("\tsummarizing AID %s" % aid)
		ifname = bioassfilesfolder + aid + '.csv'
		fin = open(ifname)
                firstline = 1
		for line in fin:
                        if firstline == 1:
                                firstline = 0
                                continue
			score = line.strip().split(',')[3]
			nsc = int(re.sub(".*searchlist=|&systemname.*", '', line.strip().split(',')[4]))
			if not nsc in cpdact.keys():
				cpdact[nsc] = {}
			cpdact[nsc][int(aid)] = score
		fin.close()
	
	print "Writing file ..."
	fout = open(basefolder + '/DTPNCI2015/activity_complete', "w")
	cpdlist = cpdact.keys()
	cpdlist.sort()
	fout.write("0")
	for aid in aidlist:
		fout.write(" %s" % aid)
	fout.write("\n")
	for cpd in cpdlist:
		fout.write("%d" % cpd)
		for aid in aidlist:
			if int(aid) in cpdact[cpd].keys() and not cpdact[cpd][int(aid)] == "":
				fout.write(" %s" % cpdact[cpd][int(aid)])
			else:
				fout.write(" NA")
		fout.write("\n")
	fout.close()
			

def clean():
	"""
	"""
	os.system("rm -rf %s" % tmpfolder)	
		
	
	
		


if __name__ == "__main__":
	download_actfiles()
	select()
	summarize()
	clean()



