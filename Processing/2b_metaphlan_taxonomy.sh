#!/bin/bash
#SBATCH --account=def-bfinlay
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=64
#SBATCH --mem=64G
#SBATCH --array=0-11
#SBATCH --mail-type=END
#SBATCH --mail-user=avrilmetcalferoach@gmail.com

# Activate the virtual environment
source $SCRATCH/metaphlan_virenv/env/bin/activate

# Move to your working directory
WORKDIR="/home/armetcal/scratch/parsa_pilot"
cd $WORKDIR

# Initialize save directories
mkdir -p $WORKDIR/metaphlan_out
mkdir -p $WORKDIR/metaphlan_out/bt_out # This saves files from an intermediate step

# Load the required modules
# Note: update python version as required. If it’s not the correct version, you will probably see it in the slurm output file.
module load gcc blast samtools bedtools bowtie2 python/3.11

# Get all file names with their paths, then run MetaPhlAn4
# unclass estimation tells us how many reads weren't mapped to a specific taxon
# o is the save location and name
# nproc tells the code to use all the processing power available
date

FILES=($WORKDIR/sequences/hocort_concatenated/*.fastq.gz)
# Select the correct file based on SLURM_ARRAY_TASK_ID
FILE=${FILES[$SLURM_ARRAY_TASK_ID]}
sample=$(basename "$FILE" ".fastq.gz")

echo "Processing sample: $sample"

metaphlan $FILE \
--input_type fastq \
--unclassified_estimation \
-o $WORKDIR/metaphlan_out/${sample}.txt \
--nproc 64 \
-t rel_ab_w_read_stats \
--index mpa_vJan25_CHOCOPhlAnSGB_202503 \
--bowtie2db /home/armetcal/projects/def-bfinlay/armetcal/databases/metaphlan_databases/ \
--bowtie2out $WORKDIR/metaphlan_out/bt_out/${sample}.bowtie2.txt
date

echo "Finished processing sample: $sample"