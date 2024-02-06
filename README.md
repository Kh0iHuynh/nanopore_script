# nanopore_script

## nanopore_alignment.sh
This is the script used to align nanopore sequence (fastq.gz). The squence also has adapter trimmed with option in Miniknow package.
namelist.txt is unimportant for this script because it is just a placeholder. One can make changes to array count,namelist, and other necessary places to run parallel arrays processing multiple files at once. 

## nanopore_coverage_calculation.sh
This is the script used to calculate coverage from produced bam files after alignment. This process needs tremendous memory so 16 was asked (assume 8GB memory per core).

Chromosomeposition.txt is a file with coordinate for all chromosomes in HG38 genome. The file has three columns "Chromosome Start End" for each chromosomes.
chrlist.txt is a list of all processed chromosome. 

#### NOTE: both chromosomeposition.txt and chrlist.txt must be in the same order. 
