%% Clear all
clc
clear

%% Timeseries

% +30/-30 rudder angle 
% upperAngle = 30*(3.14/180);  
% lowerAngle = -30*(3.14/180);  
timeStep = 0.01;
holdTime = 15;
stopTime = 200;
holdCount = holdTime/timeStep;
stopCount = stopTime/timeStep;

rudderAngle = zeros(stopCount,1);
angleSwitchCounter = 0;
setAngle = 30*(3.14/180);

for i = 1:stopCount
    rudderAngle(i,1) = setAngle;
    angleSwitchCounter = angleSwitchCounter + 1;
    if angleSwitchCounter == holdCount
        setAngle = setAngle*(-1);
        angleSwitchCounter = 0;
    end
end

timeArray = 0:1:(stopCount-1);
timeArray = timeArray*timeStep;
timeArray = timeArray';

cmdExc = timeseries(rudderAngle,timeArray);