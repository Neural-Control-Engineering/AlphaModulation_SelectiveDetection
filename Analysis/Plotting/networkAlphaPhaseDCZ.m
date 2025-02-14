sessionIDs;
% session_ids = horzcat(expert_3387_session_ids, expert_3738_session_ids);
load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Subjects/3738-20240702/regionMap.mat')


session_ids = horzcat(half_dcz_3387_session_ids, half_dcz_3738_session_ids);
ctx = [];
bg = [];
outcomes = {};
ctx_p = {};
bg_p = {};
sig_outcomes = {};
insig_outcomes = {};

for s = 1:length(session_ids)
    load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/AP/%s.mat', session_ids{s}));
    load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/%s.mat', session_ids{s}));
    [ctx_p_value, bg_p_value] = regionalAlphaPhase(ap_data, slrt_data, regMap);
    ctx_p_value = cell2mat(ctx_p_value);
    bg_p_value = cell2mat(bg_p_value);
    trial_outcomes = slrt_data.categorical_outcome;
    trial_outcomes = trial_outcomes(1:length(ctx_p_value));
    sig_trials = trial_outcomes(ctx_p_value < (0.05));
    insig_trials = trial_outcomes(ctx_p_value >= (0.05));
    sig_outcomes{s} = sig_trials;
    insig_outcomes{s} = insig_trials;
    ctx_p{s} = ctx_p_value;
    bg_p{s} = bg_p_value;
    num_sig(s) = length(sig_trials);
    num_insig(s) = length(insig_trials);
    if ~isempty(sig_trials)
        sig_hr(s) = (sum(strcmp(sig_trials, 'Hit'))+0.5)/(sum(strcmp(sig_trials, 'Hit'))+sum(strcmp(sig_trials, 'Miss'))+1.0);
        sig_far(s) = (sum(strcmp(sig_trials, 'FA'))+0.5)/(sum(strcmp(sig_trials, 'CR'))+sum(strcmp(sig_trials, 'FA'))+1.0);
        sig_dprime(s) = norminv(sig_hr(s)) - norminv(sig_far(s));
        sig_criterion(s) = -0.5 * (norminv(sig_hr(s)) + norminv(sig_far(s)));
    else
        sig_hr(s) = nan;
        sig_far(s) = nan;
        sig_dprime(s) = nan;
        sig_criterion(s) = nan;
    end
    insig_hr(s) = (sum(strcmp(insig_trials, 'Hit'))+0.5)/(sum(strcmp(insig_trials, 'Hit'))+sum(strcmp(insig_trials, 'Miss'))+1.0);
    insig_far(s) = (sum(strcmp(insig_trials, 'FA'))+0.5)/(sum(strcmp(insig_trials, 'CR'))+sum(strcmp(insig_trials, 'FA'))+1.0);
    insig_dprime(s) = norminv(insig_hr(s)) - norminv(insig_far(s));
    insig_criterion(s) = -0.5 * (norminv(insig_hr(s)) + norminv(insig_far(s)));
    ctx = [ctx; ctx_p_value];
    bg = [bg; bg_p_value];
    outcomes = vertcat(outcomes, trial_outcomes);
end

out = struct();
out.ctx = ctx;
out.bg = bg;
out.outcomes = outcomes;
out.sig_dprime = sig_dprime;
out.insig_dprime = insig_dprime;
out.sig_criterion = sig_criterion;
out.insig_criterion = insig_criterion;
out.sig_hr = sig_hr;
out.insig_hr = insig_hr;
out.sig_far = sig_far;
out.insig_far = insig_far;
out.num_sig = num_sig;
out.num_insig = num_insig;
out.ctx_p = ctx_p;
out.bg_p = bg_p;
out.sig_outcomes = sig_outcomes;
out.insig_outcomes = insig_outcomes;


save('half_dcz_network_p_values_mua.mat', 'out');

clear

% session_ids = horzcat(dcz_3387_session_ids, dcz_3738_session_ids);
% ctx = [];
% bg = [];
% outcomes = {};

% for s = 1:length(session_ids)
%     load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/AP/%s.mat', session_ids{s}));
%     load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/%s.mat', session_ids{s}));
%     [ctx_p_value, bg_p_value] = regionalAlphaPhase(ap_data, slrt_data, regMap);
%     ctx_p_value = cell2mat(ctx_p_value);
%     bg_p_value = cell2mat(bg_p_value);
%     trial_outcomes = slrt_data.categorical_outcome;
%     trial_outcomes = trial_outcomes(1:length(ctx_p_value));
%     sig_trials = trial_outcomes(ctx_p_value < (0.05/41));
%     insig_trials = trial_outcomes(ctx_p_value >= (0.05/41));
%     sig_hr(s) = (sum(strcmp(sig_trials, 'Hit'))+0.5)/(sum(strcmp(sig_trials, 'Hit'))+sum(strcmp(sig_trials, 'Miss'))+1.0);
%     insig_hr(s) = (sum(strcmp(insig_trials, 'Hit'))+0.5)/(sum(strcmp(insig_trials, 'Hit'))+sum(strcmp(insig_trials, 'Miss'))+1.0);
%     sig_far(s) = (sum(strcmp(sig_trials, 'FA'))+0.5)/(sum(strcmp(sig_trials, 'CR'))+sum(strcmp(sig_trials, 'FA'))+1.0);
%     insig_far(s) = (sum(strcmp(insig_trials, 'FA'))+0.5)/(sum(strcmp(insig_trials, 'CR'))+sum(strcmp(insig_trials, 'FA'))+1.0);
%     sig_dprime(s) = norminv(sig_hr(s)) - norminv(sig_far(s));
%     insig_dprime(s) = norminv(insig_hr(s)) - norminv(insig_far(s));
%     sig_criterion(s) = -0.5 * (norminv(sig_hr(s)) + norminv(sig_far(s)));
%     insig_criterion(s) = -0.5 * (norminv(insig_hr(s)) + norminv(insig_far(s)));
%     ctx = [ctx; ctx_p_value];
%     bg = [bg; bg_p_value];
%     outcomes = vertcat(outcomes, trial_outcomes);
% end

% out = struct();
% out.ctx = ctx;
% out.bg = bg;
% out.outcomes = outcomes;
% out.sig_dprime = sig_dprime;
% out.insig_dprime = insig_dprime;
% out.sig_criterion = sig_criterion;
% out.insig_criterion = insig_criterion;
% out.sig_hr = sig_hr;
% out.insig_hr = insig_hr;
% out.sig_far = sig_far;
% out.insig_far = insig_far;


% save('full_dcz_network_p_values.mat', 'out');
sessionIDs;
load('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Subjects/3738-20240702/regionMap.mat')
session_ids = horzcat(saline_3387_session_ids, saline_3738_session_ids);
ctx = [];
bg = [];
outcomes = {};
ctx_p = {};
bg_p = {};
sig_outcomes = {};
insig_outcomes = {};

for s = 1:length(session_ids)
    load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/AP/%s.mat', session_ids{s}));
    load(sprintf('/insomnia001/depts/neuralctrl/projects/nCORTEx/Project_Selective-Attention/Experiments/SELECT_DETECT/Data/EXT/SLRT/%s.mat', session_ids{s}));
    [ctx_p_value, bg_p_value] = regionalAlphaPhase(ap_data, slrt_data, regMap);
    ctx_p_value = cell2mat(ctx_p_value);
    bg_p_value = cell2mat(bg_p_value);
    trial_outcomes = slrt_data.categorical_outcome;
    trial_outcomes = trial_outcomes(1:length(ctx_p_value));
    sig_trials = trial_outcomes(ctx_p_value < (0.05));
    insig_trials = trial_outcomes(ctx_p_value >= (0.05));
    sig_outcomes{s} = sig_trials;
    insig_outcomes{s} = insig_trials;
    ctx_p{s} = ctx_p_value;
    bg_p{s} = bg_p_value;
    num_sig(s) = length(sig_trials);
    num_insig(s) = length(insig_trials);
    if ~isempty(sig_trials)
        sig_hr(s) = (sum(strcmp(sig_trials, 'Hit'))+0.5)/(sum(strcmp(sig_trials, 'Hit'))+sum(strcmp(sig_trials, 'Miss'))+1.0);
        sig_far(s) = (sum(strcmp(sig_trials, 'FA'))+0.5)/(sum(strcmp(sig_trials, 'CR'))+sum(strcmp(sig_trials, 'FA'))+1.0);
        sig_dprime(s) = norminv(sig_hr(s)) - norminv(sig_far(s));
        sig_criterion(s) = -0.5 * (norminv(sig_hr(s)) + norminv(sig_far(s)));
    else
        sig_hr(s) = nan;
        sig_far(s) = nan;
        sig_dprime(s) = nan;
        sig_criterion(s) = nan;
    end
    insig_hr(s) = (sum(strcmp(insig_trials, 'Hit'))+0.5)/(sum(strcmp(insig_trials, 'Hit'))+sum(strcmp(insig_trials, 'Miss'))+1.0);
    insig_far(s) = (sum(strcmp(insig_trials, 'FA'))+0.5)/(sum(strcmp(insig_trials, 'CR'))+sum(strcmp(insig_trials, 'FA'))+1.0);
    insig_dprime(s) = norminv(insig_hr(s)) - norminv(insig_far(s));
    insig_criterion(s) = -0.5 * (norminv(insig_hr(s)) + norminv(insig_far(s)));
    ctx = [ctx; ctx_p_value];
    bg = [bg; bg_p_value];
    outcomes = vertcat(outcomes, trial_outcomes);
end

out = struct();
out.ctx = ctx;
out.bg = bg;
out.outcomes = outcomes;
out.sig_dprime = sig_dprime;
out.insig_dprime = insig_dprime;
out.sig_criterion = sig_criterion;
out.insig_criterion = insig_criterion;
out.sig_hr = sig_hr;
out.insig_hr = insig_hr;
out.sig_far = sig_far;
out.insig_far = insig_far;
out.num_sig = num_sig;
out.num_insig = num_insig;
out.ctx_p = ctx_p;
out.bg_p = bg_p;
out.sig_outcomes = sig_outcomes;
out.insig_outcomes = insig_outcomes;

save('saline_network_p_values_mua.mat', 'out');