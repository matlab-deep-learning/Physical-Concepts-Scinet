function [observations, observationsTime, answers, answersTime] = generatePendulumData(NTimes, Tfinal, params, NSamples)

% Generates NSamples observations and corresponding answers from the pendumum solution

% Extract physical parameters from the params structure
kMin = params.kMin;
kMax = params.kMax;
bMin = params.bMin;
bMax = params.bMax;
m = params.m;
A0 = params.A0;
delta0 = params.delta0;

% Derived parameters (row vectors)
k = kMin + rand(1, NSamples)*(kMax - kMin);
b = bMin + rand(1, NSamples)*(bMax - bMin);

% Generate observations
[observations, observationsTime] = generatePendulumTimeSeries(NTimes, Tfinal.observations, k, b, m, A0, delta0);

% Row vector of questions (= answers time)
answersTime = rand(1, NSamples)*Tfinal.answers;

% Row vector of correct answers
answers = arrayfun(@(t, k, b) generatePendulumTimeSeries(1, t, k, b, m, A0, delta0), answersTime, k, b);

end
% Copyright 2021 The MathWorks, Inc.