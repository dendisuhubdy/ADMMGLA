function sigr = FGLA(X,A,Iter,alpha,win,windual,skip,winLen,LS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                       Fast Griffin-Lim Algorithm
%
% N. Perraudin, P. Balazs, and P. L. Sondergaard, "A fast Griffin-Lim
% algorithm," in IEEE Workshop Appl. Signal Process. Audio Acoust.,
% Oct. 2013, pp. 1-4.
%
%
%%% -- Input --------------------------------------------------------------
% X      : initial complex-valued spectrogram (freq x time)
% A      : given amplitude spectrogram (freq x time)
% Iter   : iteration number (1 x 1)
% alpha  : hyperparameter (1 x 1)
% win    : analysis window (winLen x 1)
% windual: synthesis window (winLen x 1)
% skip   : skipping samples (1 x 1)
% winLen : window length (1 x 1)
% Ls     : signal length
%
% !! Attention !!
% length(sig) = Ls = win + skip x N
% where N in natural numbers 
%
%%% -- Output -------------------------------------------------------------
% sigr    : reconstructed signal (Ls x 1)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pc2 = @(X) A.*sign(X);
Pc1 = @(X) STFT(iSTFT(X,windual,skip,winLen,LS),win,skip,winLen,LS);

Y = X;

for m = 1:Iter
    
    Xold = X;
    X = Pc1(Pc2(Y));
    Y = X+alpha*(X-Xold);
    
end

sigr = iSTFT(X,windual,skip,winLen,LS);
end

