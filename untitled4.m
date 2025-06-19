%% Evaluate Class-Wise Performance
% 1. Get predictions
[YPred, ~] = classify(net, augmentedImdsTest);
YTest = imdsTest.Labels;

% 2. Create confusion matrix visualization
figure;
cm = confusionchart(YTest, YPred, ...
    'Title', 'Insulator Hydrophobicity Classification', ...
    'RowSummary', 'row-normalized', ...
    'ColumnSummary', 'column-normalized');
cm.FontSize = 12;

% 3. Calculate metrics per class
classNames = categories(YTest);
numClasses = numel(classNames);

metrics = table();
for i = 1:numClasses
    % Calculate TP/FP/FN
    TP = sum((YTest == classNames{i}) & (YPred == classNames{i}));
    FP = sum((YTest ~= classNames{i}) & (YPred == classNames{i}));
    FN = sum((YTest == classNames{i}) & (YPred ~= classNames{i}));
    
    % Compute metrics
    Precision = TP / (TP + FP);
    Recall = TP / (TP + FN);
    F1 = 2 * (Precision * Recall) / (Precision + Recall);
    Accuracy = TP / sum(YTest == classNames{i});
    
    % Store results
    metrics = [metrics; 
        table(classNames(i), Precision, Recall, F1, Accuracy, ...
        'VariableNames', {'Class', 'Precision', 'Recall', 'F1', 'Accuracy'})];
end

% 4. Display results
disp('Class-Wise Performance Metrics:');
disp(metrics);

% 5. Visualize accuracy
figure;
bar(metrics.Accuracy);
xticklabels(metrics.Class);
xlabel('Hydrophobicity Class');
ylabel('Accuracy');
title('Classification Accuracy per Class');
grid on;

% Add value labels
for i = 1:height(metrics)
    text(i, metrics.Accuracy(i), ...
        sprintf('%.2f', metrics.Accuracy(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontWeight', 'bold');
end