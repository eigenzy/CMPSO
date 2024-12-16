function [R,EFout] = nondom_sol(pos,EF)
%   Non-dominated solutions determining algorithm for Multi-Objective PSO
%   Non-dominated solutions excel in at least ONE objective when compared
%   to other solutions

len = size(pos,1);
tempR = [];
tempEF = [];

if size(pos,1)~=size(EF,1)
    fprintf('incompatible lengths')
end

for i=1:len
    flag = 1;
    EFi = abs(EF(i,:));
    for j=1:len
        EFj = abs(EF(j,:));
        if  i~=j && all(EFj<=EFi) && all(EFj~=EFi) 
            flag = 0;
            break;
        end
    end
    if flag == 1
        tempR = cat(1,tempR,pos(i,:));
        tempEF = cat(1,tempEF,EF(i,:));
    end
end

% Obtain unique solutions only
[R,idx_unique] = unique(tempR,'rows');
EFout = tempEF(idx_unique,:);
end