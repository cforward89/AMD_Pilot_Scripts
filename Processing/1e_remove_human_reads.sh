#!/bin/bash
#SBATCH --time=01:00:00 
#SBATCH --nodes=1
#SBATCH --ntasks=1                    
#SBATCH --cpus-per-task=64                     
#SBATCH --mem=90G
#SBATCH --array=0-11
#SBATCH --output=logs/1e_hocort_%A_%a.out   # Per-array task log
#SBATCH --error=logs/1e_hocort_%A_%a.err  # Per-array task error log

# Also need to install/transfer over the human index.
#conda create -n hocort -c conda-forge -c bioconda hocort

#~~~Variables~~~#
WORK_DIR="/home/armetcal/scratch/parsa_pilot"
SAMPLE_LOC="$WORK_DIR/bbduk_out"
LOG_DIR="$WORK_DIR/logs"
OUT_DIR="$WORK_DIR/hocort_out"
HUMAN_INDEX="/home/armetcal/projects/def-bfinlay/armetcal/databases/hocort_index/human.index"
#~~~~~~~~~~~~~~~#

# Create output and log directories
mkdir -p $OUT_DIR $LOG_DIR

# Activate the conda environment
source /home/armetcal/miniconda3/etc/profile.d/conda.sh
conda activate hocort

# Get list of R1 files
FILES=($SAMPLE_LOC/*_R1_001.fastq.gz)

# Select the correct file based on SLURM_ARRAY_TASK_ID
FILE=${FILES[$SLURM_ARRAY_TASK_ID]}
sample=$(basename "$FILE" "_R1_001.fastq.gz")

echo "Processing sample: $sample"

# Run hocort
hocort map bowtie2 \
    -x $HUMAN_INDEX \
    -i $SAMPLE_LOC/"${sample}_R1_001.fastq.gz" $SAMPLE_LOC/"${sample}_R2_001.fastq.gz" \
    -o $OUT_DIR/"${sample}_R1_001.fastq.gz" $OUT_DIR/"${sample}_R2_001.fastq.gz" \
    --filter true \
    --threads=64

echo "Finished processing sample: $sample"
