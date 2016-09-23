function [ M ] = classifyImageFitCDISCR(filter,img, param)

subParam = 1:param.n; % subset of parameters
subFilter = filter(:,subParam);

imgClassify.Method = 'diaglinear';
imgClassify.nHold = 2;  %hold nn out of the 40 in each group
imgClassify.nReps = 1000;  %repeat and average

%determine the group number for each image (1-5)
for i=1:length(img.group)
    groupNum(i) = find(strncmp(img.group{i},img.groupList,length(img.group{i})));
end

%find indices for which images belong to each group
clear groupId
for i=1:img.nGroups
    groupId{i} = find(groupNum==i);
end

M = zeros(size(img.group,2),1);

% Randomly select 2 out of the 40 images from each group to be the test
% images and the rest are the train images
DAC =fitcdiscr(subFilter, img.group,'DiscrimType', imgClassify.Method, 'Kfold', 20);

% kfoldPredict = Predict response for observations not used for training
class=kfoldPredict(DAC);    

for j=1:length(class)
    % strncmp--compare 1st n char of strings
    M(j)=strcmp(class{j},img.group{j});
end

PerCor=100*(sum(M)./length(M));
