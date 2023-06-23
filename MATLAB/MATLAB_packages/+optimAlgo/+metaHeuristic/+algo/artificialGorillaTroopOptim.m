%{
Paper: (2021) Artificial gorilla troops optimizer: A new nature-inspired 
metaheuristic algorithm for global optimization problems
DOI: https://doi.org/10.1002/int.22535
%}

function [optimdInst,bestUnit,bestCostProg] = artificialGorillaTroopOptim(...
    trainIter,costFunc,popInst,trainInst,trainData)
    % Artificial gorilla troops optimizer
    
    % --- Initialization --- % 
    
    % Properties of population
    popSize = popInst.popSize;
    itemSize = popInst.itemSize;
    itemDim = popInst.itemDim;
    dataLim = popInst.dataLim;
    unitRowDim = popInst.unitRowDim;
    unitColDim = popInst.unitColDim;
    oneItemRowDim = popInst.oneItemRowDim;
    oneItemColDim = popInst.oneItemColDim;
    unitOrient = popInst.unitOrient;
    
    % Cost Progression through Training
    bestCostProg = zeros(trainIter,1);
    
    % New instance of populationObject from optimizationAlgorithm packagage
    % GX is is the gorilla candidate position vector 
    GX = optimAlgo.class.popClass(popSize,itemSize,itemDim,dataLim,unitOrient);
    
    % Coefficients of equations
    p = (1 - 0)*rand(1)+0;      % eq 1
    W = 0.8;
    beta = 3;
    
    % --- End of Initialization --- %
    
    % --- Training Start --- % 
    
    % Evaluate cost of all units in popInst
    popInst.popCost = costFunc(popInst,trainInst,trainData);
    
    for i = 1:trainIter
        % Update a, C using eq 2 & 4 
        r4 = (1 - 0)*rand(1)+0;
        F = cos(2*r4)+1;
        C = F*(1-(i/trainIter));                % eq 2
        l = (1 - (-1))*rand(1)+(-1);
        L = C*l;                                % eq 4
        
        % Exploration phase
        % Go through whole population
        for unitIndex = 1:popSize
            
            % Update population positions with eq 1
            randnum = (1 - 0)*rand(1)+0;
            if randnum < p
                r1 = (1 - 0)*rand(unitRowDim,unitColDim)+0;
                GX.popData(:,:,unitIndex) = ...
                    optimAlgo.utils.randUnitWithRange(itemSize,...
                    unitRowDim,unitColDim,oneItemRowDim,oneItemColDim,...
                    unitOrient,dataLim).*r1;
                
            elseif randnum >= 0.5
                Z = (C - (-C))*rand(1)+(-C);    % eq 6
                H = Z.*popInst.popData(:,:,unitIndex);	% eq 7
                r2 = (1 - 0)*rand(1)+0;
                GX.popData(:,:,unitIndex) = (r2 - C).*...
                    popInst.popData(:,:,unitIndex) + L.*H;    % eq 8
                
            else
                randIndex = randi(popSize);
                r3 = (1 - 0)*rand(1)+0;
                GX.popData(:,:,unitIndex) = popInst.popData(:,:,unitIndex) - L.*(L.*...
                    (popInst.popData(:,:,unitIndex) - popInst.popData(:,:,randIndex)) +...
                    r3.*(popInst.popData(:,:,unitIndex) - popInst.popData(:,:,randIndex)));
            end
        end
        
        % Evaluate cost of all units in GX
        GX.popCost = costFunc(GX,trainInst,trainData);
        
        % Find unit indices with better cost in GX than popData
        betterUnitIndex = find(GX.popCost < popInst.popCost);
        
        % The replace better unit indices from popData with GX
        popInst.popData(:,:,betterUnitIndex) = GX.popData(:,:,betterUnitIndex);
        popInst.popCost(betterUnitIndex,1) = GX.popCost(betterUnitIndex,1);
        
        % Find the best cost assign it as the Silver Back
        [silverBackCost, silverBackIndex] = min(popInst.popCost);
        silverBackPos = popInst.popData(:,:,silverBackIndex);
        
        % Exploitation phase
        % Go through whole population
        for unitIndex = 1:popSize
            if C >= W
                % Update GX with eq 7
                g = 2^L;            % eq 9
                sum = zeros(oneItemRowDim,oneItemColDim);
                randIndex = randi(popSize,popSize,1);
                for j = 1:popSize
                    sum = sum + popInst.popData(:,:,randIndex(j));
                end
                M = (abs( (1/popSize).*sum  ).^g).^(1/g);
                GX.popData(:,:,unitIndex) = L.*M.*(popInst.popData(:,:,unitIndex)...
                    - silverBackPos) + popInst.popData(:,:,unitIndex);
            else
                % Update GX with eq 10
                randnum = (1 - 0)*rand(1)+0;
                
                
                if randnum >= 0.5   % eq 13
                    E = (popSize - (-popSize))*rand(1)+(-popSize);
                else
                    E = (1 - 0)*rand(1)+0;
                end
                
                A = beta*E;         % eq 12
                r5 = (1 - 0)*rand(1)+0;
                Q = 2*r5 - 1;       % eq 11
                GX.popData(:,:,unitIndex) = silverBackPos - ...
                    (silverBackPos.*Q-popInst.popData(:,:,unitIndex).*Q).*A;
            end
        end
        
        % Evaluate cost of all units in GX
        GX.popCost = costFunc(GX,trainInst,trainData);
        
        % Find unit indices with better cost in GX than popData
        betterUnitIndex = find(GX.popCost < popInst.popCost);
        
        % The replace better unit indices from popData with GX
        popInst.popData(:,:,betterUnitIndex) = GX.popData(:,:,betterUnitIndex);
        popInst.popCost(betterUnitIndex,1) = GX.popCost(betterUnitIndex,1);
        
        % Find the best cost assign it as the Silver Back
        [silverBackCost, silverBackIndex] = min(popInst.popCost);
        silverBackPos = popInst.popData(:,:,silverBackIndex);
        
        bestCostProg(i,1) = silverBackCost;
    end
    
    % --- Training End --- % 
    
    % Outputs
    optimdInst = popInst.popData;
    bestUnit = silverBackPos;
end

