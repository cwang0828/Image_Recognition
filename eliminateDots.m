function [ imgInfo, fileName ] = eliminateDots( tifFiles )
% this function eliminates all the .files
% and returns a variable imgInfo that contains the group name 
% and number of the image

group = {};
num = [];
% fileName = {};
count = 0;
for j=1:length(tifFiles) %loop through the images    
    if ~strcmp(tifFiles(j).name(1),'.')
        count = count+1;
        %find the category and image number in the file name
        numid = regexp(tifFiles(j).name,'[0-9]');
        group{count} = tifFiles(j).name(1:(min(numid)-1));  % the group each image belongs to (e.g., city, coast, etc)
        num(count) = str2num(tifFiles(j).name(numid));  % the image number within the group (e.g, 1 2 3 ... 40)

        imgInfo(count).igroup = group{count};
        imgInfo(count).iNum = num(count);

        fileName{count} = tifFiles(j).name; % the complete file name of each image (e.g., city37.tif)
        %imgInfo(count).iName = fileName{count};
    end
end

end

