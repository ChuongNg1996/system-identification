%% Clear all
clc
clear

%% Load Model

% Model 1
load("Nomoto2ndOrderModel_cmdExcResult_1.mat");
modelOne = nomoto2ndOrderInst;

% Model 2
load("Nomoto2ndOrderModel_cmdExcResult_2_30deg.mat");
modelTwo = nomoto2ndOrderInst;

%% Load Data
load("cmdExcScript");