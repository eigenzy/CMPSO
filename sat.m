function y = sat(variable,upperlimit,lowerlimit)
% Limit a vector or matrix 'variable' to the vectors 'upperlimit' and
% 'lowerlimit'

% Ensure that all inputs are of the same column size, 
% Thus, limits are row vectors

y=zeros(size(variable));

limsize = size(upperlimit);
D = limsize(2);

varsize = size(variable);
len = varsize(1); varD = varsize(2);

if D~=varD
    fprintf('incompatible column size')
end

% Saturate each row in "variable"
for i=1:len
    for d=1:D
        if variable(i,d)>=upperlimit(d)
            y(i,d)=upperlimit(d);
        elseif variable(i,d)<=lowerlimit(d)
            y(i,d)=lowerlimit(d);
        else
            y(i,d)=variable(i,d);
        end
    end
end

end