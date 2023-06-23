%{
Paper: (2014) Grey Wolf Optimizer
DOI: http://dx.doi.org/10.1016/j.advengsoft.2013.12.007
%}

function [optimdInst,bestUnit,bestCostProg] = greyWolfOptim(...
    trainIter,costFunc,popInst,trainInst,trainData)
    % Artificial gorilla troops optimizer
    
    % --- Initialization --- % 
    
    % Properties of population
    popSize = popInst.popSize;
%     itemSize = popInst.itemSize;
%     itemDim = popInst.itemDim;
%     dataLim = popInst.dataLim;
    unitRowDim = popInst.unitRowDim;
    unitColDim = popInst.unitColDim;
%     oneItemRowDim = popInst.oneItemRowDim;
%     oneItemColDim = popInst.oneItemColDim;
%     unitOrient = popInst.unitOrient;
    
    % Cost Progression through Training
    bestCostProg = zeros(trainIter,1);
    
    % a linearly decreases from 2 to 0
    a = 2;
    aDec = a/trainIter;     % decrement of a
    
    % Limit of r1 and r2
    % r1 and r2 are random vector from 0 to 1
    rMin = 0;
    rMmax = 1;
    
    % --- End of Initialization --- %
    
    % --- Training Start --- % 
    
    % Evaluate cost of all units in popInst
    popInst.popCost = costFunc(popInst,trainInst,trainData);
    
    for i = 1:trainIter
         
         % Find alpha, beta, gamma of this iteration
         % Prey's location (global optimal solution) is unknown, so it is 
         % assumed that the prey is in the vicinity of best solutions,
         % which are alpha, beta, gamma.
         [sortedPopCost,sortedPopIndex] = sort(popInst.popCost);
         alphaIndex = sortedPopIndex(1);
         betaIndex = sortedPopIndex(2);
         gammaIndex= sortedPopIndex(3);
         
         alphaPos = popInst.popData(:,:,alphaIndex);
         betaPos = popInst.popData(:,:,betaIndex);
         gammaPos = popInst.popData(:,:,gammaIndex);
         
         % Update the remaining population (each remaining wolf is delta)
         % Iteration starts from 4 since the first 3 are alpha, beta, gamma
         for j = 4:popSize
             
             unitIndex = sortedPopIndex(j);
             
             % Find X1
             A1 = (2+a).*((rMmax - rMin).*rand(unitRowDim,unitColDim)+rMin)-a;  % A = 2a*r1-a
             C1 = 2.*((rMmax - rMin).*rand(unitRowDim,unitColDim)+rMin);        % C = 2*r2
             D1 = abs(C1.*alphaPos-popInst.popData(:,:,unitIndex));
             X1 = alphaPos - A1.*D1;
             
             % Find X2
             A2 = (2+a).*((rMmax - rMin).*rand(unitRowDim,unitColDim)+rMin)-a;  % A = 2a*r1-a
             C2 = 2.*((rMmax - rMin).*rand(unitRowDim,unitColDim)+rMin);        % C = 2*r2
             D2 = abs(C2.*betaPos-popInst.popData(:,:,unitIndex));
             X2 = betaPos - A2.*D2;
             
             % Find X3
             A3 = (2+a).*((rMmax - rMin).*rand(unitRowDim,unitColDim)+rMin)-a;  % A = 2a*r1-a
             C3 = 2.*((rMmax - rMin).*rand(unitRowDim,unitColDim)+rMin);        % C = 2*r2
             D3 = abs(C3.*gammaPos-popInst.popData(:,:,unitIndex));
             X3 = gammaPos - A3.*D3;
             
             % Update (delta) wolf position 
             % X = (X1 + X2 + X3)/3
             popInst.popData(:,:,unitIndex) = (X1 + X2 + X3)./3;
             

         end
         
         % linearly decrease a
         a = a - aDec;
         
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

