function extToFtrAP(ext_path, session_ids, regMap, ftr_file)
    for i = 1:length(session_ids)
        % load ap and slrt data for each session 
        session_id = session_ids{i};
        sesh_id_parts = strsplit(session_id, '_');
        subj_id = session_id(length(sesh_id_parts{1})+2:end);
        slrt_ext = load(strcat(ext_path, 'SLRT/', session_id, '.mat'));
        ap_ext = load(strcat(ext_path, 'AP/', session_id, '.mat'));

        % only interested in good units 
        for j = 1:size(ap_ext.ap_data,1)
            spiking_data = ap_ext.ap_data(j,:).spiking_data{1};
            spiking_data = spiking_data(strcmp(spiking_data.quality, 'good'),:);
            ap_ext.ap_data(j,:).spiking_data{1} = spiking_data;
        end

        % table for session 
        sesh_id_array = cell(length(ap_ext.ap_data(1,:).spiking_data{1}.cluster_id), 1);
        for j = 1:length(sesh_id_array)
            sesh_id_array{j} = session_id;
        end

        positions =  cell2mat(ap_ext.ap_data(1,:).spiking_data{1}.position);
        
        ap_session = table(sesh_id_array, ap_ext.ap_data(1,:).spiking_data{1}.cluster_id, ...
            ap_ext.ap_data(1,:).spiking_data{1}.quality, ...
            ap_ext.ap_data(1,:).spiking_data{1}.template, ap_ext.ap_data(1,:).spiking_data{1}.template_amplitude, positions, ...
            'VariableNames', {'session_id', 'cluster_id', 'quality', 'template', 'template_amplitude', 'position'});

        ap_session = classifyWaveform(ap_session, 0.351);

        if contains(session_id, 'phase5')
            if ~any(strcmp(slrt_ext.slrt_data.Properties.VariableNames, 'left_minus_right_amp'))
                slrt_ext.slrt_data = leftMinusRight(slrt_ext.slrt_data);
            end
            ap_session = avgPSTHbyLeftMinusRight(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, -3:0.1:5);
            ap_session = avgPSTHbyLeftMinusRightAndOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, -3:0.1:5);
        end

        ap_session = lfpPhaseHists(ap_session, ap_ext.ap_data, {'left_trigger', 'right_trigger'});

        ap_session = lfpPhaseHistSponLicking(ap_session, ap_ext.ap_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'});

        ap_session = lfpPhaseHistByOutcome(ap_session, ap_ext.ap_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'});

        ap_session = assignRegions(ap_session, regMap);

        % % compute various trial averaged metrics 
        ap_session = avgPSTHbyOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'Hit', -3:0.1:5);
        ap_session = avgPSTHbyOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'CR', -3:0.1:5);
        ap_session = avgPSTHbyOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'Miss', -3:0.1:5);
        ap_session = avgPSTHbyOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'FA', -3:0.1:5);

        % ap_session = avgPSTHbyPreviousOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'Hit', -3:0.1:5);
        % ap_session = avgPSTHbyPreviousOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'Miss', -3:0.1:5);
        % ap_session = avgPSTHbyPreviousOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'CR', -3:0.1:5);
        % ap_session = avgPSTHbyPreviousOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'FA', -3:0.1:5);
        
        ap_session = avgPSTHbyPerformance(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, {'left_trigger', 'right_trigger'}, -3:0.1:5);
        
        ap_session = avgPSTHbyAction(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, {'left_trigger', 'right_trigger'}, -3:0.1:5);
        
        ap_session = avgPSTHbyEvent(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'left_trigger', -3:0.1:5);
        ap_session = avgPSTHbyEvent(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'right_trigger', -3:0.1:5);

        ap_session = avgPSTHsToFRs(ap_session, 0.1, 5);

        ap_session = avgBaselineFR(ap_session, ap_ext.ap_data, {'left_trigger', 'right_trigger'});

        ap_session = isStimModulated(ap_session, ap_ext.ap_data, {'left_trigger', 'right_trigger'});

        ap_session = isStimModByOutcome(ap_session, ap_ext.ap_data, slrt_ext.slrt_data, 'Hit', {'left_trigger', 'right_trigger'});
        ap_session = isStimModByOutcome(ap_session, ap_ext.ap_data, slrt_ext.slrt_data, 'Miss', {'left_trigger', 'right_trigger'});
        ap_session = isStimModByOutcome(ap_session, ap_ext.ap_data, slrt_ext.slrt_data, 'CR', {'left_trigger', 'right_trigger'});
        ap_session = isStimModByOutcome(ap_session, ap_ext.ap_data, slrt_ext.slrt_data, 'FA', {'left_trigger', 'right_trigger'});
        
        ap_session = avgTrialFR(ap_session, slrt_ext.slrt_data, ap_ext.ap_data);

        % ap_session = auROC(ap_session, ap_ext.ap_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'}, 0.2);

        ap_session = ISIhist(ap_session, ap_ext.ap_data, slrt_ext.slrt_data);

        % ap_session = avgSponCVbyOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'Hit');
        % ap_session = avgSponCVbyOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'Miss');
        % ap_session = avgSponCVbyOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'CR');
        % ap_session = avgSponCVbyOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'FA');
        
        ap_session = isDeltaModulated(ap_session);
        ap_session = isAlphaModulated(ap_session);
        ap_session = isThetaModulated(ap_session);
        ap_session = isBetaModulated(ap_session);

        % ap_session = avgPSTHbyPrevAndCurrentOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'Hit',  -3:0.1:5);
        % ap_session = avgPSTHbyPrevAndCurrentOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'Miss',  -3:0.1:5);
        % ap_session = avgPSTHbyPrevAndCurrentOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'CR',  -3:0.1:5);
        % ap_session = avgPSTHbyPrevAndCurrentOutcome(ap_session, slrt_ext.slrt_data, ap_ext.ap_data, 'FA',  -3:0.1:5);


        if ~exist('ap_ftr')
            ap_ftr = ap_session;
        else
            ap_ftr = combineTables(ap_ftr, ap_session);
        end
    end
    save(ftr_file, 'ap_ftr', '-v7.3')
end