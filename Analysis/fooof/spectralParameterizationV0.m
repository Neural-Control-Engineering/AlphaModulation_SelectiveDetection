function DF_specs = spectralParameterizationV0(DF_chg, args)
    % INPUTS: df_chg --> 'channelgram' derived dataframe containing PSD
    % group
    % OUTPUTS: df_specs --> spectral parameterization time series

    % CFG HEADER
    peakWidth_min = args.peakWidth_min; % default = 2
    peakWidth_max = args.peakWidth_max; % default = 8    
    numPeaks_max = args.numPeaks_max; % default = 8
    peakHeight_min = args.peakHeight_min; % default = 0.2    
    peakThreshold = args.peakThreshold; % default = 2
    chanRange_start  = args.chanRange_start; % default = 1
    chanRange_end = args.chanRange_end; % default = 384

    df_chg = DF_chg.df;
    f = DF_chg.ax.f;
    % specparam inputs
    peak_width_limits = py.tuple([peakWidth_min, peakWidth_max]);
    max_n_peaks = py.int(numPeaks_max);
    min_peak_height = py.int(peakHeight_min);
    peak_threshold = py.int(peakThreshold);
    % aperiodic_mode = py.str(aperiodicMode);
    % data inputs
    freqs = py.numpy.array(double(f), pyargs('dtype', 'float64'));
    spectra = py.numpy.array(double(((df_chg)')), pyargs('dtype', 'float64')); % de-log
    % keyboard

    % instantiate spectralFittingModel
    specParam = py.importlib.import_module('specparam');    
    fg = specParam.SpectralGroupModel(peak_width_limits, max_n_peaks, min_peak_height, peak_threshold);
    fg.fit(freqs, spectra);

    % cast results
    specs = fg.group_results;
    specs = cell((specs))';
    specs = cellfun(@(x) extractSpecParamOutputs(x), specs, "UniformOutput", true);
    specsTable = struct2table(specs(:));
    DF_specs = specsTable;
    
end