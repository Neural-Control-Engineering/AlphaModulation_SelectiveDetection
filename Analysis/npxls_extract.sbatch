#!/bin/sh
#
#SBATCH -A your_account
#SBATCH -J npxls
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --time=0-48:00
#SBATCH -o logs/npxls_extract.log 
#SBATCH -e errs/npxls_extract.err
#SBATCH --mem 60gb
module load MATLAB/R2023b
matlab -batch "npxls_extract; exit()"
