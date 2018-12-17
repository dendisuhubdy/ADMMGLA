function sigr = ADMMGLA(X,A,Iter,rho,win,windual,skip,winLen,Ls)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            Proposed ADMMGLA
%
% Y. Masuyama, K. Yatabe, and Y. Oikawa, " Griffin-Lim Like Phase Recovery
% via Alternating Direction Method of Multipliers,"  IEEE Signal Process. 
% Lett., 2019.
%
%
%%% -- Input --------------------------------------------------------------
% X      : initial complex-valued spectrogram (freq x time)
% A      : given amplitude spectrogram (freq x time)
% Iter   : iteration number (1 x 1)
% rho    : hyperparameter (1 x 1)
% win    : analysis window (winLen x 1)
% windual: synthesis window (winLen x 1)
% skip   : skipping samples (1 x 1)
% winLen : window length (1 x 1)
% Ls: signal length (1 x 1)
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

Z = X;
U = zeros(size(X));

for m = 1:Iter
    
    X = Pc2(Z-U);
    Y = X+U;
    Z = (rho*Y+Pc1(Y))/(1+rho);
    U = U+X-Z;
    
end
sigr = iSTFT(X,windual,skip,winLen,Ls);
end
