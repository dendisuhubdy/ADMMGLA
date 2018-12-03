function sigr = iSTFT(C,win,skip,winLen,Ls)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                             inverse STFT
%
%%% -- Input --------------------------------------------------------------
% C     : spectrograms (freq x time)
% win   : synthesis window (winLen x 1)
% skip  : skipping samples (1 x 1)
% winLen: window length (1 x 1)
% Ls    : signal length (1 x 1)
%
% !! Attention !!
% length(sig) = Ls = win + skip x N
% where N in natural numbers 
%
%
%%% -- Output -------------------------------------------------------------
% sigr  : signal (samples x 1)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hWL = floor(winLen/2);
C = C.*exp(+2i*pi*(mod((0:hWL)'*(0:size(C,2)-1)*skip,winLen)/winLen));
sigr = fftshift(ifft([C;zeros(size(C)-[2,0])],'symmetric'),1).*win;
idx = (1:winLen)' + (0:skip:Ls-winLen);
idx2 = repmat(1:size(C,2),winLen,1);
sigr = full(sum(sparse(idx(:),idx2(:),sigr(:)),2));
sigr = circshift(sigr,-winLen/2);
end
