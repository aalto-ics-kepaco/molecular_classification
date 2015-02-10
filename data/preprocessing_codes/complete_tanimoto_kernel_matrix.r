

# the script is for completing the bottom part of tanimoto kernel matrix by copying the upper part of the matrix
# it will be called by Perl script

argv = commandArgs(trailingOnly = TRUE)
file = argv[1]
data = as.matrix(read.table(sprintf("%s", file), sep = ' '))

for(i in c(1:length(data[,1])))
{
	for(j in c(1:i))
	{
		data[i,j] = data[j,i]
	}
}

write.table(data, sprintf("%s", file), row.names = FALSE, col.names = FALSE)

