#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=22
#SBATCH --time=120:00:00
#SBATCH --qos=long
#SBATCH --array=1 #-9
#SBATCH --partition=shas
#SBATCH --job-name=sim_ga
#SBATCH --output=sim_ga.out

module purge

ml gcc
ml openmpi
ml loadbalance
ml matlab

cd /scratch/summit/gabr0615/arm_model_optim_sim

matlab -nodesktop -nodisplay -r 'clear; num_workers=$SLURM_NTASKS; run sim_ga.m'


# mv filename /projects/gabr0615matlab -nodesktop -nodisplay -r 'clear; num_workers=$SLURM_NTASKS; L=1; run supercompute_arm_model.m'


