function [z, mu, sigma] = sampleLatentSpace(latentRepresentation, latentDimension, batchSize)
% Implements the reparametrization required to make the cost function differentiable w.r.t. the weights in the encoder network

mu = latentRepresentation(1:latentDimension, :, :, :);
sigma = latentRepresentation(latentDimension+1:2*latentDimension, :, :, :);
epsilon = randn(latentDimension, 1, 1, batchSize);
z = mu + sigma.*epsilon;

end
% Copyright 2021 The MathWorks, Inc.