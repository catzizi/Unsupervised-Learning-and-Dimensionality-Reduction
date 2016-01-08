%analysis for k=2

load NucleusKmean.mat;
load NucleusKEM.mat

dat = textread('wdbc.data', '%s', 'delimiter', ',', 'emptyvalue', 0);
data = reshape(data, 32, 569 );
A = str2double(data(3:end, :));
L = double(cell2mat ( data(2,:) ) == 'M');

format short g
%NucleusKmean{4,1}(1,1:12)
%NucleusKmean{4,1}(2,1:12)
%NucleusKEM{4,1}(1:12,1)
%NucleusKEM{4,1}(1:12,2)


%n = sum(L(NucleusKmean{3,1} == 1)) / sum(NucleusKmean{3,1} == 1)
%n2 = sum(L(NucleusKmean{3,1} == 2)) / sum(NucleusKmean{3,1} == 2)

%n = sum(L(NucleusKEM{3,1} == 1)) / sum(NucleusKEM{3,1} == 1)
%n2 = sum(L(NucleusKEM{3,1} == 2)) / sum(NucleusKEM{3,1} == 2)

labels = cell(1, length(L));
for i=1:length(L)
    if L(i) == 1
        labels{1,i} = 'malignant';   
    else
        labels{1,i} = 'benign';   
    end
end

boxplot (A(1,:), L, 'labels', {'benign', 'malignant'} );
title ('Box-plot for attribute radius for cancer-dataset');
figure;
boxplot (A(8,:), L, 'labels', {'benign', 'malignant'});
title ('Box-plot for attribute symmetry for cancer-dataset');

figure;
plot ([ NucleusKEM{7,:} ])
title('Reconstruction error for EM algorithm applied to cancer-dataset');
xlabel('k');
ylabel('error');




