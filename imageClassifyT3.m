function [ M ] = imageClassifyT3(filter,img,param)

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

M = zeros(img.nGroups);

% Randomly select 2 out of the 40 images from each group to be the test
% images and the rest are the train images
for repNum = 1:imgClassify.nReps
    testId = [];
    trainId = [];
    for i=1:img.nGroups
        newId = shuffle(groupId{i});
        testId = [testId,newId(1:imgClassify.nHold)];  %these are the test images
        trainId = [trainId,newId(((imgClassify.nHold)+1):end)]; %these are the training images
    end
    
    for i=1:img.nGroups
        class = classify(subFilter(testId,:),subFilter(trainId,:), ...
        img.group(trainId),imgClassify.Method);
        for j=1:length(testId)            
            classNum = find(strncmp(class{j},img.groupList,length(img.group{i}))); % strncmp--compare 1st n char of strings
            M(classNum,groupNum(testId(j))) = M(classNum,groupNum(testId(j)))+1;
        end
    end
end

%turn into percent correct
M = M./repmat(sum(M),img.nGroups,1);
end


