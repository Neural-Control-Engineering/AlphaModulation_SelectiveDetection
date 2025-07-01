#!/bin/sh
#
#SBATCH -A neuralctrl
#SBATCH -J lickFr
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=0-08:00
#SBATCH -o logs/lick_and_fr.log 
#SBATCH -e errs/lick_and_fr.err
#SBATCH --mem 40gb
module load MATLAB/R2023b
matlab -batch "addpath(genpath('./')); licksAndFr; exit()"
