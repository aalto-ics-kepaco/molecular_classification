
library("ChemmineR")
library("R.matlab")

args = commandArgs(TRUE)
sdffilename = args[1]
resfilename = args[2]


alllabels = c("H","He","Li","Be","B","C","N","O","F","Ne","Na","Mg","Al","Si","P","S","Cl","Ar","K","Ca","Sc","Ti","V","Cr","Mn","Fe","Co","Ni","Cu","Zn","Ga","Ge","As","Se","Br","Kr","Rb","Sr","Y","Zr","Nb","Mo","Tc","Ru","Rh","Pd","Ag","Cd","In","Sn","Sb","Te","I","Xe","Cs","Ba","Lu","Hf","Ta","W","Re","Os","Ir","Pt","Au","Hg","Tl","Pb","Bi","Po","At","Rn","Fr","Ra","Lr","Rf","Db","Sg","Bh","Hs","Mt","Ds","Rg","La","Ce","Pr","Nd","Pm","Sm","Eu","Gd","Tb","Dy","Ho","Er","Tm","Yb","Ac","Th","Pa","U","Np","Pu","Am","Cm","Bk","Cf","Es","Fm","Md","No")

dec = function(b){
    c = strsplit(b,"_",fixed=TRUE)
    d = matrix(unlist(c),ncol=2,byrow=TRUE)
    d[,1]
}

  
# get sdf files and fingerprints for the compounds in the ith subset
sdfset = read.SDFset(sdffilename)

# keep only valid sdf files (i.e. with at least one bound in the compound)
valid = validSDF(sdfset)
sdfset = sdfset[valid]
  
# Get adjacency matrices
madj = conMA(sdfset)

# Node labels
node_labels = lapply(madj, function(M) dec(row.names(M)))

fun_match = function (b)
{
        match(b, alllabels)
}

node_labels_num = lapply(node_labels,fun_match)
  
#print(madj)
#print(node_labels_num)

writeMat(resfilename, madj=madj,n_lab=node_labels_num)


