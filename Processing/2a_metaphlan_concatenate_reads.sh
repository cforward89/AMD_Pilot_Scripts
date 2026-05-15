#!/bin/bash

#SBATCH --account=def-bfinlay
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=15G

# Move to working directory
cd /home/armetcal/scratch/parsa_pilot

# Store concatenated reads here
mkdir -p sequences/hocort_concatenated

# Concatenate
ls hocort_out/*R1_001.fastq.gz | sed 's/hocort_out\///; s/_R1_001.fastq.gz//' | parallel 'zcat hocort_out/{}_R1_001.fastq.gz hocort_out/{}_R2_001.fastq.gz | gzip > sequences/hocort_concatenated/{}.fastq.gz'