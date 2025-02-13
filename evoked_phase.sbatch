#!/bin/sh
#
#SBATCH -A your_account
#SBATCH -J evkphs
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=0-24:00
#SBATCH -o logs/evoked_phase.log 
#SBATCH -e errs/evoked_phase.err
#SBATCH --mem 20gb
module load MATLAB/R2023b
matlab -batch "evokedSpikePhasePlotting; exit()"
