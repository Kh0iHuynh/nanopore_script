#!/bin/bash
#SBATCH --account=modrek_1129
#SBATCH --partition=main
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=48:00:00
#SBATCH --array=1-24

#####
# intialize shell to run conda
# activate nanopore conda environment
#####
eval "$(conda shell.bash hook)"
conda activate nanopore

module load samtools/1.17 bedtools2/2.30.0
module load  gcc/11.3.0  openblas/0.3.20
module load r/4.3.2

module load pkgconf libpng libjpeg-turbo libtiff zlib bzip2 libxml2 curl fontconfig freetype graphite2 pcre harfbuzz fribidi glib openssl icu4c automake autoconf libtool m4 xz libiconv
#####
# Set environment variable
#####

input_namelist="./chrlist.txt"
input_namelist2="./chromosomeposition.txt"
input_dir="../nanopore_sample/2024_0122_sqkLSK114_gDNA_H23-1control/no_sample/20240122_1215_P2S-01214-A_PAU12868_f525d461/fastq_pass"
output_dir="../nanopore_sample/output"
mapped_bam_dir="../nanopore_sample/output"

#####
# get Nth line from input_namelist file
# and set that as variable
#####

chr=$(sed -n "${SLURM_ARRAY_TASK_ID}p" < $input_namelist)
position=$(sed -n "${SLURM_ARRAY_TASK_ID}p" < $input_namelist2)
echo "$chr"

samtools sort -@ 12 $mapped_bam_dir/out.$chr.bam -o $mapped_bam_dir/out.$chr.sorted.bam

samtools index $mapped_bam_dir/out.$chr.sorted.bam

echo "$position" > $chr.position.txt

bedtools coverage -sorted -d -a $chr.position.txt -b $mapped_bam_dir/out.$chr.sorted.bam > $mapped_bam_dir/$chr.coverage.bed
