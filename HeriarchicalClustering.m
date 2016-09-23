%HeirarchicalClustering.m

% load in data.  'allGists' is the matrix containing lists of weights for ]
% each image.  Rows are different images.

load('gistData_1x1');
groups = unique(group);

% use 'dir' to get unique file names (danger)
d = dir('Gist_Images/*.tif');
for i=1:length(d)
    igroup{i} = d(i).name;
end

%determine the group number for each image (1-5)
for i=1:length(group)
    groupNum(i) = find(strncmp(group{i},groups,length(group{i})));
end

% list of images to analyze
id =1:200;

% pdist calculates the pair-wise distances between images.  Default is
% 'Euclidean'.  Output is not a matrix, but a vector 200*199/2 length.


Y = pdist(allGists(id,:),'euclidean');

% by deafult, the distance is Euclidean:
x1 = allGists(1,:);
x2 = allGists(2,:);
disp(sprintf('%g is the same as %g',sqrt(sum( (x1-x2).^2)),Y(1)))

% Show the similarities as a matrix.  Use 'squareform' to turn Y into a
% matrix.

figure(1)
imagesc(squareform(Y))
axis equal
axis tight
colorbar

%labeling...
xx = linspace(0,size(allGists,1),11);
set(gca,'XTick',xx(2:2:end))
set(gca,'XTickLabel',groups)

set(gca,'YTick',xx(2:2:end))
set(gca,'YTickLabel',groups)

%%

% 'linkage' performs the heirarchical clustering.  Takes in the output of
% pdist (Y).  
Z = linkage(Y,'average');

% 'dendrogram draws a tree diagram of the output of linkage.  
figure(2)
P = 200;  %number of leaf nodes (0 and 200 show all images, or try 5 for example)
dendrogram(Z,P,'Orientation','left','Labels',igroup(id))

%%
% 'cluster' categorizes the images into a predetermined number of clusters
% using the output of linkage (Z):

nClusters = 5;
T = cluster(Z,'maxclust',nClusters);

% show the identity of each image as a colored image
figure(3)
image(T')
colormap(hsv(nClusters))
colorbar

%%

% Run the same analysis on the average filter responses for each category.

aveGists = zeros(5,size(allGists,2));
for i=1:5
    aveGists(i,:) = mean(allGists(groupNum==i,:));
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
set(gca,'YTickLabel',groups)
set(gca,'XTickLabel',groups)

%%

aveZ = linkage(aveY,'weighted');

figure(5)
dendrogram(aveZ,'Orientation','left','Labels',groups)

