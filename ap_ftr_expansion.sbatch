#!/bin/sh
#
#SBATCH -A neuralctrl
#SBATCH -J ap-ftr-exp
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=0-24:00
#SBATCH -o logs/ap_ftrs_expand.log 
#SBATCH -e errs/ap_ftrs_expand.err
#SBATCH --mem 20gb
module load MATLAB/R2023b
matlab -batch "ap_ftr_expansion; exit()"
