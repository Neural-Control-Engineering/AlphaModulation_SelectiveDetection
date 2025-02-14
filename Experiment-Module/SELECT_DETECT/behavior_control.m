function [state_out, trialNum_out, ...
    npxlsAcq_out, numLicks_out, reward_trigger_out, ...
    right_trigger_out, left_trigger_out, delay_out, was_target_out, ... 
    reward_duration_out, stim_duration_out, right_amp_out, left_amp_out] ...
    = behavior_control(state_in, trialNum_in, lick, ...
    sessionTime, npxlsAcq_in, numLicks_in, delay_in, ... 
    right_trigger_in, left_trigger_in, sampleTime, was_target_in, ...
    target_side, reward_duration_in, stim_duration_in, switch_time, stage, ...
    right_amp_in, left_amp_in, right_amp_gain, left_amp_gain, target_prob)
% stages: 1 - classical conditioning, 2 - opreant conditioning, 3 - impulse
% control, 111 - calibrate reward delivery; 222 - position piezo; 333 -
% calibrate piezo driver triangle duration 
    

    %rng(101)

    switch (stage)
        case {1} %% classical conditioning 
            right_amp_out = 10 * right_amp_gain;
            left_amp_out = 10 * left_amp_gain;
            switch (state_in) 
                case {0} % LOAD SESSION PARAMS
                    rng('shuffle')
                    state_out = 1;
                    npxlsAcq_out=3.3;
                    trialNum_out = 0;
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = delay_in;
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                case {1} %% TRIAL START
                    npxlsAcq_out=npxlsAcq_in;
                    state_out = 2; % go to ITI
                    trialNum_out = 1;
                    % reset piezo triggers and lick counter
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = sessionTime + negative_exp_rand(5,9);
                    disp('End of ITI')
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
        
                case {2} %% inter-trial interval  
                    if sessionTime < delay_in
                        state_out = state_in; % continue with ITI 
                    else
                        state_out = 3; % go to stimulus 
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in; % keep piezo triggers 
                    left_trigger_out = left_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
        
                case {3} %% stimulus onset 
                    if rand() <= (1-target_prob) % 80% distractor stims 
                        if target_side % 1: left target
                            right_trigger_out = 1;
                            left_trigger_out = 0;
                        else % 0: right target
                            left_trigger_out = 1;
                            right_trigger_out = 0;
                        end
                        disp('Distractor')
                        disp(sessionTime)
                        was_target_out = 0;
                    else % 20% target stims 
                        if target_side % 1: left target
                            left_trigger_out = 1;
                            right_trigger_out = 0;
                        else
                            right_trigger_out = 1;
                            left_trigger_out = 0;
                        end
                        disp('Target')
                        disp(sessionTime)
                        was_target_out = 1;
                    end
                    % trigger a piezo  
                    state_out = 4; % go to lockout window
                    delay_out = sessionTime + 0.2;
                    disp('End of lockout')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    numLicks_out = numLicks_in;
                    npxlsAcq_out=npxlsAcq_in;
                    reward_trigger_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
        
                case {4} %% lockout window 
                    if sessionTime < delay_in 
                        state_out = state_in;
                        delay_out = delay_in;
                    elseif was_target_in
                        state_out = 5; % deliver reward 
                        delay_out = sessionTime + 1.0;
                    else
                        state_out = 6; % jump to response window (unrewarded)
                        delay_out = sessionTime + 1.0;
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = 0; % reset piezo triggers
                    right_trigger_out = 0;
                    numLicks_out = numLicks_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
             
                case {5} %% reward delivery `
                    % trigger reward 
                    reward_trigger_out = 1;
                    disp('Deliver Reward')
                    disp(sessionTime)
                    state_out = 6; % go to response window
                    delay_out = delay_in;
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    right_trigger_out = right_trigger_in;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {6} %% response window 
                    if sessionTime < delay_in
                        state_out = state_in;
                    else
                        state_out = 1; % start new trial
                        disp('Start new trial')
                        disp(sessionTime)
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    right_trigger_out = right_trigger_in;
                    left_trigger_out = left_trigger_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                otherwise
                    state_out = state_in;
                    trialNum_out = trialNum_in;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in; % reset piezo triggers 
                    left_trigger_out = left_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
            end
        case {2} %% operant conditioning 
            right_amp_out = 10 * right_amp_gain;
            left_amp_out = 10 * left_amp_gain;
            switch (state_in)         
                case {0} % LOAD SESSION PARAMS
                    rng('shuffle')
                    state_out = 1;
                    npxlsAcq_out=3.3;
                    trialNum_out = 0;
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = delay_in;
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                case {1} %% TRIAL START
                    npxlsAcq_out=npxlsAcq_in;
                    state_out = 2; % go to ITI
                    trialNum_out = 1;
                    % reset piezo triggers and lick counter
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = sessionTime + negative_exp_rand(8,12);
                    disp('End of ITI')
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {2} %% inter-trial interval  
                    if sessionTime < delay_in
                        state_out = state_in; % continue with ITI 
                    else
                        state_out = 3; % go to stimulus 
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in; % keep piezo triggers 
                    left_trigger_out = left_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {3} %% stimulus onset 
                    if rand() <= (1-target_prob)% distractor stims 
                        if target_side % 1: left target 
                            right_trigger_out = 1;
                            left_trigger_out = 0;
                        else % 0: right target 
                            left_trigger_out = 1;
                            right_trigger_out = 0;
                        end
                        disp('Distractor')
                        disp(sessionTime)
                        was_target_out = 0;
                    else % 20% target stims 
                        if target_side % 1: left target 
                            left_trigger_out = 1;
                            right_trigger_out = 0;
                        else % 0: right target 
                            right_trigger_out = 1;
                            left_trigger_out = 0;
                        end
                        disp('Target')
                        disp(sessionTime)
                        was_target_out = 1;
                    end
                    % trigger a piezo  
                    state_out = 4; % go to lockout window
                    delay_out = sessionTime + 0.2;
                    disp('End of lockout')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    reward_trigger_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {4} %% lockout window 
                    % count licks 
                    if lick
                        numLicks_out = numLicks_in + 1;
                    else
                        numLicks_out = numLicks_in;
                    end
                    % determine next state
                    if numLicks_out
                        state_out = 7; % jump to reward collection (unrewarded)
                        delay_out = sessionTime + 2.0;
                    elseif sessionTime < delay_in 
                        state_out = state_in;
                        delay_out = delay_in;
                    else
                        state_out = 5; % response window
                        delay_out = sessionTime + 1.5;                     
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    reward_trigger_out = 0;
                    left_trigger_out = 0; % reset piezo targets 
                    right_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {5} %% response window 
                    % increment numLicks based on lickometer input 
                    if lick
                        numLicks_out = numLicks_in + 1;
                    else
                        numLicks_out = numLicks_in;
                    end

                    if sessionTime < delay_in
                        state_out = state_in;
                        delay_out = delay_in;
                    elseif numLicks_out && was_target_in
                        state_out = 6; % deliver reward
                        delay_out = delay_in;
                    else
                        state_out = 7; % reward collection (unrewarded)
                        delay_out = sessionTime + 0.5; 
                        disp('No response')
                        disp(left_trigger_in)
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in;
                    reward_trigger_out = 0;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {6} %% reward delivery 
                    % trigger reward 
                    reward_trigger_out = 1;
                    disp('Deliver Reward')
                    disp(sessionTime)
                    state_out = 7; % go to response window
                    delay_out = sessionTime + 0.5;
                    disp('Reward collection')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    right_trigger_out = right_trigger_in;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {7} %% reward collection
                    if sessionTime < delay_in
                        state_out = state_in;
                    else
                        state_out = 1; %start new trial
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                otherwise
                    state_out = state_in;
                    trialNum_out = trialNum_in;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
            end
        case {3} %% impulse control
            right_amp_out = 10 * right_amp_gain;
            left_amp_out = 10 * left_amp_gain;
            switch (state_in)         
                case {0} % LOAD SESSION PARAMS
                    rng('shuffle')
                    state_out = 1;
                    npxlsAcq_out=3.3;
                    trialNum_out = 0;
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = delay_in;
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                case {1} %% TRIAL START
                    npxlsAcq_out=npxlsAcq_in;
                    state_out = 2; % go to ITI
                    trialNum_out = 1;
                    % reset piezo triggers and lick counter
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    if ~was_target_in && ~numLicks_in 
                        disp('CR')
                        delay_out = sessionTime + negative_exp_rand(4,6);
                    else
                        delay_out = sessionTime + negative_exp_rand(8,12);
                    end
                    numLicks_out = 0;
                    disp('End of ITI')
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {2} %% inter-trial interval  
                    if sessionTime < delay_in
                        state_out = state_in; % continue with ITI 
                    else
                        state_out = 3; % go to stimulus 
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in; % keep piezo triggers 
                    left_trigger_out = left_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {3} %% stimulus onset 
                    if rand() <= (1-target_prob) % 70% distractor stims 
                        if target_side % 1: target left
                            right_trigger_out = 1;
                            left_trigger_out = 0;
                        else % 0: target right
                            left_trigger_out = 1;
                            right_trigger_out = 0;
                        end
                        disp('Distractor')
                        disp(sessionTime)
                        was_target_out = 0;
                    else % 30% target stims 
                        if target_side % 1: target left
                            left_trigger_out = 1;
                            right_trigger_out = 0;
                        else % 0: target right
                            right_trigger_out = 1;
                            left_trigger_out = 0;
                        end
                        disp('Target')
                        disp(sessionTime)
                        was_target_out = 1;
                    end
                    % trigger a piezo  
                    state_out = 4; % go to lockout window
                    delay_out = sessionTime + 0.2;
                    disp('End of lockout')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    reward_trigger_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {4} %% lockout window 
                    % count licks 
                    if lick
                        numLicks_out = numLicks_in + 1;
                    else
                        numLicks_out = numLicks_in;
                    end
                    % determine next state
                    if numLicks_out
                        state_out = 7; % jump to reward collection (unrewarded)
                        delay_out = sessionTime + 1.5;
                    elseif sessionTime < delay_in 
                        state_out = state_in;
                        delay_out = delay_in;
                    else
                        state_out = 5; % response window
                        delay_out = sessionTime + 1.0;                     
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    reward_trigger_out = 0;
                    left_trigger_out = 0;
                    right_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {5} %% response window 
                    % increment numLicks based on lickometer input 
                    if lick
                        numLicks_out = numLicks_in + 1;
                    else
                        numLicks_out = numLicks_in;
                    end

                    if sessionTime < delay_in
                        state_out = state_in;
                        delay_out = delay_in;
                    elseif numLicks_out && was_target_in
                        state_out = 6; % deliver reward
                        delay_out = delay_in;
                    else
                        state_out = 7; % reward collection (unrewarded)
                        delay_out = sessionTime + 0.5;
                        disp('No response')
                        disp(left_trigger_in)
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in;
                    reward_trigger_out = 0;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {6} %% reward delivery 
                    % trigger reward 
                    reward_trigger_out = 1;
                    disp('Deliver Reward')
                    disp(sessionTime)
                    state_out = 7; % go to response window
                    delay_out = sessionTime + 0.5;
                    disp('Reward collection')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    right_trigger_out = right_trigger_in;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {7} %% reward collection
                    if sessionTime < delay_in
                        state_out = state_in;
                    else
                        state_out = 1; %start new trial
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                otherwise
                    state_out = state_in;
                    trialNum_out = trialNum_in;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
            end
        case {4} %% simultaneous distractors
            switch (state_in)         
                case {0} % LOAD SESSION PARAMS
                    rng('shuffle')
                    state_out = 1;
                    npxlsAcq_out=3.3;
                    trialNum_out = 0;
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = delay_in;
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = 10 * right_amp_gain;
                    left_amp_out = 10 * left_amp_gain;
                case {1} %% TRIAL START
                    npxlsAcq_out=npxlsAcq_in;
                    state_out = 2; % go to ITI
                    trialNum_out = 1;
                    % reset piezo triggers and lick counter
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    if ~was_target_in && ~numLicks_in 
                        disp('CR')
                        delay_out = sessionTime + negative_exp_rand(4,6);
                    else
                        delay_out = sessionTime + negative_exp_rand(8,12);
                    end
                    numLicks_out = 0;
                    disp('End of ITI')
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = 10 * right_amp_gain;
                    left_amp_out = 10 * left_amp_gain;

                case {2} %% inter-trial interval  
                    if sessionTime < delay_in
                        state_out = state_in; % continue with ITI 
                    else
                        state_out = 3; % go to stimulus 
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in; % keep piezo triggers 
                    left_trigger_out = left_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = 10 * right_amp_gain;
                    left_amp_out = 10 * left_amp_gain;

                case {3} %% stimulus onset 
                    if rand() <= (1-target_prob) % 70% distractor stims 
                        if target_side % 1: target left
                            right_trigger_out = 1;
                            left_trigger_out = 1;
                            right_amp_out = 10 * right_amp_gain;
                            left_amp_out = 3 * left_amp_gain;
                        else % 0: target right
                            left_trigger_out = 1;
                            right_trigger_out = 1;
                            right_amp_out = 3 * right_amp_gain;
                            left_amp_out = 10 * left_amp_gain;
                        end
                        disp('Distractor')
                        disp(sessionTime)
                        was_target_out = 0;
                    else % 30% target stims 
                        if target_side % 1: target left
                            left_trigger_out = 1;
                            right_trigger_out = 1;
                            right_amp_out = 3 * right_amp_gain;
                            left_amp_out = 10 * left_amp_gain;
                        else % 0: target right
                            right_trigger_out = 1;
                            left_trigger_out = 1;
                            right_amp_out = 10 * right_amp_gain;
                            left_amp_out = 3 * left_amp_gain;
                        end
                        disp('Target')
                        disp(sessionTime)
                        was_target_out = 1;
                    end
                    % trigger a piezo  
                    state_out = 4; % go to lockout window
                    delay_out = sessionTime + 0.2;
                    disp('End of lockout')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    reward_trigger_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {4} %% lockout window 
                    % count licks 
                    if lick
                        numLicks_out = numLicks_in + 1;
                    else
                        numLicks_out = numLicks_in;
                    end
                    % determine next state
                    if numLicks_out
                        state_out = 7; % jump to reward collection (unrewarded)
                        delay_out = sessionTime + 1.5;
                    elseif sessionTime < delay_in 
                        state_out = state_in;
                        delay_out = delay_in;
                    else
                        state_out = 5; % response window
                        delay_out = sessionTime + 1.0;                     
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    reward_trigger_out = 0;
                    left_trigger_out = 0;
                    right_trigger_out = 0;
                    right_amp_out = right_amp_in;
                    left_amp_out = left_amp_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {5} %% response window 
                    % increment numLicks based on lickometer input 
                    if lick
                        numLicks_out = numLicks_in + 1;
                    else
                        numLicks_out = numLicks_in;
                    end

                    if sessionTime < delay_in
                        state_out = state_in;
                        delay_out = delay_in;
                    elseif numLicks_out && was_target_in
                        state_out = 6; % deliver reward
                        delay_out = delay_in;
                    else
                        state_out = 7; % reward collection (unrewarded)
                        delay_out = sessionTime + 0.5;
                        disp('No response')
                        disp(left_trigger_in)
                    end
                    right_amp_out = right_amp_in;
                    left_amp_out = left_amp_in;
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in;
                    reward_trigger_out = 0;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {6} %% reward delivery 
                    % trigger reward 
                    reward_trigger_out = 1;
                    disp('Deliver Reward')
                    disp(sessionTime)
                    state_out = 7; % go to response window
                    delay_out = sessionTime + 0.5;
                    disp('Reward collection')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    right_trigger_out = right_trigger_in;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = right_amp_in;
                    left_amp_out = left_amp_in;

                case {7} %% reward collection
                    if sessionTime < delay_in
                        state_out = state_in;
                    else
                        state_out = 1; %start new trial
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = right_amp_in;
                    left_amp_out = left_amp_in;

                otherwise
                    state_out = state_in;
                    trialNum_out = trialNum_in;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = right_amp_in;
                    left_amp_out = left_amp_in;
            end
        case {5} %% varying amplitudes 
            switch (state_in)         
                case {0} % LOAD SESSION PARAMS
                    rng('shuffle')
                    state_out = 1;
                    npxlsAcq_out=3.3;
                    trialNum_out = 0;
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = delay_in;
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = 0;
                    left_amp_out = 0;
                case {1} %% TRIAL START
                    npxlsAcq_out=npxlsAcq_in;
                    state_out = 2; % go to ITI
                    trialNum_out = 1;
                    % reset piezo triggers and lick counter
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    if ~was_target_in && ~numLicks_in 
                        disp('CR')
                        delay_out = sessionTime + negative_exp_rand(4,6);
                    else
                        delay_out = sessionTime + negative_exp_rand(8,12);
                    end
                    numLicks_out = 0;
                    disp('End of ITI')
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = 0;
                    left_amp_out = 0;

                case {2} %% inter-trial interval  
                    if sessionTime < delay_in
                        state_out = state_in; % continue with ITI 
                    else
                        state_out = 3; % go to stimulus 
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in; % keep piezo triggers 
                    left_trigger_out = left_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = 0;
                    left_amp_out = 0;

                case {3} %% stimulus onset 
                    if rand() <= (1-target_prob) % 70% distractor stims 
                        if target_side % 1: target left
                            right_trigger_out = 1;
                            left_trigger_out = 1;
                            if rand() <= 0.7
                                out = randi([7,10]);
                                right_amp_out = out * right_amp_gain;
                                left_amp_out = (10 - out) * left_amp_gain;
                            else
                                out = randi([5,6]);
                                right_amp_out = out * right_amp_gain;
                                left_amp_out = (10 - out) * left_amp_gain;
                            end
                        else % 0: target right
                            left_trigger_out = 1;
                            right_trigger_out = 1;
                            if rand() <= 0.7
                                out = randi([7,10]);
                                left_amp_out = out * left_amp_gain;
                                right_amp_out = (10 - out) * right_amp_gain;
                            else
                                out = randi([5,6]);
                                left_amp_out = out * left_amp_gain;
                                right_amp_out = (10 - out) * right_amp_gain;
                            end
                        end
                        disp('Distractor')
                        disp(sessionTime)
                        was_target_out = 0;
                    else % 30% target stims 
                        if target_side % 1: target left
                            left_trigger_out = 1;
                            right_trigger_out = 1;
                            if rand() <= 0.7
                                out = randi([7,10]);
                                left_amp_out = out * left_amp_gain;
                                right_amp_out = (10 - out) * right_amp_gain;
                            else
                                out = randi([5,6]);
                                left_amp_out = out * left_amp_gain;
                                right_amp_out = (10 - out) * right_amp_gain;
                            end
                        else % 0: target right
                            right_trigger_out = 1;
                            left_trigger_out = 1;
                            if rand() <= 0.7
                                out = randi([7,10]);
                                right_amp_out =  out * right_amp_gain;
                                left_amp_out = (10 - out) * left_amp_gain;
                            else
                                out = randi([5,6]);
                                right_amp_out = out * right_amp_gain;
                                left_amp_out = (10 - out) * left_amp_gain;
                            end
                        end
                        disp('Target')
                        disp(sessionTime)
                        was_target_out = 1;
                    end
                    % trigger a piezo  
                    state_out = 4; % go to lockout window
                    delay_out = sessionTime + 0.2;
                    disp('End of lockout')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    reward_trigger_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {4} %% lockout window 
                    % count licks 
                    if lick
                        numLicks_out = numLicks_in + 1;
                    else
                        numLicks_out = numLicks_in;
                    end
                    % determine next state
                    if numLicks_out
                        state_out = 7; % jump to reward collection (unrewarded)
                        delay_out = sessionTime + 1.5;
                    elseif sessionTime < delay_in 
                        state_out = state_in;
                        delay_out = delay_in;
                    else
                        state_out = 5; % response window
                        delay_out = sessionTime + 1.0;                     
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    reward_trigger_out = 0;
                    left_trigger_out = 0;
                    right_trigger_out = 0;
                    right_amp_out = right_amp_in;
                    left_amp_out = left_amp_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {5} %% response window 
                    % increment numLicks based on lickometer input 
                    if lick
                        numLicks_out = numLicks_in + 1;
                    else
                        numLicks_out = numLicks_in;
                    end

                    if sessionTime < delay_in
                        state_out = state_in;
                        delay_out = delay_in;
                    elseif numLicks_out && was_target_in
                        state_out = 6; % deliver reward
                        delay_out = delay_in;
                    else
                        state_out = 7; % reward collection (unrewarded)
                        delay_out = sessionTime + 0.5;
                        disp('No response')
                        disp(left_trigger_in)
                    end
                    right_amp_out = right_amp_in;
                    left_amp_out = left_amp_in;
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in;
                    reward_trigger_out = 0;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {6} %% reward delivery 
                    % trigger reward 
                    reward_trigger_out = 1;
                    disp('Deliver Reward')
                    disp(sessionTime)
                    state_out = 7; % go to response window
                    delay_out = sessionTime + 0.5;
                    disp('Reward collection')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    right_trigger_out = right_trigger_in;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = right_amp_in;
                    left_amp_out = left_amp_in;

                case {7} %% reward collection
                    if sessionTime < delay_in
                        state_out = state_in;
                    else
                        state_out = 1; %start new trial
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = right_amp_in;
                    left_amp_out = left_amp_in;

                otherwise
                    state_out = state_in;
                    trialNum_out = trialNum_in;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    right_amp_out = right_amp_in;
                    left_amp_out = left_amp_in;
            end
        case {6} %% posner-like switch
            right_amp_out = 10 * right_amp_gain;
            left_amp_out = 10 * left_amp_gain;
            switch (state_in)         
                case {0} % LOAD SESSION PARAMS
                    rng('shuffle')
                    state_out = 1;
                    npxlsAcq_out=3.3;
                    trialNum_out = 0;
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = delay_in;
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {1} %% TRIAL START
                    npxlsAcq_out=npxlsAcq_in;
                    state_out = 2; % go to ITI
                    trialNum_out = 1;
                    % reset piezo triggers and lick counter
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    if ~was_target_in && ~numLicks_in 
                        disp('CR')
                        delay_out = sessionTime + negative_exp_rand(4,6);
                    else
                        delay_out = sessionTime + negative_exp_rand(8,12);
                    end
                    numLicks_out = 0;
                    disp('End of ITI')
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {2} %% inter-trial interval  
                    if sessionTime < delay_in
                        state_out = state_in; % continue with ITI 
                    else
                        state_out = 3; % go to stimulus 
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in; % keep piezo triggers 
                    left_trigger_out = left_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {3} %% stimulus onset
                    if sessionTime < switch_time*60
                        if rand() <= (1-target_prob) % 80% distractor stims 
                            if target_side % 1: target left
                                right_trigger_out = 1;
                                left_trigger_out = 0;
                            else % 0: target right
                                left_trigger_out = 1;
                                right_trigger_out = 0;
                            end
                            disp('Distractor')
                            disp(sessionTime)
                            was_target_out = 0;
                        else % 20% target stims 
                            if target_side % 1: target left
                                left_trigger_out = 1;
                                right_trigger_out = 0;
                            else % 0: target right
                                right_trigger_out = 1;
                                left_trigger_out = 0;
                            end
                            disp('Target')
                            disp(sessionTime)
                            was_target_out = 1;
                        end
                    else
                        if rand() <= (1-target_prob) % 80% distractor stims 
                            if target_side % 1: target left
                                left_trigger_out = 1;
                                right_trigger_out = 0;
                            else % 0: target right
                                right_trigger_out = 1;
                                left_trigger_out = 0;
                            end
                            disp('Distractor')
                            disp(sessionTime)
                            was_target_out = 0;
                        else % 20% target stims 
                            if target_side % 1: target left
                                right_trigger_out = 1;
                                left_trigger_out = 0;
                            else % 0: target right
                                left_trigger_out = 1;
                                right_trigger_out = 0;
                            end
                            disp('Target')
                            disp(sessionTime)
                            was_target_out = 1;
                        end
                    end
                    % trigger a piezo  
                    state_out = 4; % go to lockout window
                    delay_out = sessionTime + 0.2;
                    disp('End of lockout')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    reward_trigger_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {4} %% lockout window 
                    % count licks 
                    if lick
                        numLicks_out = numLicks_in + 1;
                    else
                        numLicks_out = numLicks_in;
                    end
                    % determine next state
                    if numLicks_out
                        state_out = 7; % jump to reward collection (unrewarded)
                        delay_out = sessionTime + 1.5;
                    elseif sessionTime < delay_in 
                        state_out = state_in;
                        delay_out = delay_in;
                    else
                        state_out = 5; % response window
                        delay_out = sessionTime + 1.0;                     
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    reward_trigger_out = 0;
                    left_trigger_out = 0;
                    right_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {5} %% response window 
                    % increment numLicks based on lickometer input 
                    if lick
                        numLicks_out = numLicks_in + 1;
                    else
                        numLicks_out = numLicks_in;
                    end

                    if sessionTime < delay_in
                        state_out = state_in;
                        delay_out = delay_in;
                    elseif numLicks_out && was_target_in
                        state_out = 6; % deliver reward
                        delay_out = delay_in;
                    else
                        state_out = 7; % reward collection (unrewarded)
                        delay_out = sessionTime + 0.5;
                        disp('No response')
                        disp(left_trigger_in)
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    right_trigger_out = right_trigger_in;
                    reward_trigger_out = 0;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {6} %% reward delivery 
                    % trigger reward 
                    reward_trigger_out = 1;
                    disp('Deliver Reward')
                    disp(sessionTime)
                    state_out = 7; % go to response window
                    delay_out = sessionTime + 0.5;
                    disp('Reward collection')
                    disp(delay_out)
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    right_trigger_out = right_trigger_in;
                    left_trigger_out = left_trigger_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {7} %% reward collection
                    if sessionTime < delay_in
                        state_out = state_in;
                    else
                        state_out = 1; %start new trial
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                otherwise
                    state_out = state_in;
                    trialNum_out = trialNum_in;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    delay_out = delay_in;
                    reward_trigger_out = 0;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
            end
        case {111} % calibrate reward delivery 
            right_amp_out = 10 * right_amp_gain;
            left_amp_out = 10 * left_amp_gain;
            switch (state_in)         
                case {0} % LOAD SESSION PARAMS
                    rng('shuffle')
                    state_out = 1;
                    npxlsAcq_out=0;
                    trialNum_out = 1;
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = delay_in;
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {1} %% TRIAL START
                    npxlsAcq_out=npxlsAcq_in;
                    trialNum_out = 1;
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    delay_out = sessionTime + 1;
                    numLicks_out = 0;
                    disp(sessionTime)
                    reward_trigger_out = 1;
                    was_target_out = 0;
                    reward_duration_out = 0.03;
                    disp(reward_duration_out)
                    state_out = 2; % go to ITI
                    stim_duration_out = stim_duration_in;

                otherwise
                    if sessionTime < delay_in
                        state_out = state_in;
                        reward_trigger_out = 0;
                        delay_out = delay_in;
                        % reward_duration_out = (state_out-1) * 0.05;
                        reward_duration_out = 0.03;
                    else
                        state_out = state_in + 1; %start new trial
                        reward_trigger_out = 1;
                        delay_out = sessionTime + 1;
                        disp(sessionTime)
                        % reward_duration_out = state_out * 0.01;
                        reward_duration_out = 0.03;
                        disp(reward_duration_out)
                    end
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    left_trigger_out = left_trigger_in;
                    right_trigger_out = right_trigger_in;
                    numLicks_out = numLicks_in;
                    was_target_out = was_target_in;
                    stim_duration_out = stim_duration_in;
            end

        case {222} % piezo positioning, 1 target stim every 10 s
            right_amp_out = 10 * right_amp_gain;
            left_amp_out = 10 * left_amp_gain;
            switch (state_in)         
                case {0} % LOAD SESSION PARAMS
                    rng('shuffle')
                    state_out = 1;
                    npxlsAcq_out=0;
                    trialNum_out = 1;
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = delay_in;
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {1} %% TRIAL START
                    npxlsAcq_out=npxlsAcq_in;
                    trialNum_out = 1;
                    if target_side % 1: left target 
                        left_trigger_out = 1;
                        right_trigger_out = 0;
                    else % 0: right target 
                        right_trigger_out = 1;
                        left_trigger_out = 0;
                    end
                    delay_out = sessionTime + 1;
                    numLicks_out = 0;
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    state_out = 2; % go to ITI
                    stim_duration_out = stim_duration_in;
                    
                otherwise
                    if sessionTime < delay_in
                        state_out = state_in;
                        delay_out = delay_in;
                        left_trigger_out = 0;
                        right_trigger_out = 0;
                    else
                        state_out = state_in + 1; %start new trial
                        delay_out = sessionTime + 1;
                        if target_side % 1: left target 
                            left_trigger_out = 1;
                            right_trigger_out = 0;
                        else % 0: right target 
                            right_trigger_out = 1;
                            left_trigger_out = 0;
                        end
                    end
                    reward_trigger_out = 0;
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;
                    
            end
        otherwise %case {333} % piezo calibration, 1 target stim every 10 s
            % incrememnt duration by 0.05
            right_amp_out = 10 * right_amp_gain;
            left_amp_out = 10 * left_amp_gain;
            switch (state_in)         
                case {0} % LOAD SESSION PARAMS
                    rng('shuffle')
                    state_out = 1;
                    npxlsAcq_out=0;
                    trialNum_out = 1;
                    right_trigger_out = 0; % reset piezo triggers 
                    left_trigger_out = 0;
                    numLicks_out = 0;
                    delay_out = delay_in;
                    disp(delay_out)
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    reward_duration_out = reward_duration_in;
                    stim_duration_out = stim_duration_in;

                case {1} %% TRIAL START
                    npxlsAcq_out=npxlsAcq_in;
                    trialNum_out = 1;
                    if target_side % 1: target left
                        right_trigger_out = 1;
                        left_trigger_out = 0;
                    else % 0: target right
                        left_trigger_out = 1;
                        right_trigger_out = 0;
                    end
                    delay_out = sessionTime + 10;
                    numLicks_out = 0;
                    reward_trigger_out = 0;
                    was_target_out = 0;
                    stim_duration_out = 0.05;
                    state_out = 2; % go to ITI
                    reward_duration_out = reward_duration_in;
                    
                otherwise
                    if sessionTime < delay_in
                        state_out = state_in;
                        delay_out = delay_in;
                        left_trigger_out = 0;
                        right_trigger_out = 0;
                        stim_duration_out = 0.05 * (state_in-1);
                    else
                        state_out = state_in + 1; %start new trial
                        delay_out = sessionTime + 10;
                        if target_side % 1: target left
                            right_trigger_out = 1;
                            left_trigger_out = 0;
                        else % 0: target right
                            left_trigger_out = 1;
                            right_trigger_out = 0;
                        end
                        stim_duration_out = 0.05 * state_in;
                    end
                    reward_trigger_out = 0;
                    trialNum_out = trialNum_in + 1;
                    npxlsAcq_out=npxlsAcq_in;
                    numLicks_out = numLicks_in;
                    was_target_out = was_target_in;
                    reward_duration_out = reward_duration_in;
                   
            end
    end
end
