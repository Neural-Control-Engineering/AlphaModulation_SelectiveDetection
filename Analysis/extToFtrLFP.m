function extToFtrLFP(ext_path, session_ids, ftr_path, chanMap)
    for i = 1:length(session_ids)
        % load ap and slrt data for each session 
        session_id = session_ids{i};
        slrt_ext = load(strcat(ext_path, 'SLRT/', session_id, '.mat'));
        lfp_ext = load(strcat(ext_path, 'LFP/', session_id, '.mat'));

        % table for session 
        sesh_id_array = cell(size(lfp_ext.lfp_data(1,:).lfp{1},1), 1);
        for j = 1:length(sesh_id_array)
            sesh_id_array{j} = session_id;
        end
        
        lfp_session = table(sesh_id_array, num2cell(1:size(lfp_ext.lfp_data(1,:).lfp{1},1))', 'VariableNames', {'session_id', 'channel_id'});
        
        % lfp_session = avgBaselineSpectrum(lfp_session, lfp_ext.lfp_data, {'left_trigger', 'right_trigger'});
        
        lfp_session = avgBaselineSpectrumByOutcome(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'});

        lfp_session = ERP(lfp_session, lfp_ext.lfp_data, {'left_trigger', 'right_trigger'}, -3, 5);

        lfp_session = ERPbyOutcome(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'}, -3, 5);

        lfp_session = avgStimInducedSpectrum(lfp_session, lfp_ext.lfp_data, {'left_trigger', 'right_trigger'});

        lfp_session = avgStimInducedSpectrumByOutcome(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'});

        lfp_session = avgSpectrogramByOutcome(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data);

        save(strcat(ftr_path, 'LFP/', session_id, '.mat'), 'lfp_session')

        avgCsdByOutcome(lfp_ext.lfp_data, slrt_ext.slrt_data, chanMap, ftr_path, session_id)

        % if contains(session_id, 'phase5')
        %     lfp_session = ERPbyLeftMinusRight(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, -3, 5);
        %     lfp_session = ERPbyLeftMinusRightAndOutcome(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, -3, 5);
        % end

        % tmp_session = baselineAlphaPowerByOutcome(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'right_trigger', 'left_trigger'});
        % keyboard
        % lfp_session = baselineThetaPowerByOutcome(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'right_trigger', 'left_trigger'});
        % lfp_session = baselineBetaPowerByOutcome(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'right_trigger', 'left_trigger'});
        % lfp_session = baselineDeltaPowerByOutcome(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'right_trigger', 'left_trigger'});
        % lfp_session = baselineGammaPowerByOutcome(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'right_trigger', 'left_trigger'});
        
        % lfp_session = avgInstAlphaPower(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'});
        % lfp_session = avgInstBetaPower(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'});
        % lfp_session = avgInstThetaPower(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'});
        % lfp_session = avgInstDeltaPower(lfp_session, lfp_ext.lfp_data, slrt_ext.slrt_data, {'left_trigger', 'right_trigger'});

    end
end