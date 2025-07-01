#!/bin/sh
#
#SBATCH -A neuralctrl
#SBATCH -J pfcShuff
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=0-72:00
#SBATCH -o logs/pfc_lick_nolick_shuffle.log 
#SBATCH -e errs/pfc_lick_nolick_shuffle.err
#SBATCH --mem 40gb
module load MATLAB/R2023b
matlab -batch "addpath(genpath('./')); lickNoLickShuffle; exit()"
