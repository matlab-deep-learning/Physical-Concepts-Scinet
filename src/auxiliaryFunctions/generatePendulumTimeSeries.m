function [position, t] = generatePendulumTimeSeries(NTimes, Tfinal, k, b, m, A0, delta0)

% Generates Pendulum position time series using analytical solution, given physical parameters (k,b,m) and initial contitions (A0, delta0) 


% b, k are row vectors
% m, A0, delta0 are scalars

% Derived parameter (omega)
omega = sqrt(k/m) .* sqrt(1 - (b.^2) ./ (4*m*k));

% Time discretization
t = linspace(0, Tfinal, NTimes).';

% Analytical solution
f = @(t, b, omega) A0*exp(-t*b/(2*m)) .* cos(t*omega + delta0);

% Store observations columnwise
position = f(t, b, omega);

end
% Copyright 2021 The MathWorks, Inc.