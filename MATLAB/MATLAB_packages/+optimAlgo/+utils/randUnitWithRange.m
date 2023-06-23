function [tempUnitData] = randUnitWithRange(itemSize,unitRowDim,unitColDim,oneItemRowDim,oneItemColDim,unitOrient,dataLim)
    
    tempUnitData = zeros(unitRowDim,unitColDim);
    for itemIndex = 1:itemSize 

        % Assign minimum and maximum values of the item
        minValue = dataLim(itemIndex,1);
        maxValue = dataLim(itemIndex,2);

        % Create tempItemData of one item for one unit
        tempItemData = (maxValue-minValue).*rand(oneItemRowDim,oneItemColDim,1)+minValue;

        % Vectorize tempData into one item
        switch unitOrient    
            case 'vertical'               
                tempUnitData(:,itemIndex) = tempItemData; % vertical 
            otherwise
                tempUnitData(itemIndex,:) = tempItemData; % horizontal 
        end
        
    end

end

