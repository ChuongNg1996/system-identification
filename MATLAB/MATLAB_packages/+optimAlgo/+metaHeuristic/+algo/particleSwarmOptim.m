function [optimdInst,bestUnit,bestCostProg] = particleSwarmOptim(...
    trainIter,costFunc,popInst,trainInst,trainData)
    % Particle Swarm Optimization
    
    % --- Initialization --- % 
    
    % Properties of population
    popSize = popInst.popSize;
    itemSize = popInst.itemSize;
    itemDim = popInst.itemDim;
    dataLim = popInst.dataLim;
    unitRowDim = popInst.unitRowDim;
    unitColDim = popInst.unitColDim;
%     oneItemRowDim = popInst.oneItemRowDim;
%     oneItemColDim = popInst.oneItemColDim;
    unitOrient = popInst.unitOrient;
    
    % Cost Progression through Training
    bestCostProg = zeros(trainIter,1);
    
    % Velocity population
    velPopInst = optimAlgo.class.popClass(popSize,itemSize,itemDim,dataLim,unitOrient);
    
    % p best population
    pBestPop = optimAlgo.class.popClass(popSize,itemSize,itemDim,dataLim,unitOrient);
    pBestPop.popCost = Inf(size(pBestPop.popCost));
    
    % g best unit
    gBestCost = Inf;
%     gBestUnit = zeros(unitRowDim,unitColDim,1);
    
    % Coefficients of equation
    w = 0.7;                % inertia coefficient
    c1 = 0.5;               % cognitive parameter (0 <= c1 <= 2)
    c2 = 0.3;               % social parameter (0 <= c2 <= 2)
    % Limits for r1 & r2
    rMin = 0;
    rMax = 1;
    
    % --- End of Initialization --- %
    
    % --- Training Start --- % 
    for i = 1:trainIter
        
        % Evaluate cost of all units in popInst
        popInst.popCost = costFunc(popInst,trainInst,trainData);
        
        % Find and assign p best units
        betterUnitIndex = find(popInst.popCost < pBestPop.popCost);
        pBestPop.popData(:,:,betterUnitIndex) = popInst.popData(:,:,betterUnitIndex);
        pBestPop.popCost(betterUnitIndex,1) = popInst.popCost(betterUnitIndex,1);
        
        % Find and assign g best unit
        if min(pBestPop.popCost) < gBestCost
            [gBestCost,gBestIndex] = min(pBestPop.popCost);
            gBestUnit = pBestPop.popData(:,:,gBestIndex);
        end
        
        % Update velocity
        r1 = (rMax - rMin).*rand(unitRowDim,unitColDim,popSize) + rMin;
        r2 = (rMax - rMin).*rand(unitRowDim,unitColDim,popSize) + rMin;
%         r1 = (rMax - rMin)*rand(1) + rMin;
%         r2 = (rMax - rMin)*rand(1) + rMin;
        velPopInst.popData = w.*velPopInst.popData + c1*r1.*(pBestPop.popData - velPopInst.popData) + c2*r2.*(gBestUnit - velPopInst.popData);
        
        % Update position of population
        popInst.popData = popInst.popData + velPopInst.popData;
        
        % Assign gBestCost to bestCostProg
         bestCostProg(i,1) = gBestCost;
    end
    
    % Outputs
    optimdInst = pBestPop.popData;
    bestUnit = gBestUnit;
end

