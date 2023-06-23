%{
Paper: (2019) Novel Adaptive Control Method for BLCD Drive of ElectricBike 
% for Vietnam EnvironmenT
DOI: 10.1088/1757-899X/819/1/012017
%}

function [optimdInst,bestUnit,bestCostProg] = geneticAlgoOptim(...
    trainIter,costFunc,popInst,trainInst,trainData)
    % Genetic Algorithm Optimization
    
    % --- Initialization --- % 
    
    % Properties of population
%     popSize = popInst.popSize;
%     itemSize = popInst.itemSize;
%     itemDim = popInst.itemDim;
%     dataLim = popInst.dataLim;
%     unitRowDim = popInst.unitRowDim;
%     unitColDim = popInst.unitColDim;
%     oneItemRowDim = popInst.oneItemRowDim;
%     oneItemColDim = popInst.oneItemColDim;
%     unitOrient = popInst.unitOrient;
    
    % Cost Progression through Training
    bestCostProg = zeros(trainIter,1);
    
    % Parents' Indices for genetic algorithms
%     parentPopIndex = zeros(popSize,2);
    
    % Cross-over Probility
    crossProb = 0.4;
    
    % Mutation
    mutationSizeRatio = 0.15;
    mutationSize = round(mutationSizeRatio*popInst.popSize);
    mutationLim = [0.5 1.5];
    mutationProb = 0.5;
    
    % Random stream
    s = RandStream('mlfg6331_64');
    
    % --- End of Initialization --- %
    
    % --- Training Start --- % 
    for i = 1:trainIter
        
        % Evaluate cost of all units in popInst
        popInst.popCost = costFunc(popInst,trainInst,trainData);
        
        % Choose parents
        parentPopIndex = parentsRouletteWheel(popInst,s);
        
        % Cross-over
        popInst = parentCrossOver(popInst,parentPopIndex,crossProb,s);
        
        % Evaluate cost of all units in popInst
        popInst.popCost = costFunc(popInst,trainInst,trainData);
        
        % Mutation
        popInst = Mutation(popInst,mutationProb,mutationSize,mutationLim,s);
        
        % Evaluate cost of all units in popInst
        popInst.popCost = costFunc(popInst,trainInst,trainData);
       [bestUnitCost, bestUnitIndex] = min(popInst.popCost);
        bestCostProg(i,1) = bestUnitCost;
    end
    
    % Outputs
    optimdInst = popInst.popData;
    bestUnit = popInst.popData(:,:,bestUnitIndex);
end

function parentPopIndex = parentsRouletteWheel(popInst,s)

    % Construct Probilities
    maxExtnRatio = 1.3;     % Extend upper limit in ratio, to reverse the 
                            % cost values in popCost, such that unit with 
                            % smaller cost has higher Probility to be
                            % picked.
                            
   	maxCostVal = max(popInst.popCost)*maxExtnRatio; 
    popCostRev = maxCostVal - popInst.popCost;
    popCostRevSum = sum(popCostRev);
    pickProb = popCostRev./popCostRevSum;
    
    % Pick parents
    parentPopIndex = zeros(popInst.popSize,2);
    
    for unitIndex = 1:popInst.popSize
        parentOneIndex = randsample(s,popInst.popSize,1,true,pickProb);
        parentPopIndex(unitIndex,1) = parentOneIndex;
        parentTwoIndex = randsample(s,popInst.popSize,1,true,pickProb);
        parentPopIndex(unitIndex,2) = parentTwoIndex;
    end
    
end

function popInst = parentCrossOver(popInst,parentPopIndex,crossProb,s)

    % Create a temporary population
    tempPop = popInst;
    
    % Access each element
    for unitIndex = 1:popInst.popSize
        for unitRow = 1:popInst.unitRowDim
            for unitCol = 1:popInst.unitColDim
                
                % Decide whether or not to do cross-over
                crossOverPoll = randsample(s,[0 1],1,true,[(1-crossProb) crossProb]);
                switch crossOverPoll
                    case 1
                        parentUnitIndex = parentPopIndex(unitIndex,1);
                    otherwise
                        parentUnitIndex = parentPopIndex(unitIndex,2);
                end
                tempPop.popData(unitRow,unitCol,unitIndex) = popInst.popData(unitRow,unitCol,parentUnitIndex);
            end
        end
    end
    
    % Assign temporary population to current population
    popInst = tempPop;
end

function popInst = Mutation(popInst,mutationProb,mutationSize,mutationLim,s)
    
    % sort the cost from highest to lowest
    [sortedPopCost,sortedPopIndex] = sort(popInst.popCost);
    
    for sortedUnitIndex = 1:mutationSize
        unitIndex = sortedPopIndex(sortedUnitIndex);
        
        % Decide whether or not to mutate
        mutationPoll = randsample(s,[0 1],1,true,[(1-mutationProb) mutationProb]);
        if mutationPoll == 1
            % Generate a mutation ratio
            mutationRatio = (mutationLim(:,2)-mutationLim(:,1))*rand(1)+mutationLim(:,1);
            popInst.popData(:,:,unitIndex) = popInst.popData(:,:,unitIndex).*mutationRatio;
        end
        
    end
end