

#!/usr/bin/r


# original file
act = as.matrix(read.table("/cs/taatto/group/urenzyme/workspace/molecular_classification/data/DTPNCI2015/activity_complete_structurefilter", sep = ' '))
aidlist = read.table('/cs/taatto/group/urenzyme/workspace/molecular_classification/data/DTPNCI2015/otherfiles/id2aid2name')[,2]

# remove cell lines
act.new.1 = c()
for(i in c(1:length(act[1,])))
{
        if(sum(act[1,i]==aidlist)==1 || act[1,i]==0)
	{act.new.1 = cbind(act.new.1, act[,i])}
	
}

# remove molecules
act.new.2 = c()
for(i in c(1:length(act.new.1[,1])))
{
	row = act.new.1[i,]
	na = row[is.na(row)]
	if(length(na) == 0)
	{act.new.2 = rbind(act.new.2, act.new.1[i,])}
}

# get targets
act = act.new.2
tar = act.new.2
for(i in c(2:length(act[,1])))
{
	for(j in c(2:length(act[1,])))
	{
		if(act[i,j] >= 60)
		{tar[i,j] = 1}
		else
		{tar[i,j] = -1}
	}
}

# all data
act.all = act
tar.all = tar



write.table(act.all, '/cs/taatto/group/urenzyme/workspace/molecular_classification/data/DTPNCI2015/activity_processed', row.names = FALSE, col.names = FALSE)
write.table(tar.all, '/cs/taatto/group/urenzyme/workspace/molecular_classification/data/DTPNCI2015/target_processed', row.names = FALSE, col.names = FALSE)





