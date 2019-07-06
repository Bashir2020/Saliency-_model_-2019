close all; clc;
dataSetDir = 'C:\Users\bashir\Desktop\SALICON';
imageDir = fullfile(dataSetDir, 'training');
labelDir = fullfile(dataSetDir, 'labels');
 
% ------Create an imageDatastore holding the training images.
imds = imageDatastore(imageDir);
imds.ReadFcn = @readImages;
% ------Define the class names and their associated label IDs.
classNames = ["foreground", "background"];
labelIDs   = [255 0];
 
% ----Create a pixelLabelDatastore holding the ground truth pixel labels for  the training images.
pxds = pixelLabelDatastore(labelDir, classNames, labelIDs);
pxds.ReadFcn = @readLabels;
 imageSize = [224 224 3];
% imageSize = [224 224];
 numClasses = 2;
 lgraph = segnetLayers(imageSize, numClasses, 'vgg16');
%------Data Augmentation---------
augmenter = imageDataAugmenter( ...
    'RandScale' ,[0.5 2.5],...
    'RandXScale',[0.5 2.5],...
    'RandYScale',[1 1],...
    'RandRotation',[-30 30], ...
    'RandScale',[1 1],...
    'RandXTranslation', [-3 3],...
    'RandYTranslation', [-3 3]);
 auimds = pixelLabelImageDatastore(imds,pxds,'DataAugmentation',augmenter);
 
% -----Create data source for training a semantic segmentation network.
datasource = pixelLabelImageSource(imds,pxds);
 
% ------Setup training options.
options = trainingOptions('sgdm', 'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 40, 'VerboseFrequency', 10,...'ValidationData',testdatasource,...
    'Plots','training-progress','MiniBatchsize',10);
 
%-------- Train network.
 net = trainNetwork(auimds,lgraph,options);

% metrics = evaluateSemanticSegmentation(pxdsResults,test_pxds,'Verbose',1);


