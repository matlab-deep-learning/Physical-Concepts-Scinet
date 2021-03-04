function [observations, observationsTime, answers, answersTime] = generatePendulumData(NTimes, NSamples)

% Generates NSamples observations and corresponding answers from the pendumum solution

% Parameters (from arXiv paper)
m = 1; % [kg]
A0 = 1; % [m]
delta0 = 0; % [rad]

kValues = (rand(1, NSamples) + 1) * 5; % [kg/s^2]
bValues = (rand(1, NSamples) + 1) * 0.5; % [kg/s]
omegaValues = sqrt(kValues/m) .* sqrt(1 - (bValues.^2) ./ (4*m*kValues));

observationsTime = linspace(0, 5, NTimes)';

% Analytical solution
f = @(t, b, omega) A0*exp(-t*b/(2*m)) .* cos(t*omega + delta0);

% Store observations columnwise
observations = f(observationsTime, bValues, omegaValues);

% Row vector of questions (= answers time)
answersTime = rand(1, NSamples)*10;

% Row vector of correct answers
answers = arrayfun(f, answersTime, bValues, omegaValues);

end