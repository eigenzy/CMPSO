clear;clc;
%% Problem Definition
var = 2;                % Number of optimization variables
varsize = [1 var];      % Row vector form of solution
swarms = 2;             % Number of objectives
NA = 100;               % Max Archive size

%Search Space
xmax = [10 20];
xmin = zeros(varsize);

% Limit Velocity to 20%-25% of search space
vlim = 0.25*(xmax-xmin);

%% Parameters of PSO

iterations = 20;            %Number of iterations
particles = 20;             %Population Size

% Inertia decreases each iteration

wmin = 0.4;                 %Max Inertia Coefficient
wmax = 0.9;                 %Min Inertia Coefficient

% Acceleration Coefficients
co1 = 4/3;                  % Personal Acceleration Coeff
co2 = 4/3;                  % Social Acceleration Coeff
co3 = 4/3;                  % Archive Acceleration Coeff
%% Initialization

% Assign evaluation function
Eval = @cone_ef;

%Particle Template
empty_particle.Position = [];
empty_particle.Velocity = [];
empty_particle.EF = [];
empty_particle.BestPosition = [];
empty_particle.BestEF = [];
empty_particle.BP_EF = [];

%Create population
particle = repmat(empty_particle,particles,swarms);

%Initialize Global Best
GlobalBestEF = inf*ones(swarms,1);
GlobalBestPos = zeros*ones(swarms,var);

% Hold best EF at each iteration
BestEF = zeros(iterations,swarms);

Archive = zeros(swarms*particles,var);
ArchEF = zeros(swarms*particles,swarms);
BP = [];
BP_EF = [];
wasemptyArch = 0;

%% Initialisation
for swarm = 1:swarms
    for i = 1:particles

        %Randomize initial positions (solutions)
        particle(i,swarm).Position = unifrnd(xmin, xmax, varsize);

        %Initialize velocity
        particle(i,swarm).Velocity = zeros(varsize);%normrnd(0,1,varsize);

        %Evaluation
        EF = Eval(particle(i,swarm).Position,swarms);

        % Update Particle's Evaluation
        particle(i,swarm).EF = EF(swarm);
        particle(i,swarm).BestEF = EF(swarm);
        particle(i,swarm).BestPosition = particle(i,swarm).Position;
        particle(i,swarm).BP_EF = EF;
        Archive(i+(swarm-1)*particles,:) = particle(i,swarm).Position;
        ArchEF(i+(swarm-1)*particles,:) = EF;

        %Update Global Best
        if abs(particle(i,swarm).BestEF) < abs(GlobalBestEF(swarm))
            GlobalBestPos(swarm,:) = particle(i,swarm).BestPosition;
            GlobalBestEF(swarm) = particle(i,swarm).BestEF;
        end
    end
end

% Perform Elitist-Learning Strategy
ELS = [els(Archive,xmax,xmin)]; ELS_EF = Eval(ELS,swarms);
Archive = cat(1,Archive,ELS); ArchEF = cat(1,ArchEF,ELS_EF);

% Omit any invalid evaluations
[idx,~] = find(ArchEF==inf);
Archive(idx,:) = [];
ArchEF(idx,:) = [];

% Return non-dominated solutions only
[Archive,ArchEF] = nondom_sol(Archive,ArchEF);

if size(Archive,1)>NA
    [Archive,ArchEF] = dbs(Archive,swarms,NA,ArchEF);
end

% Display first result
if ~isempty(ArchEF)
    disp(['Initialisation: ArchEF (1): ' mat2str(ArchEF(1,:),4)]);
else
    disp('Initialisation is empty');
end
disp(' ');

%% Main Loop of PSO

for it = 1:iterations
    w = wmax - ((wmax-wmin)/iterations)*it;
    for swarm = 1:swarms
        for i = 1:particles

            % Check Archive size and assign index
            arch_size = size(Archive,1);
            if arch_size==0
                g_rand = swarm;
                while g_rand==swarm
                    g_rand = randi([1,swarms]);
                end
                Archive = GlobalBestPos(g_rand,:);
                ArchEF = Eval(Archive,swarms);
                arch_idx = 1;
                wasemptyArch = 1;
            elseif arch_size==1
                arch_idx = 1;
            else
                arch_idx = randi([1,arch_size]);
            end

            %Update Velocity
            particle(i,swarm).Velocity = w*particle(i,swarm).Velocity ...
                + co1*rand(varsize).*(particle(i,swarm).BestPosition - particle(i,swarm).Position) ...
                + co2*rand(varsize).*(GlobalBestPos(swarm,:) - particle(i,swarm).Position) ...
                + co3*rand(varsize).*(Archive(arch_idx,:) - particle(i,swarm).Position);

            particle(i,swarm).Velocity = sat(particle(i,swarm).Velocity,vlim,-vlim);

            %Update Position
            particle(i,swarm).Position = particle(i,swarm).Position + particle(i,swarm).Velocity;

            %Apply Lower & Upper Bound Limits
            particle(i,swarm).Position = sat(particle(i,swarm).Position, xmax,xmin);

            %Evaluation
            EF = Eval(particle(i,swarm).Position,swarms);

            % update
            particle(i,swarm).EF = EF(swarm);
            
            % Update Personal Best
            if abs(particle(i,swarm).EF) < abs(particle(i,swarm).BestEF)
                particle(i,swarm).BestPosition = particle(i,swarm).Position;
                particle(i,swarm).BestEF = particle(i,swarm).EF;
                BP_EF = cat(1,BP_EF,EF);
            else
                BP_EF = cat(1,BP_EF,particle(i,swarm).BP_EF);
            end

            %Update Global Best
            if abs(particle(i,swarm).BestEF) < abs(GlobalBestEF(swarm))
                GlobalBestPos(swarm,:) = particle(i,swarm).BestPosition;
                GlobalBestEF(swarm) = particle(i,swarm).BestEF;
            end
        end

        %Store Best EF
        BestEF(it,swarm) = GlobalBestEF(swarm,:);
    end

    % Add personal best positions and EFs to Archive
    BP = reshape([particle(:,:).BestPosition],var,[])';
    Archive = cat(1,Archive,BP);
    ArchEF = cat(1,ArchEF,BP_EF);
    BP_EF = [];

    % Perfrom ELS
    ELS = els(Archive,xmax,xmin); ELS_EF = Eval(ELS,swarms);

    % Assemble ELS with Archive
    Archive = cat(1,Archive,ELS); ArchEF = cat(1,ArchEF,ELS_EF);

    [idx,~] = find(ArchEF==inf);
    Archive(idx,:) = [];
    ArchEF(idx,:) = [];

    % Apply non-dominated determinator
    [Archive,ArchEF] = nondom_sol(Archive,ArchEF);

    % Check size and apply DBS if size has exceeded
    if size(Archive,1)>NA
        [Archive,ArchEF] = dbs(Archive,swarms,NA,ArchEF);
    end

    % Display First 3 Archive Positions and their evaluations
    if ~isempty(Archive)
        for z = 1:min([size(Archive,1),3])
            disp(['Iteration: ' num2str(it) ' Archive ' num2str(z) ' = ' mat2str(Archive(z,:),3)]);
            disp(['Iteration: ' num2str(it) ' ArchEF ' num2str(z) ' = ' mat2str(ArchEF(z,:),4)]); 
            disp(' ');
        end
    else
        disp(['Iteration: ' num2str(it) ' is empty']);
    end
    disp(' ');
end

%% Plot
figure(1);
plot(ArchEF(:,1),ArchEF(:,2))
xlabel('S')
ylabel('T')
title('Pareto Front')