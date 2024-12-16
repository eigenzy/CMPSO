function EF = cone_ef(pos,swarms)
% Multi-objective optimization problem
% https://www.math.unipd.it/~marcuzzi/DIDATTICA/LEZ&ESE_PIAI_Matematica/3_cones.pdf
sz = size(pos);
len = sz(1);
EF = zeros(len,swarms);
for i = 1:len
    r = pos(i,1);
    h = pos(i,2);
    s = sqrt(r^2+h^2);
    V = pi/3*r^2*h;
    B = pi*r^2;
    S = pi*r*s;
    T = B+S;
    if V<200
        EF(i,:) = inf(1,swarms);
    else
        EF(i,:) = [S,T];
    end

end
