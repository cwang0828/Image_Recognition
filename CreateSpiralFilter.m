function [ SAF,param ] = CreateSpiralFilter( imgInfo,I)

% # of parameters (n) and standard deviation(sig) for each image
param.n =20;  
param.sig = .005;


% Filter images using spatial angular frequency
SAF = zeros(size(imgInfo,2),param.n);

SFList = linspace(0,.05,param.n); % try a smaller range of sf's (e.g. 0 - .1);
AList = linspace(0,180,(param.n)+1);
AList = AList(1:end-1);

for j = 1:size(imgInfo,2)
    name = imgInfo(j).igroup;
    if (strcmp(name,'city') == 1) || (strcmp(name,'coast') ==1)
        param.sig(j) = .01; % standard deviation
    else 
        param.sig(j) = .005;
    end
end

count = 0;
% filter the images using spatial frequencies
for k=1:length(AList)
    for j = 1:size(imgInfo,2)
        temp = I(j);
        AP(j).sig = 15;
        for i=1:length(AList)
            count = count +1;
            SFfilt = exp(-(temp.sf-SFList(i)).^2/param.sig(j)^2);
            SFfilt = SFfilt/sum(SFfilt(:));
            
            AP(j).mu = AList(i);
            
            
            Afilt = VonMisesPDF(AP(j),temp.angle);
            Afilt = Afilt.*(temp.sf<.04);
            Afilt = Afilt/sum(Afilt(:));
            
            SAFfilt = SFfilt.*Afilt;
            
            SAF(j,i) = temp.amp(:)'*SAFfilt(:);
            
        end
    end
end






% % Filter images using spatial angular frequency
% SAF = zeros(size(imgInfo,2),param.n);
% 
% SFList = linspace(0,.05,param.n);
% AList = linspace(0,180,(param.n)+1);
% AList = AList(1:end-1);
% 
% 
% % filter the images using spatial frequencies
% for j = 1:size(imgInfo,2)
%     temp = I(j);
%     AP(j).sig = 15;
%     for i=1:length(AList)
%         SFfilt = exp(-(temp.sf-SFList(i)).^2/param.sig^2);
%         
%         SFfilt = SFfilt/sum(SFfilt(:));
%         
%         AP(j).mu = AList(i);
%         Afilt = VonMisesPDF(AP(j),temp.angle);
%         Afilt = Afilt.*(temp.sf<.04);
%         Afilt = Afilt/sum(Afilt(:));
%         
%         SAFfilt = SFfilt.*Afilt;
%         SAF(j,i) = temp.amp(:)'*SAFfilt(:);
%     end
% end




