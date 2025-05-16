addpath(genpath('./'))
addpath(genpath('~/circstat-matlab/'))
init_paths
sessionIDs

run_analysis = false; %% toggle to run analysis 
if run_analysis
    ksChanMap = load(strcat(subject_path, '3387-20240121/neuropixPhase3A_kilosortChanMap.mat'));
    phase_shift_3387 = alphaPhaseShiftAcrossProbe(expert_3387_session_ids, ksChanMap.chanMap, 285);
    phase_shift_3738 = alphaPhaseShiftAcrossProbe(expert_3738_session_ids, false, 285);
    phase_shift_3755 = alphaPhaseShiftAcrossProbe(expert_3755_session_ids, false, 300);
    phase_shift_1075 = alphaPhaseShiftAcrossProbe(expert_1075_session_ids, false, 180);

    [phase_shift_3387_Hit, ...
        phase_shift_3387_Miss, ...
        phase_shift_3387_FA, ...
        phase_shift_3387_CR] = ...
        alphaPhaseShiftAcrossProbeByOutcome(expert_3387_session_ids, ksChanMap.chanMap, 285);
    [phase_shift_3738_Hit, ...
        phase_shift_3738_Miss, ...
        phase_shift_3738_FA, ...
        phase_shift_3738_CR] = ...
        alphaPhaseShiftAcrossProbeByOutcome(expert_3738_session_ids, false, 285);
    [phase_shift_3755_Hit, ...
        phase_shift_3755_Miss, ...
        phase_shift_3755_FA, ...
        phase_shift_3755_CR] = ...
        alphaPhaseShiftAcrossProbeByOutcome(expert_3755_session_ids, false, 285);
    [phase_shift_1075_Hit, ...
        phase_shift_1075_Miss, ...
        phase_shift_1075_FA, ...
        phase_shift_1075_CR] = ...
        alphaPhaseShiftAcrossProbeByOutcome(expert_1075_session_ids, false, 180);
    channels = 1:4:385;

    out_file = 'phase_shift_results.mat';
    out = struct();
    out.phase_shift_1075 = phase_shift_1075;
    out.phase_shift_3755 = phase_shift_3755;
    out.phase_shift_3738 = phase_shift_3738;
    out.phase_shift_3387 = phase_shift_3387;
    out.phase_shift_1075_Hit = phase_shift_1075_Hit;
    out.phase_shift_3755_Hit = phase_shift_3755_Hit;
    out.phase_shift_3738_Hit = phase_shift_3738_Hit;
    out.phase_shift_3387_Hit = phase_shift_3387_Hit;
    out.phase_shift_1075_Miss = phase_shift_1075_Miss;
    out.phase_shift_3755_Miss = phase_shift_3755_Miss;
    out.phase_shift_3738_Miss = phase_shift_3738_Miss;
    out.phase_shift_3387_Miss = phase_shift_3387_Miss;
    out.phase_shift_1075_CR = phase_shift_1075_CR;
    out.phase_shift_3755_CR = phase_shift_3755_CR;
    out.phase_shift_3738_CR = phase_shift_3738_CR;
    out.phase_shift_3387_CR = phase_shift_3387_CR;
    out.phase_shift_1075_FA = phase_shift_1075_FA;
    out.phase_shift_3755_FA = phase_shift_3755_FA;
    out.phase_shift_3738_FA = phase_shift_3738_FA;
    out.phase_shift_3387_FA = phase_shift_3387_FA;

    save(out_file, 'out', '-v7.3');
else
    load phase_shift_results.mat
end

s1_phase_shifts = [out.phase_shift_3387; out.phase_shift_3738];
pfc_phase_shifts = [out.phase_shift_3755; out.phase_shift_1075];

fig = figure(); 
tl = tiledlayout(1,2);
axs(1) = nexttile;
hold on
% imagesc(mean(s1_phase_shifts)'); 
plot(mean(s1_phase_shifts), 1:length(s1_phase_shifts))
load(strcat(subject_path, '3738-20240702/regionMap_adjusted.mat'));
l6 = round(97 - find(contains(regMap.region, '6'), 1, 'last') / 4);
str_begin = round(97 - find(contains(regMap.region, 'CP'), 1, 'first') / 4);
str_end = round(97 - find(contains(regMap.region, 'STR'), 1, 'last') / 4);
amy_begin = round(97 - find(contains(regMap.region, 'LA'), 1, 'first') / 4);
amy_end = round(97 - find(contains(regMap.region, 'LA'), 1, 'last') / 4);
plot([-pi,pi], [l6,l6], 'k--')
plot([-pi,pi], [str_end,str_end], 'k--')
plot([-pi,pi], [amy_begin,amy_begin], 'k--')
yticks([mean([amy_end, amy_begin]), ...
    mean([str_end, str_begin]), ...
    mean([l6, 97])]);
yticklabels({'Amygdala', 'Striatum', 'S1'})
ylim([1,90])
xticks([-pi,0,pi])
xticklabels({'-\pi','0','\pi'})

axxs(2) = nexttile;
hold on
plot(mean(pfc_phase_shifts), 1:length(pfc_phase_shifts)); 
load(strcat(subject_path, '3755-20240828/regionMap.mat'));
ac_begin = round(97 - find(contains(regMap.region, 'AC'), 1, 'first') / 4);
ac_end = round(97 - find(contains(regMap.region, 'AC'), 1, 'last') / 4);
pl_begin = round(97 - find(contains(regMap.region, 'PL'), 1, 'first') / 4);
pl_end = round(97 - find(contains(regMap.region, 'PL'), 1, 'last') / 4);
il_begin = round(97 - find(contains(regMap.region, 'IL'), 1, 'first') / 4);
il_end = round(97 - find(contains(regMap.region, 'IL'), 1, 'last') / 4);
orb_begin = round(97 - find(contains(regMap.region, 'ORB'), 1, 'first') / 4);
orb_end = round(97 - find(contains(regMap.region, 'ORB'), 1, 'last') / 4);
dp_begin = round(97 - find(contains(regMap.region, 'DP'), 1, 'first') / 4);
dp_end = round(97 - find(contains(regMap.region, 'DP'), 1, 'last') / 4);
plot([-pi,pi], [ac_end,ac_end], 'k--')
plot([-pi,pi], [pl_begin,pl_begin], 'k--')
plot([-pi,pi], [il_begin,il_begin], 'k--')
plot([-pi,pi], [il_end,il_end], 'k--')
plot([-pi,pi], [orb_end,orb_end], 'k--')
plot([-pi,pi], [dp_end,dp_end], 'k--')
yticks([mean([1, dp_end]), ...
    mean([dp_end, dp_begin]), ...
    mean([orb_end, orb_begin]), ...
    mean([il_end, il_begin]), ...
    mean([pl_end, pl_begin]), ...
    mean([ac_end, ac_begin]), ...
    mean([ac_begin, 97])]);
yticklabels({'AON', 'DP', 'ORB', 'IL', 'PL', 'ACC', 'MO'})
set(gca, 'YDir', 'normal')
ylim([1,85])
xticks([-pi,0,pi])
xticklabels({'-\pi','0','\pi'})

mkdir('./Figures/')
saveas(fig, 'Figures/compare_avg_phase_shifts.fig');
saveas(fig, 'Figures/compare_avg_phase_shifts.svg');