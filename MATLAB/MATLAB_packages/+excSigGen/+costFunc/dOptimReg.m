function [outCost] = dOptimReg(popInst)
    % D-optimality (linear regression) with assumption J = det((X'X)^-1)

    
    popSize = popInst.popSize;
    itemSize = popInst.itemSize;
    dataLim = popInst.dataLim;
    popData = popInst.popData;
    unitRowDim = popInst.unitRowDim;
    unitColDim = popInst.unitColDim;
    oneItemRowDim = popInst.oneItemRowDim;
    oneItemColDim = popInst.oneItemColDim;
    unitOrient = popInst.unitOrient;
    
    outCost = zeros(popSize,1);
    
    % Can use Vectorization instead of For-loop for optimality, but 
    % might be harder to debug
    for unitIndex = 1:popSize
        
        % X'*X
        J = popData(:,:,unitIndex)'*popData(:,:,unitIndex); 
        
        %(X'*X)^-1
        J = inv(J);    
        
        % det(X'*X)^-1
        J = det(J); 
        
        % avoid det() = 0
        % Randomize again & again until det() is not 0
%         while J == 0
%             
%             % Initialize new value for the unit
%             popData(:,:,unitIndex) = optimAlgo.utils.randUnitWithRange(...
%                 itemSize,unitRowDim,unitColDim,oneItemRowDim,...
%                 oneItemColDim,unitOrient,dataLim);
%             
%             % X'*X
%             J = popData(:,:,unitIndex)'*popData(:,:,unitIndex); 
% 
%             %(X'*X)^-1
%             J = inv(J);    
% 
%             % det(X'*X)^-1
%             J = det(J); 
%         end
        
        % log(det(X'*X)^-1)
        J = log(J);
        
        % Eliminate minus sign (if any)
        J = abs(J); 
        
        % Assign cost of current unit to outCost
        outCost(unitIndex,1) = J;
    end

end

