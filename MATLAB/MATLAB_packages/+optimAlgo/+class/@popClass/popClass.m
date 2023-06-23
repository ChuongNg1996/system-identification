classdef popClass
    % Population class used for Meta Heuristic algorithms
    
    properties
        
        % Parameters
        popSize             % size of population (scalar), includes units
                            % e.g: population size of 50 has 50 units.
                            % Each unit has a number of items.
                            
        itemSize            % size of (all) items (scalar)
        itemDim             % dimension of (all) items 
        
        unitOrient          % orientation of an unit in the population
        unitRowDim          % dimension of unit's row w.r.t unitOrient
        unitColDim          % dimension of unit's col w.r.t unitOrient
        oneItemRowDim       % dimension of an item's row w.r.t unitOrient
        oneItemColDim       % dimension of an item's col w.r.t unitOrient
        
        dataLim             % value limits of the features
        
        % Data
        popData             % data of populationObject with dimension of
                            % (itemDim,itemSize,popSize)
                            % e.g: (10,3,40) means a population of 40, each
                            % unit of population has 3 features, each
                            % feature has 10 data points.
                         
        popCost            % cost of each unit of the population
                            
    end
    
    methods
        
        % Constructor
        function obj = popClass(popSize,itemSize,itemDim,dataLim,unitOrient)
            % Initialize Properties
            obj.popSize = popSize;
            obj.itemSize = itemSize;
            obj.itemDim = itemDim;
            obj.dataLim = dataLim;
            obj.unitOrient = unitOrient;
            
            % Assign data for popData
            switch unitOrient
                case 'vertical'
                    obj.unitRowDim = itemDim;
                    obj.unitColDim = itemSize;
                    obj.oneItemRowDim = itemDim;
                    obj.oneItemColDim = 1;
                otherwise
                    obj.unitRowDim = itemSize;
                    obj.unitColDim = itemDim;
                    obj.oneItemRowDim = 1;
                    obj.oneItemColDim = itemDim;
            end
            
            % Pre-allocate dimension for popData
            obj.popData = zeros(obj.unitRowDim,obj.unitColDim,popSize);
            
            % Initialize data for popData
            obj.popData = optimAlgo.utils.randPopWithRange(obj.popSize,...
                obj.itemSize,obj.unitRowDim,obj.unitColDim,...
                obj.oneItemRowDim,obj.oneItemColDim,obj.unitOrient,dataLim);
            
            % Pre-allocate dimension for popCost
            obj.popCost = zeros(popSize,1);
        end
    end
    
end