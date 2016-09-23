function [ img, meanAmp ] = avgAmp(meanAmp,img,imgInfo,I)

img.numPerGroup = zeros(1,img.nGroups);

for num = 1:size(imgInfo,2)
    count = 1;
    repeat = 1;
    while repeat ~= 0
        name = imgInfo(num).igroup;
        imgAmp = I(num).amp(:)';
        if (strcmp(name,img.groupList(count))==1)
            img.numPerGroup(1,count)=img.numPerGroup(1,count)+1;
            meanAmp(count,:)=meanAmp(count,:)+imgAmp;
            count = 1;
            repeat = 0;
        else
            count = count + 1;
        end
    end
end

for q = 1:length(img.numPerGroup)
    meanAmp(q,:) = meanAmp(q,:)/img.numPerGroup(q);
end
