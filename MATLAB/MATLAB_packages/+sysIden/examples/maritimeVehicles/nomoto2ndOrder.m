%% Clear all
clc
clear

%% Extract Recorded Data

% vechicleData = readmatrix('data\hoorn_15deg_15hold_100s_0dot05sample.xlsx');
% dataSizeLim = 1500;
% vechicleData = vechicleData(1:dataSizeLim,:);

load("cmdExcResult_2_30deg.mat");
vechicleData = data;
dataSizeLim = size(vechicleData);
dataSizeLim = dataSizeLim(1,1);

time = vechicleData(:,1);
deltaDot = vechicleData(:,10);
r = vechicleData(:,15);
delta = vechicleData(:,21);

%% Model Formulation
% Construct state matrix
rBack = [r(1);r(1:(length(r)-1))]; % Get r(k-1)
deltaBack = [delta(1);delta(1:(length(delta)-1))]; % Get delta(k-1)

xr1 = r; % r(k)
xr2 = rBack; % r(k-1)
xr3 = -r+rBack; % -r(k)+r(k-1)
xr4 = rBack; % r(k-1)
xr5 = deltaBack; % del(k-1)
xr6 = delta-deltaBack; % del(k)-del(k-1)
x = [xr1 xr2 xr3 xr4 xr5 xr6];

% Output
y = [r(2:length(time)); r(length(time))];

%% Application Parameters

paramSize = size(x); paramSize = paramSize(1,2);

% Create a (vertical) 2-D array store limits of each parameter.
paramLim = [2 2;
            -1 -1;
            -10 10;
            -10 10;
            -10 10;
            -10 10];
    
sampleSize = dataSizeLim;

%% Algorithm Parameters

popSize = 100;
% itemSize = paramSize;
itemSize = 6;   
itemDim = 1;
dataLim = paramLim;

% unitOrient = 'vertical';
unitOrient = 'horizontal';
% *NOTE: since paramVal in polyInst has the form of (paramSize,1), the form
% of an unit in population must be the same. With unitOrient = 'horizontal'
% , a unit in population as the form of (itemSize,itemDim). Thus, itemSize 
% must be paramSize and itemDim must be 1.

%% Initialization

% New instance of genericRegEq from utils packagage
% Make a generic regression equation from defined number of parameter
nomoto2ndOrderInst = sysIden.class.nomoto2ndOrderClass(paramSize,sampleSize);

% struct of training data
trainData.Input = x;
trainData.Output = y;

figure(1)
plot(trainData.Output);

% New instance of populationObject from optimizationAlgorithm packagage
% Used to store current population
popInst = optimAlgo.class.popClass(popSize,itemSize,itemDim,dataLim,unitOrient);

%% Optimization Algorithms
trainIter = 50;

tic % timer starts

% Genetic Algorithm Optimization
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.geneticAlgoOptim(trainIter,...
%     @optimAlgo.metaHeuristic.costFunc.rmse,popInst,nomoto2ndOrderInst,trainData);

% African Vultures Optimization
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.africanVultureOptim(trainIter,...
%     @optimAlgo.metaHeuristic.costFunc.rmse,popInst,nomoto2ndOrderInst,trainData);

% Artificial Bee Colony Algorithm (not completed)
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.artificialBeeColonyOptim(trainIter,...
%     @optimAlgo.metaHeuristic.costFunc.rmse,popInst,nomoto2ndOrderInst,trainData);

% Artificial Gorilla Troops Optimizer
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.artificialGorillaTroopOptim(trainIter,...
%     @optimAlgo.metaHeuristic.costFunc.rmse,popInst,nomoto2ndOrderInst,trainData);

% Grey Wolf Optimizer
[optimdInst,bestUnit,bestCostProg] = ... 
    optimAlgo.metaHeuristic.algo.greyWolfOptim(trainIter,...
    @optimAlgo.metaHeuristic.costFunc.rmse,popInst,nomoto2ndOrderInst,trainData);

% Particle Swarm Optimization
% [optimdInst,bestUnit,bestCostProg] = ... 
%     optimAlgo.metaHeuristic.algo.particleSwarmOptim(trainIter,...
%     @optimAlgo.metaHeuristic.costFunc.rmse,popInst,nomoto2ndOrderInst,trainData);

toc % timer ends

%% Application Utilities

% Plot the cost progression
figure(1)
title('Excitation');
plot(bestCostProg);

% Plot Prediction vs. Actual Output
nomoto2ndOrderInst.inputVal = trainData.Input;
nomoto2ndOrderInst.paramVal = bestUnit;
nomoto2ndOrderInst = nomoto2ndOrderInst.eqOutVal();
figure(2)
hold on
plot(nomoto2ndOrderInst.outputVal);
plot(trainData.Output);
legend('prediction','actual');
hold off

% display cost
msg = ['cost: ', num2str(bestCostProg(end,1))];
disp(msg);

% save model
save optimNomoto2ndOrderModel.mat nomoto2ndOrderInst