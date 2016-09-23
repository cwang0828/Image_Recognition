function [ img ] = storeGroupInfo( imgInfo )

% Find # of groups and list of group names
img.group = {};
for i = 1:size(imgInfo,2)
    img.group{i} = imgInfo(i).igroup;
end

img.groupList = unique(img.group);  % list of group names
img.nGroups = length(img.groupList);    % number of groups

%determine the group number for each image (1-5)
for i = 1:length(img.group)
    img.groupNum(i) = find(strncmp(img.group{i}, ...
        img.groupList,length(img.group{i})));
end

save('img.mat', 'img');
save('imgInfo.mat','imgInfo');

% load img.mat
% load imgInfo.mat

end


