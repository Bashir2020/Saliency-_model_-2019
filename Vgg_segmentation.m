close all; clc;
dataSetDir = 'C:\Users\bashir\Desktop\SALICON';
imageDir = fullfile(dataSetDir, 'training');
labelDir = fullfile(dataSetDir, 'labels');
 
% Create an imageDatastore holding the training images.
imds = imageDatastore(imageDir);
imds.ReadFcn = @readImages;
% Define the class names and their associated label IDs.
classNames = ["foreground", "background"];
labelIDs   = [255 0];
 
% Create a pixelLabelDatastore holding the ground truth pixel labels for  the training images.
pxds = pixelLabelDatastore(labelDir, classNames, labelIDs);
pxds.ReadFcn = @readLabels;
% Cr[imds1,imds2] = splitEachLabel(imds,0.1);eate SegNet.
 imageSize = [224 224 3];
% imageSize = [224 224];
 numClasses = 2;
 lgraph = segnetLayers(imageSize, numClasses, 'vgg16');
% lgraph = segnetLayers(imageSize, numClasses, 'vgg19');
% lgraph = fcnLayers(imageSize,numClasses,'type','8s');
% lgraph = fcnLayers(imageSize,numClasses,'type','16s');
% lgraph = fcnLayers(imageSize,numClasses,'type','32s');
%   lgraph = unetLayers(imageSize,numClasses);
 
%------Data Augmentation---------
augmenter = imageDataAugmenter( ...
    'RandScale' ,[0.5 2.5],...
    'RandXScale',[0.5 2.5],...
    'RandYScale',[1 1],...
    'RandRotation',[-30 30], ...
    'RandScale',[1 1],...
    'RandXTranslation', [-3 3],...
    'RandYTranslation', [-3 3]);
% auimds = augmentedImageDatastore(imageSize,datasource,'DataAugmentation',augmenter)
auimds = pixelLabelImageDatastore(imds,pxds,'DataAugmentation',augmenter);
 
% Create data source for training a semantic segmentation network.
datasource = pixelLabelImageSource(imds,pxds);
 
% Setup training options.
options = trainingOptions('sgdm', 'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 40, 'VerboseFrequency', 10,...'ValidationData',testdatasource,...
    'Plots','training-progress','MiniBatchsize',10);
 
% Train network.
% net = trainNetwork(datasource, lgraph, options);
 net = trainNetwork(auimds,lgraph,options);
 save BASMASIR  net;
 %-----test image------
% test_imageDir = fullfile(dataSetDir, 'testI');
% test_imds = imageDatastore(test_imageDir);
% test_imds.ReadFcn = @readImages;
% test_labelDir = fullfile(dataSetDir, 'testL');
% test_pxds = pixelLabelDatastore(test_labelDir, classNames, labelIDs);
% test_pxds.ReadFcn = @readLabels;
% pxdsResults = semanticseg(test_imds,net, ...
%     'MiniBatchSize',4, ...
%     'WriteLocation',tempdir, ...
%     'Verbose',false);
% metrics = evaluateSemanticSegmentation(pxdsResults,test_pxds,'Verbose',1);


