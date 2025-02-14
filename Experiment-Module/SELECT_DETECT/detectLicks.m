function [Lick, y1, y2, ADOut] = detectLicks(ADIn, Thrd, offset, x1, x2)

ADIn = abs(ADIn-offset);


if ADIn > Thrd
    y1 = x1+1;
else
    y1 = 0;
end

if (y1 > 5) && (x2==0)
    Lick =1;
    y2 = 1;
else
    Lick = 0;
    y2 = 0;
end
ADOut = ADIn;

end

% function [Lick, y1, y2, ADOut] = detectLicks(ADIn, Thrd, offset, x1, x2)
% %#codegen
% 
% 
% % if ADIn > 0
% %     ADIn = 0;
% % end
% ADIn = abs(ADIn-offset);
% 
% if x1 == 0
%     y1 = 0;
% end
% 
% 
% if ADIn > Thrd
%     y1 = x1+1;
%     y2 = x2;
% else
%     y1 = 0;
%     y2 = 0;
% end
% 
% % if (y1 > 5) && (x2 == 0) || ADIn > 0.021
% if ADIn > Thrd
%     Lick =1;
%     y2 = 1;
% else
%     Lick = 0;
% %    y2 = x2;
% end
% ADOut = ADIn;
% 
% end