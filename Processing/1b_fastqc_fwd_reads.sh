#!/bin/bash

#SBATCH --account=def-bfinlay   # Change bfinlay to your professor's username
#SBATCH --time=06:00:00      # Adjust time as needed
#SBATCH --cpus-per-task=10
#SBATCH --mem=15G 

path_to_seqs="/home/armetcal/scratch/parsa_pilot/sequences"

# Load FastQC and its dependencies - update versions as needed.
module load StdEnv/2023 fastqc/0.12.1
# Run FastQC on all forward read files
parallel fastqc --outdir=/home/armetcal/scratch/parsa_pilot/FastQC ::: $path_to_seqs/*1_001.fastq.gz