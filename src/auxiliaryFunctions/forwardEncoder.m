function latentRepresentation = forwardEncoder(netEncoder, dlObservationsArray)
% dlarray in 'SSCB' format

% Predict latent representations from observations using encoder
latentRepresentation(:, 1, 1, :) = predict(netEncoder, dlObservationsArray(:, 1, 1, :));
latentRepresentation = dlarray(latentRepresentation, "SSCB");

end
% Copyright 2021 The MathWorks, Inc.
