#!/bin/sh
#
#SBATCH -A your_account
#SBATCH -J lfp-ftr
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=0-48:00
#SBATCH -o logs/lfp_ftrs.log 
#SBATCH -e errs/lfp_ftrs.err
#SBATCH --mem 40gb
module load MATLAB/R2023b
matlab -batch "lfp_ftr_extraction; exit()"
