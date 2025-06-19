function features = extractHandcraftedFeatures(imds)
    numImages = numel(imds.Files);
    features = zeros(numImages, 12);  % 修改1：将10改为12
    
    for i = 1:numImages
        img = readimage(imds, i);
        hsvImg = rgb2hsv(img);
        grayImg = rgb2gray(img);
        
        % 原特征计算（保持不动）
        hMean = mean2(hsvImg(:,:,1));
        sMean = mean2(hsvImg(:,:,2));
        vMean = mean2(hsvImg(:,:,3));
        hVar = std2(hsvImg(:,:,1));
        sVar = std2(hsvImg(:,:,2));
        glcm = graycomatrix(grayImg, 'Offset', [0 1; -1 1; -1 0; -1 -1]);
        stats = graycoprops(glcm, {'contrast', 'homogeneity', 'energy'});
        
        % ▶▶▶ 修改位置：特征组合 ◀◀◀
        features(i,:) = [hMean, sMean, vMean, hVar, sVar,...
                       mean(stats.Contrast), mean(stats.Homogeneity),...
                       mean(stats.Energy), entropy(grayImg),...
                       std2(grayImg),...                          % 原第10维
                       mean2(hsvImg(:,:,2)) - mean2(hsvImg(:,:,3)),... % 新增
                       entropy(grayImg)*std2(grayImg)];             % 新增
    end
    
    % 标准化（保持不动）
    features = (features - mean(features)) ./ std(features);
end