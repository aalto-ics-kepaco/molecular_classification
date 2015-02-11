#
#	The script is for calculating tanimoto kernel based on different feature representations
#	Usage:
#		perl get_tanimoto_kernel.pl featurematrix generated_kernel_matrix
#	Example usage:
#		perl get_tanimoto_kernel.pl ../features/cancer_feature_functional_groups_small_mol1.txt cancer_matrix_functional_groups_small_mol1.txt
#
#
#
#
#


use strict;
use warnings;

my $featurematrix = $ARGV[0];
my $kernelfilename = $ARGV[1];



get_tanimoto($featurematrix, $kernelfilename);

sub get_tanimoto
{	
	print "On ", $featurematrix, " ...\n";
	my $featurematrix = $_[0];
	my $kernelfilename = $_[1];
	my $tempfilename = $kernelfilename;
	my @features;
	my $a;
	my $b;
	my $c;
	my $i;
	my $j;
	
	$tempfilename =~ s/.*\//tmp_/g;

	# get features
	open(IN, "<$featurematrix") or die;
	foreach(<IN>)
	{
#		print $_;
		chomp($_);
		push(@features, $_);
	}
	close(IN);

	#calculate kernel
	open(OUT, ">$tempfilename") or die;
	#@features = ();$features[0] = '111000101';$features[1] = '0';
        for($i = 0; $i < scalar(@features); $i ++)
        #for($i = 0; $i < 10; $i ++)
	{
                for($j = 0; $j < scalar(@features); $j ++)
                #for($j = 0; $j < 10; $j ++)
		{
			if($i > $j)
			{print OUT "0"}
			else
			{
				$c = "$features[$i]" & "$features[$j]";
				$a = "$features[$i]";
				$b = "$features[$j]";
				
				$c = ($c =~ s/1/1/g);
				$a = ($a =~ s/1/1/g);
				$b = ($b =~ s/1/1/g);

				if($c eq '')
				{$c=0}
				if($a eq '')
				{$a=0}
				if($b eq '')
				{$b=0}
					
				if($a+$b+$c == 0)
				{printf OUT "0.0000";}
				else
				{printf OUT "\%.4f", $c/($a + $b - $c);}
			}

                        if($j == scalar(@features) - 1)
                        #if($j == 10 - 1)
			{print OUT "\n"}
			else
			{print OUT " "}
		}
	}
	close(OUT);

	# complete the bottom part of the matrix
	system(sprintf("cat complete_tanimoto_kernel_matrix.r | R --slave --args '%s'", $tempfilename));

	# write to file
	open(OUT, ">$kernelfilename") or die;
	open(IN, "<$tempfilename") or die;
	foreach(<IN>)
	{
		print OUT $_;
	}
	close(IN);
	close(OUT);

	# remove temp file
        #`rm $tempfilename`;
	
}
