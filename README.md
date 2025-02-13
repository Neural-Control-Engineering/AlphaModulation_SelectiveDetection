# Introduction
This repository contains code for running experiments and analyzing data presented in *link to biorxv*.
While there are some general tools here that could be used with neural and behavioral data, code as 
a whole is intended for use in conjunction with [n-CORTEx](https://github.com/Neural-Control-Engineering/n-CORTex) - 
a MATLAB application desigend to collect, store, and segment neurophysiological and behavioral data.

# Data collection 
Make sure you have installed [n-CORTEx](https://github.com/Neural-Control-Engineering/n-CORTex).

After launching the app, set *./Experiment-Module/* under *Modules*, set *Project* to the desired 
folder to save your data, and select *SELECT_DETECT* as the experiment. Next to the 
*Experiment* tab, you will have the option to select an experiment phase. 

    Phase 1 - Classical conditioning: "Target" (go) stimuli are immediately paired with water reward, requiring
    no action on the part of the mouse, while no-go stimuli are not.

    Phase 2 - Operant conditioning: Mice must lick within a 1.5 s window of opportunity in response to a go 
    stimulus to receive a water reward.  Rewards are delived at 1.5 s following the stimulus presentation 
    regardles of when the mouse responded.  There is no punishment for false alarms.

    Phase 3 - Full task: Mice must lick within a 1 s window of opportunity in response to a go stimulus to 
    receive a water reward.  Rewards are delived 1 s following stimulus presentation.  False alarms result 
    in an increased inter-trial interval.

Under the parameters tab, *var_trainingStage* corresponds to the phases above.  One may also set *var_trainingStage* to 
111, which ejects water from the spout once per second, or 222, which deflects the target/go piezo once per second.

From there, you can use n-CORTEx normally, toggling any relevant recording paradigms you wish to use during the behavior session.
For this task, the *Sensory* tab must be toggled ON and configured for whisker deflections.

The behavior paradigm may alternatively be run directly from Simulink, but the user will need to handle all 
other data collection and segmentation themselves, and subsequent analysis code contained here will likely 
not be compatible.

# Analysis 
First, Neuropixels data must be sorted with [Kilosort](https://github.com/MouseLand/Kilosort).  
This can be done through n-CORTEx.

For subsequent analyses, you will also need to install [Chronux](https://chronux.org/) and [CircStat](https://github.com/circstat/circstat-matlab).

There are multiple processing steps necessary to run the analyses presented in *link to biorxv*.
To start running analyses, navigate to *./Analysis/* and run MATLAB.

First, behavior data collected via Simulink must be segmented by trial:
*slrt_extract.m* segments sessions run in our study and computes a number of behavioral metrics (e.g. hit rate, reaction time, etc).

Next, the spiking and local field potential (LFP) data also must be segmented by trial:
*npxls_extract.m* segments the spiking and LFP data from our study and computes a number of physiological metrics (e.g. single unit firing rates, lfp sprecta, etc).
This requires significant computing power, and we highly recommend running this on a cluster.  
*npxls_extract.sbatch* is a SLURM script used for running *npxls_extract.m* on a cluster with the SLURM scheduling system.
Running these extraction scripts generates MATLAB table saved in an *EXT* folder.

Then, it is necessary to generate *features* from those trial-segmented data tables.
To generate behavioral features, you must run *slrt_ftr_extraction.m*, which computes session-wide behavioral measures (e.g. d-prime, average reaction times, etc.).
Similarly, to generate features based on spiking and LFPs, you must run *ap_ftr_extraction.m* and *lfp_ftr_extraction.m*.
Again, these scripts require substantial computing time/power, and we recommend running them on a cluster.

To compute metrics related to alpha phase modulation of single unit spiking activity, one must run *sponSpikePhasePlotting.m*.
This script generates *data.mat* files containing phase modualtion metrics and plots a number of figures summarising 
phase modulation on a cell-by-cell basis.  Again there is a SLURM script for running this on a cluster: *spontaneous_phase.sbatch*.

Finally, to perform anlyses and generate plots found in *link to biorxv*, there are scripts in the folder *./AlphaModFigScripts/*.
These scripts should be run, however, from the *./Analysis/* folder.