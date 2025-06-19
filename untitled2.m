dataPath = 'E:\MATLAB3\data';
imds = imageDatastore(dataPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
% 1. 数据准备
[imdsTrain, imdsVal, imdsTest] = splitEachLabel(imds, 0.7, 0.15, 0.15, 'randomized');

% 2. 特征提取
trainFeatures = extractHandcraftedFeatures(imdsTrain);
valFeatures = extractHandcraftedFeatures(imdsVal);
testFeatures = extractHandcraftedFeatures(imdsTest);

% 3. 数据增强
augmenter = imageDataAugmenter(...
    'RandRotation', [-20 20], ...
    'RandXReflection', true, ...
    'RandYReflection', true);

augmentedImdsTrain = augmentedImageDatastore([224 224], imdsTrain, ...
    'DataAugmentation', augmenter);
augmentedImdsVal = augmentedImageDatastore([224 224], imdsVal);
augmentedImdsTest = augmentedImageDatastore([224 224], imdsTest);

% 4. 构建网络
layers = [
    imageInputLayer([224 224 3], 'Name', 'input')
    
    convolution2dLayer(3, 16, 'Padding', 'same', 'Name', 'conv1')
    batchNormalizationLayer('Name', 'bn1')
    reluLayer('Name', 'relu1')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool1')
    
    convolution2dLayer(3, 32, 'Padding', 'same', 'Name', 'conv2')
    batchNormalizationLayer('Name', 'bn2')
    reluLayer('Name', 'relu2')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool2')
    
    convolution2dLayer(3, 64, 'Padding', 'same', 'Name', 'conv3')
    batchNormalizationLayer('Name', 'bn3')
    reluLayer('Name', 'relu3')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool3')
    
    convolution2dLayer(3, 128, 'Padding', 'same', 'Name', 'conv4')
    batchNormalizationLayer('Name', 'bn4')
    reluLayer('Name', 'relu4')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool4')
    
    globalAveragePooling2dLayer('Name', 'gap')
    
    fullyConnectedLayer(7, 'Name', 'fc')
    softmaxLayer('Name', 'softmax')
    classificationLayer('Name', 'output')
];

% 5. 训练选项
options = trainingOptions('adam', ...
    'InitialLearnRate', 0.001, ...
    'MaxEpochs', 30, ...
    'MiniBatchSize', 32, ...
    'ValidationData', {augmentedImdsVal, valFeatures}, ...
    'ValidationFrequency', 50, ...
    'Verbose', true, ...
    'Plots', 'training-progress', ...
    'ExecutionEnvironment', 'auto');

% 6. 训练网络
net = trainNetwork(augmentedImdsTrain, layers, options);