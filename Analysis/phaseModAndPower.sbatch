#!/bin/sh
#
#SBATCH -A neuralctrl
#SBATCH -J phsAndPwr
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=0-48:00
#SBATCH -o logs/phase_mod_and_power.log 
#SBATCH -e errs/phase_mod_and_power.err
#SBATCH --mem 40gb
module load MATLAB/R2023b
matlab -batch "addpath(genpath('./')); phaseModAndPower; exit()"
