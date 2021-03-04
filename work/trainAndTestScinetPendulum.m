close('all'); clear; clc; rng(0);

%% Generate data
NTimes = 50;
NSamples = 100000;
observations = zeros(NTimes, 1, 1, NSamples);
answers = zeros(1, 1, 1, NSamples);
questions = zeros(1, 1, 1, NSamples);
[observations(:, 1, 1, :), observationsTime, answers(1, 1, 1, :), questions(1, 1, 1, :)] = generatePendulumData(NTimes, NSamples);

% Plot NPlot random items 
NPlot = 10;
idxPlot = randi(NSamples, 1, NPlot);
figure; plot(observationsTime, squeeze(observations(:, 1, 1, idxPlot)));
hold('on');
plot(squeeze(questions(1, 1, 1, idxPlot)), squeeze(answers(1, 1, 1, idxPlot)), 'ro', 'MarkerSize', 3);

% Split training and testing data
NTraining = 95000;
observationsTesting = observations(:, 1, 1, NTraining+1:end);
answersTesting = answers(1, 1, 1, NTraining+1:end);
questionsTesting = questions(1, 1, 1, NTraining+1:end);
observations(:, :, :, NTraining+1:end) = [];
answers(:, :, :, NTraining+1:end) = [];
questions(:, :, :, NTraining+1:end) = [];

% Convert to dlarray in 'SSCB' format
observations = dlarray(observations, 'SSCB');
observationsTesting = dlarray(observationsTesting, 'SSCB');
answers = dlarray(answers, 'SSCB');
answersTesting = dlarray(answersTesting, 'SSCB');
questions = dlarray(questions, 'SSCB');
questionsTesting = dlarray(questionsTesting, 'SSCB');



%% Custom VAE building blocks
layers_encoder = [imageInputLayer([NTimes, 1], "Name", "Observations", "Normalization", "none");...
                fullyConnectedLayer(500, "Name", "fc_encoder_1"); ...
                eluLayer(1, "Name", "elu_encoder_1"); ...
                fullyConnectedLayer(100, "Name", "fc_encoder_2"); ...
                eluLayer(1, "Name", "elu_encoder_2"); ...
                fullyConnectedLayer(3, "Name", "Latent_Representations")];
net_encoder = dlnetwork(layerGraph(layers_encoder));

layers_decoder = [imageInputLayer([4, 1], "Name", "Representations_and_question", "Normalization", "none");...
                fullyConnectedLayer(100, "Name", "fc_decoder_1"); ...
                eluLayer(1, "Name", "elu_decoder_1"); ...
                fullyConnectedLayer(150, "Name", "fc_decoder_2"); ...
                eluLayer(1, "Name", "elu_decoder_2"); ...
                fullyConnectedLayer(1, "Name", "Answers")];
net_decoder = dlnetwork(layerGraph(layers_decoder));

%%
answersPrediction = forwardScinet(net_encoder, net_decoder, observationsTesting, questionsTesting);

%% Training paramters
miniBatchSize = 512;
learninRate = 1e-3;
beta = 1e-3;
numEpochs = 1000;

%% Training loop

%% Testing

%% --------------------------------------------------------------------- %%
%% Helper functions
%% --------------------------------------------------------------------- %%
function answers = forwardScinet(netEncoder, netDecoder, dlObservationsArray, dlQuestionsArray)
% dlarray in 'SSCB' format

% Predict latent representations from observations using encoder
latentRepresentations(:, 1, 1, :) = predict(netEncoder, dlObservationsArray(:, 1, 1, :));
latentRepresentations = dlarray(latentRepresentations, 'SSCB');

% Predict answer from latent representations and questions
answers(:, 1, 1, :) = predict(netDecoder, cat(1, dlQuestionsArray, latentRepresentations));
answers = dlarray(answers, 'SSCB');

end

function [gradientsEncoder, gradientsDecoder, loss] = ...
    ScinetLossAndGradients(netEncoder, netDecoder, dlObservationsArray, dlQuestionsArray, dlAnswersArray)

% Forward
predictedAnswers = forwardScinet(netEncoder, netDecoder, dlObservationsArray, dlQuestionsArray);

end

function lineHandle = createTrainingProgressPlot()

% Open plot
trainingPlot = figure;
trainingPlot.Position(3) = 16/9*trainingPlot.Position(4);
trainingPlot.Visible = 'on';

% Add gridded axes
trainingPlotAxes = axes('Parent', trainingPlot);
grid(trainingPlotAxes, 'on');

% Add animated line
lineHandle = animatedline(trainingPlotAxes);
xlabel(trainingPlotAxes, "Iteration" );
ylabel(trainingPlotAxes, "Log10(Loss)" );
title(trainingPlotAxes, "Log10(Loss) against Iteration");

end