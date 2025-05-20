#!/bin/sh
#
#SBATCH -A neuralctrl
#SBATCH -J outShuff
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=0-48:00
#SBATCH -o logs/correct_incorrect_shuffle.log 
#SBATCH -e errs/correct_incorrect_shuffle.err
#SBATCH --mem 40gb
module load MATLAB/R2023b
matlab -batch "addpath(genpath('./')); correctIncorrectShuffle; exit()"
