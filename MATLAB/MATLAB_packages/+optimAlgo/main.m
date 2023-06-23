%% Clear all
clc
clear

%% Application Parameters

maxRudderAngle = 30;        % degree
minRudderAngle = -30;      

maxTimeDuration = 30;       % seconds
minTimeDuration = 10;

switchCount = 10;           % number of times that rudder angle changes

%% Algorithm Parameters

popSize = 5;
itemSize = 2;                  
itemDim = switchCount;
dataLim = [minRudderAngle maxRudderAngle; 
           minTimeDuration maxTimeDuration];

% unitOrient = 'vertical';
unitOrient = 'horizontal';
%% Initialization

% New instance of populationObject from optimizationAlgorithm packagage
% Used to store current population
popInst = optimAlgo.popClass(popSize,itemSize,itemDim,dataLim,unitOrient);


%% Optimization Algorithms
trainIter = 100;

% Artificial Gorilla Troops Optimizer
[optimdInst,bestUnit,bestCostProg] = ... 
    optimAlgo.metaHeuristic.artificialGorillaTroopsOptim(trainIter,...
    @excSigGen.costFunc.dOptimReg,popInst);

%% Application Utilities

% Plot the cost progression
figure(1)
title('Excitation');
plot(bestCostProg);

% Time Series for Excitation signal
% Add up the time to make a coherent time duration
for i = 2:itemDim
    bestUnit(2,i) = bestUnit(2,i) + bestUnit(2,i-1);
end
signal = [bestUnit(1,:) 0];
time = [0 bestUnit(2,:)];
cmdExc = timeseries(signal,time);

% plot the timeseries
figure(2)
title('Excitation');
plot(cmdExc);