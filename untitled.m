% 1. 设置数据路径（改成你自己的路径）
dataPath = 'E:\MATLAB3\data';

% 2. 创建图像数据存储
imds = imageDatastore(dataPath,...
    'IncludeSubfolders', true,...
    'LabelSource', 'foldernames');

% 3. 分割数据集
[imdsTrain, imdsVal, imdsTest] = splitEachLabel(imds, 0.7, 0.15, 0.15, 'randomized');