classdef nomoto2ndOrderClass
    % class designed specifically for nomoto 2nd order model SI
    
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
        
        
        function obj = nomoto2ndOrderClass(paramSize,sampleSize)
            % Constructor
            
            % Initialize Properties
            obj.paramSize = paramSize;
            obj.sampleSize = sampleSize;
            
            % Initialize Data
            % Follows: inputMatrix(sampleSize,paramSize) x
            % paramVal(paramSize,1) = outputVal(sampleSize,1)
            
        end
        
        function obj = eqOutVal(obj)
            % Calculate output
            
            obj.paramVal(1,1) = 2;
            obj.paramVal(2,1) = -1;
            
            obj.outputVal = obj.inputVal*obj.paramVal;
            
        end
    end
    
    
end