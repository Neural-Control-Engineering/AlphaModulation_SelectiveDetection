function out = semshade(amatrix,alpha,acolor,linecolor,F,smth,name)
% usage: stdshading(amatrix,alpha,acolor,F,smth)
% plot mean and sem/std coming from a matrix of data, at which each row is an
% observation. sem/std is shown as shading.
% - acolor defines the used color (default is red) 
% - F assignes the used x axis (default is steps of 1).
% - alpha defines transparency of the shading (default is no shading and black mean line)
% - smth defines the smoothing factor (default is no smooth)
% smusall 2010/4/23

if exist('acolor','var')==0 || isempty(acolor)
    acolor='r'; 
end

if exist('linecolor','var')==0 || isempty(linecolor)
    linecolor='k'; 
end

if exist('F','var')==0 || isempty(F)
    F=1:size(amatrix,2);
end

if exist('smth','var'); if isempty(smth); smth=1; end
else smth=1;
end

if ne(size(F,1),1)
    F=F';
end

amean=smooth(nanmean(amatrix),smth)';
% astd=nanstd(amatrix); % to get std shading
astd=nanstd(amatrix)/sqrt(sum(~isnan(amatrix(:,1)))); % to get sem shading

if exist('alpha','var')==0 || isempty(alpha) 
    out = fill([F fliplr(F)],[amean+astd fliplr(amean-astd)],acolor,'linestyle','none', 'HandleVisibility','off');
else
    out = fill([F fliplr(F)],[amean+astd fliplr(amean-astd)],acolor, 'FaceAlpha', alpha,'linestyle','none', 'HandleVisibility','off');
end

if ishold==0
    check=true; else check=false;
end

hold on;
if exist('name', 'var')
    plot(F,amean,'Color', linecolor,'linewidth',2, 'DisplayName', name); %% change color or linewidth to adjust mean line
else
    plot(F,amean,'Color', linecolor,'linewidth',2);
end

if check
    hold off;
end

end



