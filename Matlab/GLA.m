function sigr = GLA(X,A,Iter,win,windual,skip,winLen,Ls)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                          Griffin-Lim Algorithm
%
% D. Griffin and J. Lim, "Signal estimation from modified short-time
% Fourier transform," IEEE Trans. Acoust., Speech, Signal Process., vol.
% 32, no. 2, pp. 236-243, Apr. 1984.
%
%%% -- Input --------------------------------------------------------------
% X      : initial complex-valued spectrogram (freq x time)
% A      : given amplitude spectrogram (freq x time)
% Iter   : iteration number (1 x 1)
% win    : analysis window (winLen x 1)
% windual: synthesis window (winLen x 1)
% skip   : skipping samples (1 x 1)
% winLen : window length (1 x 1)
% Ls     : signal length (1 x 1)
%
% !! Attention !!
% length(sig) = Ls = win + skip x N
% where N in natural numbers 
%
%
%%% -- Output -------------------------------------------------------------
% sigr    : reconstructed signal (Ls x 1)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pc2 = @(X) A.*sign(X);
Pc1 = @(X) STFT(iSTFT(X,windual,skip,winLen,Ls),win,skip,winLen,Ls);

for m = 1:Iter
    
    X = Pc1(Pc2(X));
    
end

sigr = iSTFT(X,windual,skip,winLen,Ls);
end
