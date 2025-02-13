#!/bin/sh
#
#SBATCH -A neuralctrl
#SBATCH -J ap-ftr
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=0-24:00
#SBATCH -o logs/ap_ftrs.log 
#SBATCH -e errs/ap_ftrs.err
#SBATCH --mem 20gb
module load MATLAB/R2023b
matlab -batch "ap_ftr_extraction; exit()"
