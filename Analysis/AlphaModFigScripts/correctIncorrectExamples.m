init_paths;
s1_path = strcat(ftr_path, 'AP/FIG/S1_Expert_Combo_Adjusted/Cortex/Spontaneous_Alpha_Modulation/');
pfc_path = strcat(ftr_path, 'AP/FIG/PFC_Expert_Combo_Adjusted/PFC/Spontaneous_Alpha_Modulation/');

example_file = strcat(s1_path, 'Correct_vs_Incorrect/date--2024-02-15_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0_cluster_207.fig');
fig = openfig(example_file);
unifyYLimits(fig);
saveas(fig, '../Figures/correct_incorrect_example1.svg')
saveas(fig, '../Figures/correct_incorrect_example1.fig')
close()
example_file = strcat(s1_path, 'Action_vs_Inaction/date--2024-02-15_subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0_cluster_207.fig');
fig = openfig(example_file);
unifyYLimits(fig);
saveas(fig, '../Figures/action_inaction_example1.svg')
saveas(fig, '../Figures/action_inaction_example1.fig')
close()

example_file = strcat(s1_path, 'Correct_vs_Incorrect/date--2024-07-13_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0_cluster_254.fig');
fig = openfig(example_file);
unifyYLimits(fig);
saveas(fig, '../Figures/correct_incorrect_example2.svg')
saveas(fig, '../Figures/correct_incorrect_example2.fig')
close()
example_file = strcat(s1_path, 'Action_vs_Inaction/date--2024-07-13_subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0_cluster_254.fig');
fig = openfig(example_file);
unifyYLimits(fig);
saveas(fig, '../Figures/action_inaction_example2.svg')
saveas(fig, '../Figures/action_inaction_example2.fig')
close()

example_file = strcat(pfc_path, 'Correct_vs_Incorrect/date--2024-09-07_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0_cluster_146.fig');
% example_file = strcat(pfc_path, 'Correct_vs_Incorrect/date--2024-09-07_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0_cluster_282.fig');
% example_file = strcat(pfc_path, 'Correct_vs_Incorrect/date--2024-12-20_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0_cluster_122.fig');
fig = openfig(example_file);
unifyYLimits(fig);
set(fig, 'Visible', 'on')
saveas(fig, '../Figures/correct_incorrect_example3.svg')
saveas(fig, '../Figures/correct_incorrect_example3.fig')
close()
example_file = strcat(pfc_path, 'Action_vs_Inaction/date--2024-09-07_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0_cluster_146.fig');
% example_file = strcat(pfc_path, 'Action_vs_Inaction/date--2024-09-07_subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0_cluster_282.fig');
% example_file = strcat(pfc_path, 'Action_vs_Inaction/date--2024-12-20_subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0_cluster_122.fig');
fig = openfig(example_file);
unifyYLimits(fig);
% set(fig, 'Visible', 'on')
saveas(fig, '../Figures/action_inaction_example3.svg')
saveas(fig, '../Figures/action_inaction_example3.fig')
close()
