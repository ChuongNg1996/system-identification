%% Clear all
clc
clear


%% Application Parameters

paramSize = 3;
sampleSize = 100; 

% Create a (vertical) 2-D array store limits of each parameter.
paramLim = [-10 10];
paramLim = repmat(paramLim,paramSize,1);

%% Algorithm Parameters

popSize = 150;
itemSize = paramSize;                  
itemDim = 1;
dataLim = paramLim;

% unitOrient = 'vertical';
unitOrient = 'horizontal';
% *NOTE: since paramVal in polyInst has the form of (paramSize,1), the form
% of an unit in population must be the same. With unitOrient = 'horizontal'
% , a unit in population as the form of (itemSize,itemDim). Thus, itemSize 
% must be paramSize and itemDim must be 1.

%% Initialization

% New instance of polyEqClass from utils packagage
% Make a polynominal equation from defined number of parameter
polyInst = utils.class.polyEqClass(paramSize,sampleSize);

% Generate training data with struct

% Input
randInputLim = [-10 10];
randtrainData.Input = (randInputLim(1,1) - randInputLim(1,2))*...
    rand(sampleSize,1)+ randInputLim(1,1);

% Output
% randtrainData.Output = sin(randtrainData.Input);
% randtrainData.Output = 10*randtrainData.Input ;
randtrainData.Output = 10*randtrainData.Input + 15*(randtrainData.Input).^2+5;

figure(1)
plot(randtrainData.Output);

% Generate random training data from polyInst (deprecated)
% polyInst = randTrainDataGen(polyInst,randInputLim,paramLim);


% New instance of populationObject from optimizationAlgorithm packagage
% Used to store current population
popInst = optimAlgo.class.popClass(popSize,itemSize,itemDim,dataLim,unitOrient);


%% Optimization Algorithms
trainIter = 300;

tic % timer starts

% Genetic Algorithm Optimization
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.geneticAlgoOptim(trainIter,...
%     @optimAlgo.metaHeuristic.costFunc.rmse,popInst,polyInst,randtrainData);

% African Vultures Optimization
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.africanVultureOptim(trainIter,...
%     @optimAlgo.metaHeuristic.costFunc.rmse,popInst,polyInst,randtrainData);

% Artificial Bee Colony Algorithm (not completed)
[optimdInst,bestUnit,bestCostProg] = ... 
    optimAlgo.metaHeuristic.algo.artificialBeeColonyOptim(trainIter,...
    @optimAlgo.metaHeuristic.costFunc.rmse,popInst,polyInst,randtrainData);

% Artificial Gorilla Troops Optimizer
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.artificialGorillaTroopOptim(trainIter,...
%     @optimAlgo.metaHeuristic.costFunc.rmse,popInst,polyInst,randtrainData);

% Grey Wolf Optimizer
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.greyWolfOptim(trainIter,...
%     @optimAlgo.metaHeuristic.costFunc.rmse,popInst,polyInst,randtrainData);

% Particle Swarm Optimization
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.particleSwarmOptim(trainIter,...
%     @optimAlgo.metaHeuristic.costFunc.rmse,popInst,polyInst,randtrainData);

toc % timer ends

%% Application Utilities

% Plot the cost progression
figure(1)
title('Excitation');
plot(bestCostProg);

% Plot Prediction vs. Actual Output
polyInst.inputVal = randtrainData.Input;
polyInst.paramVal = bestUnit;
polyInst = polyInst.eqOutVal();
figure(2)
hold on
plot(polyInst.outputVal);
plot(randtrainData.Output);
legend('prediction','actual');
hold off

% display cost
msg = ['cost: ', num2str(bestCostProg(end,1))];
disp(msg);
