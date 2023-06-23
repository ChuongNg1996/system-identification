function [tempData] = randPopWithRange(popSize,itemSize,unitRowDim,unitColDim,oneItemRowDim,oneItemColDim,unitOrient,dataLim)
    
    % Initialize an temporary storage for popData 
    tempData= zeros(unitRowDim,unitColDim,popSize);

    % The for-loop assign data for one feature per iteration
    for itemIndex = 1:itemSize 

        % Assign minimum and maximum values of the item
        minVal = dataLim(itemIndex,1);
        maxVal = dataLim(itemIndex,2);

        % Create tempItemData of one item for whole population
        tempItemData = (maxVal-minVal).*rand(oneItemRowDim,oneItemColDim,popSize)+minVal;
        
        % Vectorize tempData into one item of popData
        switch unitOrient   
            case 'vertical'                     
                tempData(:,itemIndex,:) = tempItemData; % vertical 
            otherwise
                tempData(itemIndex,:,:) = tempItemData; % horizontal       
        end
            
        
    end
    
end