function [popCost] = rmse(popInst,trainInst,trainData)
    % rmse cost function

    % popInst is an object
    % trainInst is an object
    % trainData is a struct

    popSize = popInst.popSize;
    
    popCost = zeros(popSize,1);
    
    for unitIndex = 1:popSize
        
        trainInst.inputVal = trainData.Input;
        trainInst.paramVal = popInst.popData(:,:,unitIndex);
        trainInst = trainInst.eqOutVal();
        
        deviationVal = trainData.Output - trainInst.outputVal;
        popCost(unitIndex,1) = sqrt((sum(deviationVal.^2))/trainInst.sampleSize);
    end
    

end

