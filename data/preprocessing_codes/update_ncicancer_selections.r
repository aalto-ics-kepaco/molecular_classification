

#!/usr/bin/r


# original file
act = as.matrix(read.table("../DTPNCI2015/activity_complete_structurefilter", sep = ' '))
aidlist = read.table('../DTPNCI2015/otherfiles/id2aid2name')[,2]

# remove cell lines
act.new.1 = c()
add = c()
for(i in c(1:length(act[1,])))
{
        if(sum(act[1,i]==aidlist)==1 || act[1,i]==0)
	{act.new.1 = cbind(act.new.1, act[,i])}
        else
        {add = cbind(add,act[,i])}
	
}
act.new.1 = cbind(act.new.1,add)

# remove molecules
act.new.2 = c()
add = c()
for(i in c(1:length(act.new.1[,1])))
{
	row = act.new.1[i,]
	na = row[is.na(row[1:60])]
	if(length(na) == 0)
	{act.new.2 = rbind(act.new.2, act.new.1[i,])}
        else
        {add = rbind(add, act.new.1[i,])}
}

# get targets
act = act.new.2
tar = act.new.2
for(i in c(2:length(act[,1])))
{
	for(j in c(2:length(act[1,])))
	{
                if(is.na(act[i,j]))
                {tar[i,j] = NA}
                else if(act[i,j] >= 60)
		{tar[i,j] = 1}
		else
		{tar[i,j] = -1}
	}
}

# all data
act.all = act
tar.all = tar



write.table(act.all, '../DTPNCI2015/activity_processed', row.names = FALSE, col.names = FALSE)
write.table(tar.all, '../DTPNCI2015/target_processed', row.names = FALSE, col.names = FALSE)





