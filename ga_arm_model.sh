#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --time=22:00:00
#SBATCH --array=1 #-9
#SBATCH --partition=shas
#SBATCH --job-name=ga_arm_model
#SBATCH --output=ga_arm_model.out

module purge

ml gcc
ml openmpi
ml loadbalance
ml matlab

cd /scratch/summit/gabr0615/ga_arm_model

matlab -nodesktop -nodisplay -r 'clear; num_workers=$SLURM_NTASKS; run ga_script.m'


# mv filename /projects/gabr0615matlab -nodesktop -nodisplay -r 'clear; num_workers=$SLURM_NTASKS; L=1; run supercompute_arm_model.m'


