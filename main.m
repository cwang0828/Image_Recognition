% @author Cindy Wang
% Last Revised Date: Jan 14, 2016

%%
% This section read images, transformed images into different gratings, and
% classified images using different filter functions

% Input all images into a matrix [# of images x 1]
tifFiles = dir('*.tif'); 

% Eliminates all .files and returns name, group, number of each image
[imgInfo,fileName] = eliminateDots(tifFiles);

% Create a structure (I) that stores info 
% (dc,ph, amp, sf, angle, freq, nPix) of each image
I = storeImageInfo(imgInfo,fileName);

% Find # of groups and List of group names
img = storeGroupInfo(imgInfo);
% save('img.mat','img');

%%
% Create different filter functions in the fourier spectrum

% [filter1,param1] = CreateSpiralFilter(imgInfo,I);
% save('filter1.mat', 'filter1');
% save('param1.mat','param1');
load filter1.mat
load param1.mat

% [filter2,param2,img2 ] = manuallySelectFilters(imgInfo, I, img);
% save('filter2.mat', 'filter2');
% save('param2.mat','param2');
% save('img2.mat','img2');
load filter2.mat
load param2.mat
load img2.mat

% [filter3, param3] = CreateCircleFilter(imgInfo, I);
% save('filter3.mat', 'filter3');
% save('param3.mat','param3');
load filter3.mat
load param3.mat

%% 
% Classify images based on different filters and parameters

% (Orignial) Classify Images and calculate percentage correct
% M1 = imageClassify(filter1,img,param1);
% M2 = imageClassify(filter2,img2,param2);
% M3 = imageClassify(filter3,img,param3);
% save('M1.mat', 'M1');
% save('M2.mat', 'M2');
% save('M3.mat', 'M3');
load M1.mat
load M2.mat
load M3.mat

% (New) Classify Images and calculate percentage correct
% !!!Something is wrong with classifyImageFitCDISCR, but I am not sure how 
% to fix it.

M1 = classifyImageFitCDISCR(filter1, img, param1);
% M2 = classifyImageFitCDISCR(filter2, img2, param2);
% M3 = classifyImageFitCDISCR(filter3, img, param3);

%%
% the filter and the percent correct 
% change here so you don't need to change the rest of the codes
newFilter = filter1;   % change filter1
newM = M1;   % change M

%% Hierarchical clustering

% list of images to analyze
id = 1:length(img.group);

% pdist calculates the pair-wise distances between images.  Default is
% 'Euclidean'.  Output is not a matrix, but a vector 200*199/2 length.
Y = pdist(newFilter(id,:),'euclidean');

% by deafult, the distance is Euclidean:
x1 = newFilter(1,:);
x2 = newFilter(2,:);
disp(sprintf('%g is the same as %g',sqrt(sum( (x1-x2).^2)),Y(1)))

% Show the similarities as a matrix.  Use 'squareform' to turn Y into a
% matrix.
figure(1)
imagesc(squareform(Y))
axis equal
axis tight
colorbar

%labeling...
xx = linspace(0,size(newFilter,1),11);
set(gca,'XTick',xx(2:2:end))
set(gca,'XTickLabel',img.groupList)

set(gca,'YTick',xx(2:2:end))
set(gca,'YTickLabel',img.groupList)

%%

% 'linkage' performs the heirarchical clustering.  Takes in the output of pdist (Y)
Z = linkage(Y,'average');

% dendrogram draws a tree diagram of the output of linkage.  
figure(2)
P = length(img.group);  % number of leaf nodes (0 and 200 show all images, or try 5 for example)

igroupPlusiNum = {};
for j = id
    igroupPlusiNum{j} = strcat(imgInfo(j).igroup, num2str(imgInfo(j).iNum));
end

dendrogram(Z,P,'Orientation','left','Labels',igroupPlusiNum(id))

%%
% 'cluster' categorizes the images into a predetermined number of clusters
% using the output of linkage (Z):

nClusters = img.nGroups;
T = cluster(Z,'maxclust',nClusters);

% show the identity of each image as a colored image
figure(3)
image(T')
colormap(hsv(nClusters))
colorbar

%%

% Run the same analysis on the average filter responses for each category.
        
aveGists = zeros(5,size(newFilter,2));
for i=1:5
    aveGists(i,:) = mean(newFilter(img.groupNum == i,:));
end

% same stuff - pdist, squareform, linkage
aveY = pdist(aveGists);

figure(4)
imagesc(squareform(aveY))
axis equal
axis tight
colorbar
set(gca,'YTick',1:5)
set(gca,'XTick',1:5)
set(gca,'YTickLabel',img.groupList)
set(gca,'XTickLabel',img.groupList)

%%

aveZ = linkage(aveY,'weighted');

figure(5)
dendrogram(aveZ,'Orientation','left','Labels',img.groupList)

%%
% This section viewed the percent correct in an nGroup by nGroup confusion matrix

figure(7)
clf
image(newM*100);
colormap(gray(100))
axis equal
axis tight
colorbar
set(gca,'XTick',1:length(img.groupList));
set(gca,'XTickLabel',img.groupList);
set(gca,'YTick',1:length(img.groupList));
set(gca,'YTickLabel',img.groupList);

hold on
for i=1:img.nGroups
    for j=1:img.nGroups
        pc(j,i)= newM(j,i)/sum(newM(:,i));
        text(i,j,sprintf('%3.0f',100*pc(j,i)),'HorizontalAlignment',...
            'center', 'Color','r','FontSize',16,'FontWeight','bold');
    end
end

pcNN = mean(diag(newM));   % the average probability 

xlabel('Actual category');
ylabel('Assigned category');
title(sprintf('pc: %5.2f%%',100*pcNN));



