%% s1 sessions
% combine animals
ftr_files = {strcat(ftr_path, '/AP/subj--3387-20240121_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_adjusted.mat'), ...
    strcat(ftr_path, '/AP/subj--3738-20240702_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_adjusted.mat')};
for i = 1:length(ftr_files)
    f = load(ftr_files{i});
    if i == 1
        ftrs = f.ap_ftr;
    else
        ftrs = combineTables(ftrs, f.ap_ftr);
    end
end
S1 = ftrs(startsWith(ftrs.region, 'SS'),:);
striatum_inds = strcmp(ftrs.region, 'STR') + strcmp(ftrs.region, 'CP');
Striatum = ftrs(logical(striatum_inds), :);
amygdala_inds = strcmp(ftrs.region, 'BLAp') + strcmp(ftrs.region, 'LA');
Amygdala = ftrs(logical(amygdala_inds), :);

ftr_files = {strcat(ftr_path, '/AP/subj--3755-20240828_geno--Dbh-Cre-x-Gq-DREADD_npxls--R-npx10_phase--phase3_g0.mat'), ...
    strcat(ftr_path, '/AP/subj--1075-20241202_geno--Wt_npxls--R-npx10_phase--phase3_g0.mat')};
for i = 1:length(ftr_files)
    f = load(ftr_files{i});
    if i == 1
        ftrs = f.ap_ftr;
    else
        ftrs = combineTables(ftrs, f.ap_ftr);
    end
end
pfc_inds = startsWith(ftrs.region, 'DP') + startsWith(ftrs.region, 'AC') ...
    + startsWith(ftrs.region, 'PL') + startsWith(ftrs.region, 'IL') ...
    + startsWith(ftrs.region, 'OR');
pfc_inds = logical(pfc_inds);
PFC = ftrs(pfc_inds,:);

S1 = S1(cell2mat(S1.avg_trial_fr) > 1.0,:);
PFC = PFC(cell2mat(PFC.avg_trial_fr) > 1.0,:);
Striatum = Striatum(cell2mat(Striatum.avg_trial_fr) > 1.0,:);
Amygdala = Amygdala(cell2mat(Amygdala.avg_trial_fr) > 1.0,:);

p_values = vertcat(cell2mat(S1.p_value_alpha), cell2mat(PFC.p_value_alpha), cell2mat(Amygdala.p_value_alpha), cell2mat(Striatum.p_value_alpha));
p_values = sort(p_values);
count = 1;
alpha = 0.01;
while p_values(count) <= (count/(length(p_values)) * alpha)
    count = count + 1;
end
fprintf(sprintf('Benjamini/Hochberg adjusted p-value: %d\m', p_values(count-1)))