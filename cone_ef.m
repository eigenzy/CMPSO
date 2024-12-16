function EF = cone_ef(pos,swarms)
% Multi-objective optimization problem
% https://www.math.unipd.it/~marcuzzi/DIDATTICA/LEZ&ESE_PIAI_Matematica/3_cones.pdf

len = size(pos,1);
EF = zeros(len,swarms);

for i = 1:len
    % In this case, pos = [r,h]
    r = pos(i,1);
    h = pos(i,2);

    % Formulate evaluation of position
    s = sqrt(r^2+h^2);
    V = pi/3*r^2*h;
    B = pi*r^2;
    S = pi*r*s;
    T = B+S;
    EF(i,:) = [S,T]; % Minimize [S,T] (2 objectives)

    % Constraint: V<200 assign infinite evaluation, i.e. invalid evaluation.
    if V<200
        EF(i,:) = inf(1,swarms);
    end

end
