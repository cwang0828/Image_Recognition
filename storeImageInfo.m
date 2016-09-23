function [ I ] = storeImageInfo(imgInfo,fileName)
% process each image by creating a structure that store the 
% amplitudes and phases of each image
padFac = 2;
for j = 1:size(imgInfo,2)
    mydata{j} = imread(fileName{j});
    
    % avg across rgb to get a grayscale image
    mydata{j} = mean(mydata{j},3);
    mydata{j} = mydata{j} - mean(mydata{j}(:));
    nPix(j) = size(mydata{j},1);
    I(j) = complex2real2(fft2(mydata{j},nPix(j)*padFac, nPix(j)*padFac));
end

end
