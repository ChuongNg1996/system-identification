%{
Source: http://www.scholarpedia.org/article/Artificial_bee_colony_algorithm
%}

function [optimdInst,bestUnit,bestCostProg] = artificialBeeColonyOptim(...
    trainIter,costFunc,popInst,trainInst,trainData)
    % Artificial Bee Colony Algorithm
    
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
    
    % Size of each type of bee
    employedBeeRatio = 0.2;
    onlookerBeeRatio = 0.4;   
    
    employedBeeSize = round(employedBeeRatio*popSize);
    onlookerBeeSize = round(onlookerBeeRatio*popSize);
    scoutBeeSize = popSize - (employedBeeSize + onlookerBeeSize);
    
    % updated position of the bees
    vm = optimAlgo.class.popClass(employedBeeSize,itemSize,itemDim,dataLim,unitOrient);
    
    s = RandStream('mlfg6331_64');
    
    randIndexOnlookerBee = zeros(onlookerBeeSize,1);
    
    scoutRandMin = -2;
    scoutRandMax = -2;
    
    % theta
    % used for vmi = xmi + theta*(xmi-xki);
    thetaMin = -1;     
    thetaMax = 1;
    
    % --- End of Initialization --- %
    
    % --- Training Start --- % 
    
    % Evaluate cost of all units in popInst
    popInst.popCost = costFunc(popInst,trainInst,trainData);
    
    for i = 1:trainIter
         
         % Evaluate cost of all units in popInst
         popInst.popCost = costFunc(popInst,trainInst,trainData);
         
         % Categorize the population
         [sortedPopCost,sortedPopIndex] = sort(popInst.popCost);
        employedBeeIndex = sortedPopIndex(1:employedBeeSize,1);
        onlookerBeeIndex = sortedPopIndex((employedBeeSize+1):(employedBeeSize+onlookerBeeSize),1);
        scoutBeeIndex = sortedPopIndex((employedBeeSize+onlookerBeeSize+1):end,1);
        
        
        % update employed bees
        thetaVal = (thetaMax - thetaMin).*rand(unitRowDim,unitColDim,employedBeeSize)+thetaMin;
        randIndex = randi(popSize,employedBeeSize,1);
        vm.popData = popInst.popData(:,:,employedBeeIndex) +...
            thetaVal.*(popInst.popData(:,:,employedBeeIndex)-...
            popInst.popData(:,:,randIndex));
         
        % Evaluate vm, and replace better ones in popData
        vm.popCost = costFunc(vm,trainInst,trainData);
        betterUnitIndex = find(vm.popCost < popInst.popCost(1:employedBeeSize),1);
        popInst.popData(:,:,betterUnitIndex) = vm.popData(:,:,betterUnitIndex);
        popInst.popCost(betterUnitIndex,1) = vm.popCost(betterUnitIndex,1);
        
        % assign employed bees from popData to vm, for onlooker bees
        vm.popData = popInst.popData(:,:,1:employedBeeSize);
        
        % Probability of vm
        vmPickProb = costProb(vm);
        
        % Random indices with vmPickProb distribution
        % Need to upgrade to vectorization
        for j = 1:onlookerBeeSize
            randIndexOnlookerBee(j,1) = randsample(s,employedBeeSize,1,true,vmPickProb);
        end
        
        % Exploit employed bees for onlooker bees
        betterUnitIndex = find(popInst.popCost(onlookerBeeIndex,1) < popInst.popCost(randIndexOnlookerBee,1));
        popInst.popData(:,:,onlookerBeeIndex(betterUnitIndex)) = popInst.popData(:,:,randIndexOnlookerBee(betterUnitIndex));
        popInst.popCost(onlookerBeeIndex(betterUnitIndex),1) = popInst.popCost(randIndexOnlookerBee(betterUnitIndex),1);
        
        % Update scout bees
         popInst.popData(:,:,scoutBeeIndex) = ((scoutRandMax-scoutRandMin)*rand(1)+scoutRandMin).*popInst.popData(:,:,scoutBeeIndex);
        
         % Evaluate cost of all units in popInst
         popInst.popCost = costFunc(popInst,trainInst,trainData);
        [bestUnitCost, bestUnitIndex] = min(popInst.popCost);
         bestCostProg(i,1) = bestUnitCost;
    end
    
    % --- Training End --- % 
   
    
    % Outputs
    optimdInst = popInst.popData;
    bestUnit = popInst.popData(:,:,bestUnitIndex);
end

function pickProb = costProb(popInst)

    % Construct Probilities
    maxExtnRatio = 1.3;     % Extend upper limit in ratio, to reverse the 
                            % cost values in popCost, such that unit with 
                            % smaller cost has higher Probility to be
                            % picked.
                            
   	maxCostVal = max(popInst.popCost)*maxExtnRatio; 
    popCostRev = maxCostVal - popInst.popCost;
    popCostRevSum = sum(popCostRev);
    pickProb = popCostRev./popCostRevSum;
      
end
