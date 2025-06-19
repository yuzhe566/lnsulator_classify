 % 1. 创建图像数据存储
imds = imageDatastore(dataPath, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');  % 自动用文件夹名作为标签

% 2. 获取所有类别名称
classNames = categories(imds.Labels);  % 这会列出HC1-HC7

% 3. 统计每个类别的图片数量
numImagesPerClass = countEachLabel(imds);

% 4. 显示结果
disp('=== 每个类别的图片数量 ===');
disp(numImagesPerClass);

% 5. 可视化显示（柱状图）
figure;
bar(numImagesPerClass.Count);
xticklabels(numImagesPerClass.Label);  % 显示HC1-HC7标签
xlabel('憎水性等级');
ylabel('图片数量');
title('HC1-HC7图片数量统计');
grid on;

% 在每个柱子上方显示具体数字
for i = 1:height(numImagesPerClass)
    text(i, numImagesPerClass.Count(i), ...
        num2str(numImagesPerClass.Count(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontWeight', 'bold', ...
        'FontSize', 10);
end