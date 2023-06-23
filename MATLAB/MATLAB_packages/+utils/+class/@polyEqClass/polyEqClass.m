classdef polyEqClass
    
    properties
        
        % Parameters
        paramSize           % size of parameters (scalar)
        sampleSize          % size of training samples (scalar)

        % Data
        outputVal           % values of output
        inputVal            % values of input % (i.e.: x) 
        inputMatrix         % Values of input matrix 
                            % (i.e.: x, x^2, x^3, ..., x^n) 
        paramVal            % values of parameters
        
    end
    
    methods
        
        
        function obj = polyEqClass(paramSize,sampleSize)
            % Constructor
            
            % Initialize Properties
            obj.paramSize = paramSize;
            obj.sampleSize = sampleSize;
            
            % Initialize Data
            % Follows: inputMatrix(sampleSize,paramSize) x
            % paramVal(paramSize,1) = outputVal(sampleSize,1)
            obj.outputVal = ones(sampleSize,1);
            obj.inputVal = ones(sampleSize,1);
            obj.inputMatrix = ones(obj.sampleSize,obj.paramSize);
            obj.paramVal = ones(paramSize,1);
            
        end
        
        
        function obj = eqOutVal(obj)
            % Calculate output
            
            % Construct input matrix for polynominal equation
            for i = 1:obj.paramSize
                obj.inputMatrix(:,i) = (obj.inputVal).^i;
            end
            
            obj.outputVal = obj.inputMatrix*obj.paramVal;
            
        end
    end
    
    
end