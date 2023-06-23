%% Clear all
clc
clear

%% Application Parameters

maxRudderAngle = 30*(3.14/180);        % degree
minRudderAngle = -30*(3.14/180);      

maxTimeDuration = 50;       % seconds
minTimeDuration = 100;

switchCount = 100;           % number of times that rudder angle changes

%% Algorithm Parameters

popSize = 20;
itemSize = 2;                  
itemDim = switchCount;
dataLim = [minRudderAngle maxRudderAngle; 
           minTimeDuration maxTimeDuration];

unitOrient = 'vertical';
% unitOrient = 'horizontal';
%% Initialization

% New instance of populationObject from optimizationAlgorithm packagage
% Used to store current population
popInst = optimAlgo.class.popClass(popSize,itemSize,itemDim,dataLim,unitOrient);


%% Optimization Algorithms
trainIter = 10;

% Genetic Algorithm Optimization
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.popAsTrainData.geneticAlgoOptim(trainIter,...
%     @excSigGen.costFunc.dOptimReg,popInst);

% African Vultures Optimization
[optimdInst,bestUnit,bestCostProg] = ... 
    optimAlgo.metaHeuristic.algo.popAsTrainData.africanVultureOptim(trainIter,...
    @excSigGen.costFunc.dOptimReg,popInst);

% Artificial Gorilla Troops Optimizer
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.popAsTrainData.artificialGorillaTroopsOptim(...
%     trainIter,@excSigGen.costFunc.dOptimReg,popInst);

% Grey Wolf Optimizer
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.popAsTrainData.greyWolfOptim(trainIter,...
%     @excSigGen.costFunc.dOptimReg,popInst);

% Particle Swarm Optimization
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.popAsTrainData.particleSwarmOptim(trainIter,...
%     @excSigGen.costFunc.dOptimReg,popInst);

%% Application Utilities

% Plot the cost progression
figure(1)
title('Excitation');
plot(bestCostProg);

% Time Series for Excitation signal
% Add up the time to make a coherent time duration
switch unitOrient
    case 'horizontal'
        for i = 2:itemDim
            bestUnit(2,i) = bestUnit(2,i) + bestUnit(2,i-1);
        end
        signal = [bestUnit(1,:) 0];
        time = [0 bestUnit(2,:)];
    otherwise
        for i = 2:itemDim
            bestUnit(i,2) = bestUnit(i,2) + bestUnit(i-1,2);
        end
        signal = [bestUnit(:,1);0];
        time = [0;bestUnit(:,2)];
end

% construct the timeseries (for Simulink simulation)
cmdExc = timeseries(signal,time);

% plot the timeseries
figure(2)
title('Excitation');
plot(cmdExc);

% save the command (for Simulink simulation)
save cmdExcScript.mat cmdExc
