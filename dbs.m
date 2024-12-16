function [S,Efout] = dbs(R,swarms,NA,EF)
%   density based selection for multi-objective PSO

len = size(R,1);
distance = zeros(len,1);
EF = abs(EF);

for m=1:swarms

    % sort R according to mth objective value
    [~,idx] = sort(EF(:,m),'ascend');
    
    % Assign smallest and largest mth evaluations to a "large" distance 
    distance(idx([1,end])) = distance(idx([1,end]))+1e6;

    % The distance of the other solutions is increased by the absolute normalized difference of the objective values between the two adjacent solutions
    for j=2:len-1
        distance(idx(j)) = distance(idx(j)) + (EF(idx(j+1),m)-EF(idx(j-1),m))/(EF(idx(end),m)-EF(idx(1),m));
    end
end

[~,idx_dist] = sort(distance,'descend');
S = R(idx_dist(1:NA),:);
Efout = EF(idx_dist(1:NA),:);

end
