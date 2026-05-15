#!/bin/bash
#SBATCH --time=01:00:00 
#SBATCH --nodes=1
#SBATCH --ntasks=1                    
#SBATCH --cpus-per-task=2                     
#SBATCH --mem=8G
#SBATCH --job-name=multiqc
#SBATCH --output=logs/1c_multiqc.out
#SBATCH --error=logs/1c_multiqc.err

# module load apptainer
# cd /home/armetcal/projects/def-bfinlay/armetcal/apptainer_images/
# apptainer pull docker://multiqc/multiqc:latest

#~~~Variables~~~#
WORK_DIR="/home/armetcal/scratch/parsa_pilot/FastQC"
APP_LOC="/home/armetcal/projects/def-bfinlay/armetcal/apptainer_images/"
MULTIQC_LOC="$APP_LOC/multiqc_latest.sif"
#~~~~~~~~~~~~~~~#

# Load Apptainer
module load gcc/14.3 apptainer/1.3.5

# Run MultiQC on all FastQC zip/html files
apptainer exec \
  --bind $WORK_DIR:/data \
  --workdir /data \
  $MULTIQC_LOC \
  multiqc /data \
  -o /data

echo "MultiQC report generated."
