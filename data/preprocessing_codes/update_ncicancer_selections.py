
#!/usr/bin/env python



import os, re

#basefolder = "/cs/taatto/group/urenzyme/workspace/molecular_classification/data/"
basefolder = '../'
molfilesfolder = basefolder + "molfiles/"
smifilesfolder = basefolder + "smifiles/"
actfilesfolder = basefolder + "/DTPNCI2015/"


def check_molfiles():
	print "Checking mol files ..."
	ifname = basefolder + "/DTPNCI2015/activity_complete"
	molofname = basefolder + "/DTPNCI2015/activity_complete_structurefilter"
	mfname = basefolder + "/structures/sdffile_list"
	# get mols
        molcpdlist = {}
	fin = open(mfname)
	for line in fin:
		if len(re.findall('.*\.sdf', line.strip())) > 0:
			molcpdlist[re.sub(".* |\.sdf", '', line.strip())] = 0
	fin.close()
	print("\tstructure mol -> %s" % len(molcpdlist.keys()))
	fout_mol = open(molofname ,"w")
	nmol = 0
	fin = open(ifname)
	for line in fin:
		if line.startswith("0 "):
			fout_mol.write(line)
			continue
		cpd = line.strip().split(' ')[0]
		if cpd in molcpdlist:
			fout_mol.write(line)
			nmol += 1
	fin.close()
	fout_mol.close()
	print("\tinclude mol -> %s" % nmol)	

	
def get_input_files(suffix):
	desactfile = actfilesfolder + "activity" + suffix
	destarfile = actfilesfolder + "target" + suffix
	
	os.system("head -1 %s |sed 's/0 //' > %s" % (desactfile, actfilesfolder + 'results/ncicancer_aids'))
	os.system("less %s | sed -e'/^0 /d' -e's/ .*//' > %s" % (destarfile, actfilesfolder + 'results/ncicancer_labels'))
	os.system("less %s | sed -e'/^0 /d' -e's/\([0-9]\)* //' > %s" % (destarfile, actfilesfolder + 'results/ncicancer_targets'))
	os.system("less %s | sed -e'/^0 /d' -e's/\([0-9]\)* //' > %s" % (desactfile, actfilesfolder + 'results/ncicancer_activities'))
	
	

def check_selections():
	print "Selecting ..."
	os.system("cat update_ncicancer_selections.r | R --slave")
	
def separate_datasets():
	print "Separating ..."
	# aid
	get_input_files("_processed")
	

def clean():
	print "Cleaning ..."
	os.system("rm activities.*")
	

if __name__ == "__main__":	
	check_molfiles()
	check_selections()
	separate_datasets()
	#clean()

