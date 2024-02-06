#!/bin/bash
#SBATCH --account=modrek_1129
#SBATCH --partition=main
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=48:00:00

#####
# intialize shell to run conda
# activate nanopore conda environment
#####
eval "$(conda shell.bash hook)"
conda activate nanopore

module load samtools/1.17 bedtools2/2.30.0
module load  gcc/11.3.0  openblas/0.3.20
module load r/4.3.2
module load fastqc/0.11.9
module load pkgconf libpng libjpeg-turbo libtiff zlib bzip2 libxml2 curl fontconfig freetype graphite2 pcre harfbuzz fribidi glib openssl icu4c automake autoconf libtool m4 xz libiconv
#####
# Set environment variable
#####

input_namelist="./namelist.txt"
input_dir="../nanopore_sample/2024_0122_sqkLSK114_gDNA_H23-1control/no_sample/20240122_1215_P2S-01214-A_PAU12868_f525d461/fastq_pass"
output_dir="../nanopore_sample/output"
mapped_bam_dir="../nanopore_sample/output"

#####
# combine all fastq.gz into one
#####
zcat $input_dir/*.fastq.gz > $output_dir/all.fastq

#####
# fastqc qc
#####
fastqc -o $output_dir/backup/ -t 14 $output_dir/backup/all.fastq


#####
# mapping sequence to reference
# index sorted bam
#####

minimap2 -a -x map-ont -t 14 /project/modrek_1129/KhoiHuynh/reference_genome/hg38/hg38.mmi $output_dir/all.fastq | samtools sort - -o $mapped_bam_dir/all.sorted.bam
samtools index $mapped_bam_dir/all.sorted.bam


#####
# split bam by chromosome
#####
for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY; do
 samtools view -bo $mapped_bam_dir/out.$chr.bam $mapped_bam_dir/all.sorted.bam $chr
done
