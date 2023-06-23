%{
Paper: (2019) African vultures optimization algorithm: A new nature-inspired
% metaheuristic algorithm for global optimization problems
DOI: https://doi.org/10.1016/j.cie.2021.107408
%}

function [optimdInst,bestUnit,bestCostProg] = africanVultureOptim(...
    trainIter,costFunc,popInst)
    % African Vultures Optimization
    
    % --- Initialization --- % 
    
    % Properties of population
    popSize = popInst.popSize;
%     itemSize = popInst.itemSize;
%     itemDim = popInst.itemDim;
    dataLim = popInst.dataLim;
    unitRowDim = popInst.unitRowDim;
    unitColDim = popInst.unitColDim;
%     oneItemRowDim = popInst.oneItemRowDim;
%     oneItemColDim = popInst.oneItemColDim;
%     unitOrient = popInst.unitOrient;
    
    % Cost Progression through Training
    bestCostProg = zeros(trainIter,1);
    
    % Random stream
    s = RandStream('mlfg6331_64');
    
    % coefficients of equation
    w = 2;                  % in eq (3)
    P1 = 0.4;               % if-else con #1
    P2 = 0.4;               % if-else con #2    
    P3 = 0.4;               % if-else con #31
    beta = 1.5;             % in eq (18) - LF (if-else con #3)

    lb = dataLim(1,1);         % in eq (8)
    ub = dataLim(1,2);         % in eq (8)
    
    % --- End of Initialization --- %
    
    % --- Training Start --- % 
    for i = 1:trainIter
        
        % Evaluate cost of all units in popInst
        popInst.popCost = costFunc(popInst);    
        
        % Find best and second best, construct probability distribution
        [sortedPopCost,sortedPopIndex] = sort(popInst.popCost);
        probBest = 1 - sortedPopCost(1,1)/(sortedPopCost(1,1) + sortedPopCost(2,1));
        probSecBest = 1 - probBest;
        
        % Go through the rest of population except two best
        for sortedUnitIndex = 3:popSize
            unitIndex = sortedPopIndex(sortedUnitIndex,1);
            
            % Roulette wheel between two best
            poll = randsample(s,[1 2],1,true,[probBest probSecBest]);
            switch poll
                case 1
                    Ri = popInst.popData(:,:,sortedPopIndex(1,1));
                otherwise
                    Ri = popInst.popData(:,:,sortedPopIndex(2,1));
            end
            
            % Eq (3) & (4)
            h = (2 - (-2))*rand(1)+(-2);
            t = h*( (sin( (pi/2)*(i/trainIter) ))^w + cos( (pi/2)*(i/trainIter) ) -1); % eq (3)
            rand1 = rand(1);
            z = (1 - (-1))*rand(1)+(-1);
            F = (2*rand1 + 1)*z*(1 - i/trainIter) + t; % eq (4)  
            
            if F >= 1
                % Yes -> Exploration
                randp1 = rand(1);
                if P1 >= randp1
                    % yes -> use eq (6)
                    randx =  rand(unitRowDim,unitColDim);
                    X = 2*randx;
                    Di = abs(X.*Ri - popInst.popData(:,:,unitIndex));
                    popInst.popData(:,:,unitIndex) = Ri - Di.*F; % update vulture pos
                else
                    % no -> use eq (8)
                    rand2 = rand(unitRowDim,unitColDim);
                    rand3 = rand(unitRowDim,unitColDim);
                    popInst.popData(:,:,unitIndex) = Ri - F + rand2.*((ub-lb).*rand3 + lb); % update vulture pos
                end % randp1
            else
                % No -> Exploitation
                if F >= 0.5
                    % Yes -> randp2
                    randp2 = rand(1);
                    if P2 >= randp2
                        % Yes -> use eq (10)
                        randx =  rand(unitRowDim,unitColDim);
                        X = 2*randx;
                        Di = abs(X.*Ri - popInst.popData(:,:,unitIndex));
                        dt = Ri - popInst.popData(:,:,unitIndex);
                        rand4 = rand(1);
                        popInst.popData(:,:,unitIndex) = Di.*(F+rand4) - dt; % update vulture pos
                    else
                        % No -> use eq (13)
                        rand5 = rand(unitRowDim,unitColDim);
                        rand6 = rand(unitRowDim,unitColDim);
                        S1 = Ri.*(rand5.*popInst.popData(:,:,unitIndex)./(2*pi)).*cos(popInst.popData(:,:,unitIndex));
                        S2 = Ri.*(rand6.*popInst.popData(:,:,unitIndex)./(2*pi)).*sin(popInst.popData(:,:,unitIndex));
                        popInst.popData(:,:,unitIndex) = Ri - (S1 + S2); % update vulture pos
                    end
                else
                    % No -> randp3
                    randp3 = rand(1);
                    if P3 >= randp3
                        % Yes -> eq (16)
                        best1 = popInst.popData(:,:,sortedPopIndex(1,1));
                        best2 = popInst.popData(:,:,sortedPopIndex(2,1));
                        A1 = best1 - (best1.*popInst.popData(:,:,unitIndex))./(best1 - popInst.popData(:,:,unitIndex).^2).*F;
                        A2 = best2 - (best2.*popInst.popData(:,:,unitIndex))./(best2 - popInst.popData(:,:,unitIndex).^2).*F;
                        popInst.popData(:,:,unitIndex) = (A1+A2)./2;   % update vulture pos
                    else
                        % No -> eq (17)
                        dt = Ri - popInst.popData(:,:,unitIndex);
                        sigma = (gamma(1+beta)*sin(pi*beta/2)/(gamma(1+beta^2)*beta*2*(beta-1)/2))^(1/beta);
                        u = rand(1);
                        v = rand(1);
                        LF = 0.01*(u*sigma)/abs(v)&(1/beta);
                        popInst.popData(:,:,unitIndex) = Ri - abs(dt).*(LF*F); % update vulture pos
                    end % randp3
                end % randp2
            end % F
        end
        % Evaluate cost of all units in popInst
        popInst.popCost = costFunc(popInst);
       [bestUnitCost, bestUnitIndex] = min(popInst.popCost);
        bestCostProg(i,1) = bestUnitCost;
    end
    
    % Outputs
    optimdInst = popInst.popData;
    bestUnit = popInst.popData(:,:,bestUnitIndex);
end

