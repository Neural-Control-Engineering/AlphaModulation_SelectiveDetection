function singleTrialLfps(lfp_data, trial_number, probe)
    lfp = lfp_data(trial_number,:).lfp{1};
    time = lfp_data(trial_number,:).left_trigger_aligned_lfp_time{1};
    lfp(end,:) = [];
    regions = unique(probe.regMap.region, 'stable');
    regions = regions(~strcmp(regions,'scwm') & ~strcmp(regions, 'or') & ~strcmp(regions, 'SSp-bfd6a') & ~strcmp(regions, 'SSp-bfd6b'));
    ys = linspace(3500,0,13);
    figure();
    hold on
    y_count = 1;
    for r = 1:length(regions)
        region = regions{r};
        tmp_lfp = lfp(strcmp(probe.regMap.region, region),:);
        region_y = cell2mat(probe.regMap.Y(strcmp(probe.regMap.region, region)));
        if strcmp(region, 'CP')
            % ys(y_count) = region_y(1);
            % y_labels{y_count} = region;
            % y_count = y_count + 1;
            % ys(y_count) = region_y(end);
            % y_labels{y_count} = region;
            % y_count = y_count + 1;
            x = round(linspace(1,size(tmp_lfp,1),5));
            for c = x(1:end-1)
                plot(time, (tmp_lfp(c,:)-mean(tmp_lfp(c,:)))*2e5 + ys(y_count), 'r')
                y_count = y_count + 1;
            end
        elseif strcmp(region, 'SSp-bfd5')
            % ys(y_count) = region_y(1);
            % y_labels{y_count} = region;
            % y_count = y_count + 1;
            % ys(y_count) = region_y(end);
            % y_labels{y_count} = region;
            % y_count = y_count + 1;
            x = round(linspace(1,size(tmp_lfp,1),3));
            for c = x(1:end-1)
                plot(time, (tmp_lfp(c,:)-mean(tmp_lfp(c,:)))*2e5 + ys(y_count), 'b')
                y_count = y_count + 1;
            end
        elseif strcmp(region, 'STR')
            % ys(y_count) = region_y(1);
            y_labels{y_count} = region;
            plot(time, (tmp_lfp(1,:)-mean(tmp_lfp(1,:)))*2e5 + ys(y_count), 'r')
            y_count = y_count + 1;
        elseif startsWith(region, 'SS')
            % ys(y_count) = region_y(1);
            y_labels{y_count} = region;
            plot(time, (tmp_lfp(1,:)-mean(tmp_lfp(1,:)))*2e5 + ys(y_count), 'b')
            y_count = y_count + 1;
        else
            % ys(y_count) = region_y(1);
            y_labels{y_count} = region;
            plot(time, (tmp_lfp(1,:)-mean(tmp_lfp(1,:)))*2e5 + ys(y_count), 'k')
            y_count = y_count + 1;
        end
    end
    % yticks([fliplr(ys)])
    % yticklabels(fliplr(y_labels))
    ylim([-100,3500])
    yticks([])
    xlim([-3,5])
    keyboard
end