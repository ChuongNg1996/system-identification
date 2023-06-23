classdef genericRegEq
    
    properties
        
        % Parameters
        paramSize           % size of parameters (scalar)
        sampleSize          % size of training samples (scalar)

        % Data
        outputVal           % values of output
        inputVal            % values of input % (i.e.: x) 
        paramVal            % values of parameters
        
    end
    
    methods
        
        
        function obj = genericRegEq(paramSize,sampleSize)
            % Constructor
            
            % Initialize Properties
            obj.paramSize = paramSize;
            obj.sampleSize = sampleSize;
            
            % Initialize Data
            % Follows: inputMatrix(sampleSize,paramSize) x
            % paramVal(paramSize,1) = outputVal(sampleSize,1)
%             obj.outputVal = ones(sampleSize,1);
%             obj.inputVal = ones(sampleSize,1);
%             obj.paramVal = ones(paramSize,1);
            
        end
        
        function obj = eqOutVal(obj)
            % Calculate output
            
            obj.outputVal = obj.inputVal*obj.paramVal;
            
        end
    end
    
    
end