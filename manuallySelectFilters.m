function [filter,param,img] = manuallySelectFilters(imgInfo, I, img)

% Filter images using spatial angular frequency

SFList = linspace(.01,.05,3); % try a smaller range of sf's (e.g. 0 - .1);
AList = linspace(0,180,5);
AList = AList(1:end-1); %4 angles

param.sig = .008; % standard deviation
param.n = length(SFList)*length(AList);

filter = zeros(size(imgInfo,2),param.n);

A = I(1).angle;
SF = I(1).sf;

% filter the images using spatial frequencies
allFilts = zeros(size(A));
i=0;

% avg SAF filter for each group
meanAmp = zeros(img.nGroups, size(I(1).amp(:),1));   

% combine & average all the amplitudes of the same category
% and use this to decide what spatial frequuncy and amplitide
% info you are going to retain for each INDIVIDUAL image
[img,meanAmp] = avgAmp(meanAmp,img,imgInfo,I);
varAmp=var(meanAmp, 1);
[B,Index]=sort(varAmp, 'descend');
nFilters=12;
goodfilters=Index(1:12);
AgoodList=A(goodfilters);
SFgoodList=SF(goodfilters);

SFgoodList=[.0007 .0014 .002 .0026];
AgoodList=unique(AgoodList);
i=1;
for ang =AgoodList(1:3)  %loop through filters
    for sf = SFgoodList(1:3)
%         ang=Agood(g);
%         sf=SFgood(g);
        SFfilt = exp(-(SF-sf).^2/param.sig^2);
        SFfilt = SFfilt/sum(SFfilt(:));
        
        AP.sig = 15;
        AP.mu = ang;
        Afilt = VonMisesPDF(AP,A);
        Afilt = Afilt/sum(Afilt(:));
        
        SAFfilt = SFfilt.*Afilt;
        
        %loop through 200 images and find the avg amplitude that
        %corresponds to the given category
        % Then multiply that amplitude with the filter (SAFfilt)
        for j = 1:size(imgInfo,2)
            filter(j,i) = I(j).amp(:)'*SAFfilt(:);
        end
        i=i+1;
        allFilts = allFilts+SAFfilt;
    end
end


