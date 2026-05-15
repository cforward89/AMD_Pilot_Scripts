#!/bin/bash
#SBATCH --time=00:30:00 
#SBATCH --nodes=1
#SBATCH --ntasks=1                    
#SBATCH --cpus-per-task=24                     
#SBATCH --mem=50G
#SBATCH --array=0-11
#SBATCH --job-name=bbduk
#SBATCH --output=logs/1d_filter_reads_bbduk_%A_%a.out   # Per-array task log
#SBATCH --error=logs/1d_filter_reads_bbduk_%A_%a.err  # Per-array task error log

#~~~Variables~~~#
WORK_DIR="/home/armetcal/scratch/parsa_pilot"
SAMPLE_LOC="$WORK_DIR/sequences"
LOG_DIR="$WORK_DIR/logs"
OUT_DIR="$WORK_DIR/bbduk_out"
STATS_DIR="$OUT_DIR/stats"
#~~~~~~~~~~~~~~~#

# Create output and log directories
mkdir -p $OUT_DIR $STATS_DIR $LOG_DIR

# Load the dependencies
module load StdEnv/2023 bbmap/39.06 java/17.0.6

# Allow overwrite of default memory usage
# The default is 2 Gb - below we specify 45 Gb (-Xmx45g)
unset JAVA_TOOL_OPTIONS

# Get list of R1 files
FILES=($SAMPLE_LOC/*_R1_001.fastq.gz)

# Select the correct file based on SLURM_ARRAY_TASK_ID
FILE=${FILES[$SLURM_ARRAY_TASK_ID]}
sample=$(basename "$FILE" "_R1_001.fastq.gz")

echo "Processing sample: $sample"

# Run bbduk.sh
# No contaminants - removed the adapter trimming bits.
bbduk.sh \
    in=$SAMPLE_LOC/"${sample}_R1_001.fastq.gz" \
    in2=$SAMPLE_LOC/"${sample}_R2_001.fastq.gz" \
    out=$OUT_DIR/"${sample}_R1_001.fastq.gz" \
    out2=$OUT_DIR/"${sample}_R2_001.fastq.gz" \
    statscolumns=5 \
    stats=$STATS_DIR/"${sample}_stats.txt" \
    qtrim=rl trimq=25 maq=25 minlength=50 \
    -Xmx45g

echo "Finished processing sample: $sample"
