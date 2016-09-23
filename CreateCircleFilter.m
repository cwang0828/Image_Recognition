function [SAF, param] = CreateCircleFilter(imgInfo, I)

param.n =20;  % number of parameters for each image
param.sig = .008;   % standard deviation

SAF = zeros(size(imgInfo,2),param.n);

SFList = linspace(0,.05,param.n); % try a smaller range of sf's (e.g. 0 - .1);
AList = linspace(0,180,(param.n)+1);
AList = AList(1:end-1);

A = I(1).angle;
SF = I(1).sf;
i = 0;
allFilts = zeros(size(A)); % use this for imagesc
for ang =AList  %loop through filters
    for sf = SFList
        % constructing a spatial frequency filter
        SFfilt = exp(-(SF-sf).^2/param.sig^2);
        SFfilt = SFfilt/sum(SFfilt(:));
        
        % constructing an angular filter
        AP.sig = 15;
        AP.mu = ang;
        Afilt = VonMisesPDF(AP,A);
        Afilt = Afilt/sum(Afilt(:));
        
        % Combining the two filters
        SAFfilt = SFfilt.*Afilt;
        i=i+1;
        for j = 1:size(imgInfo,2) %loop through images
            SAF(j,i) = I(j).amp(:)'*SAFfilt(:);
        end        
        allFilts = allFilts+SAFfilt;
    end
end


end

