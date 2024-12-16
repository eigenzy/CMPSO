function E = els(arch,xmax,xmin)
%   Elitist Learning Strategy for Multi-Objective PSO
%   Perform Gaussian perturbation on random dimension for each positon.   

sz = size(arch);
len = sz(1);
D = sz(2);
E = zeros(sz);

for i=1:len
    E(i,:) = arch(i,:);
    d = randi([1 D]);
    E(i,d) = sat(E(i,d) + normrnd(0,1)*(xmax(d) - xmin(d)),xmax(d),xmin(d));
end

end