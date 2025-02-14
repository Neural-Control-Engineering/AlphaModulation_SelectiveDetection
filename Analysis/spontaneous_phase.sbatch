#!/bin/sh
#
#SBATCH -A your_account
#SBATCH -J spnphs
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=0-24:00
#SBATCH -o logs/spontaneous_phase.log 
#SBATCH -e errs/spontaneous_phase.err
#SBATCH --mem 20gb
module load MATLAB/R2023b
matlab -batch "sponSpikePhasePlotting; exit()"
