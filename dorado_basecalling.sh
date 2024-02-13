#!/bin/bash

#SBATCH --job-name=dorado
#SBATCH --nodes=1
#SBATCH --gres=gpu:a100:1
#SBATCH --partition=a100_short
#SBATCH --time=24:00:00
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=256G

echo "Job ID: $SLURM_JOB_ID"
echo "Job Name: $SLURM_JOB_NAME"
echo "Number of Nodes: $SLURM_NNODES"
echo "Script file: $0"


#run from directory

module load cuda
echo -e "GPUS = $CUDA_VISIBLE_DEVICES\n"
nvidia-smi

#export 'PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:4096'
#export CUDA_MODULE_LOADING=LAZY
#module load cuda90


# Specify the input and output directories/files etc
pod5_dir="/gpfs/data/sulmanlab/UsersCurrent/AramModrek/2023_0531_ONT_mcgRNA/testFile/pod5"
BAM_dir="/gpfs/data/sulmanlab/UsersCurrent/AramModrek/2023_0531_ONT_mcgRNA/test_modifiedbasecalling/BAM"
model="/gpfs/data/sulmanlab/UsersCurrent/AramModrek/2023_0531_ONT_mcgRNA/test_modifiedbasecalling/dna_r10.4.1_e8.2_400bps_sup@v4.2.0"
#/gpfs/data/sulmanlab/UsersCurrent/AramModrek/0_packages/dorado-0.3.0-linux-x64/bin/dorado download --model dna_r10.4.1_e8.2_400bps_sup@v4.2.0

# Run  basecaller

/gpfs/data/sulmanlab/UsersCurrent/AramModrek/0_packages/dorado-0.3.0-linux-x64/bin/dorado basecaller \
--modified-bases 5mCG_5hmCG \
-v \
--reference /gpfs/share/apps/iGenomes/Homo_sapiens/UCSC/hg38/Sequence/Bowtie2Index/genome.fa \
$model $pod5_dir > ${BAM_dir}/testBAMmods_gpu1.bam

echo "samtools sort and index"
module load samtools

#sort and index
samtools sort -o ${BAM_dir}/testBAMmods_gpu1_sorted.bam ${BAM_dir}/testBAMmods_gpu1.bam
samtools index ${BAM_dir}/testBAMmods_gpu1_sorted.bam

echo "done"
