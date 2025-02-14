function out = regionAcronymToName(acronym, probe)
    out = probe.probe_areas{1}.name{strcmp(probe.probe_areas{1}.acronym, acronym)};
end