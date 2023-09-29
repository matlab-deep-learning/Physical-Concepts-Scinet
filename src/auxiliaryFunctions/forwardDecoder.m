function answers = forwardDecoder(netDecoder, dlZArray, dlQuestionsArray)
% Predicts answers given samples in the latent space and questions

answers(:, 1, 1, :) = predict(netDecoder, cat(1, dlQuestionsArray, dlZArray));
answers = dlarray(answers, "SSCB");

end
% Copyright 2021 The MathWorks, Inc.
