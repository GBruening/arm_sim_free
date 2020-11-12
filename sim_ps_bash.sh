#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=22
#SBATCH --time=96:00:00
#SBATCH --qos=long
#SBATCH --array=1 #-9
#SBATCH --partition=shas
#SBATCH --job-name=sim_ps_sc_50000
#SBATCH --output=sim_ps_sc_50000.out

module purge

ml gcc
ml openmpi
ml loadbalance
ml matlab

cd /scratch/summit/gabr0615/arm_model_optim_sim

matlab -nodesktop -nodisplay -r 'clear; num_workers=$SLURM_NTASKS; run sim_ps.m'


# mv filename /projects/gabr0615matlab -nodesktop -nodisplay -r 'clear; num_workers=$SLURM_NTASKS; L=1; run supercompute_arm_model.m'


