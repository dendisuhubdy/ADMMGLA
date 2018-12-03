%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% -- Example Script for ADMMGLA -------------------------------------------
%                                                                    
%                                                                   
% Coded by Y. Masuyama, (mas-03151102@akane.waseda.jp)                
% Copyright 2018 Yoshiki Masuyama                                     
%                                                                     
%
% # Reference
% Y. Masuyama, K. Yatabe, and Y. Oikawa, " Griffin-Lim Like Phase Recovery
% via Alternating Direction Method of Multipliers,"  IEEE Signal Process. 
% Lett., 2019.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% -- Options -----------------------------------------------------
addpath('Functions')
SNRopt = 3;   % 1: SNR 0dB, 2: SNR 20dB, 3: Clean
Iter = 10;    % iteration number for all algorithms

%% -- Hyperparameters ---------------------------------------------
% If alpha = 0.0, FGLA is equal to GLA
% If rho = 0.0, ADMMGLA is the proposed Alg. 1.
% If rho > 0.0, ADMMGLA becomes the proposed Alg. 2, and it coincides with
% GLA when rho = 1.0.

alpha = 0.99; % hyperparamter for FGLA (0.00 ~ 1.00)
rho = 0.00;   % hyperparamter for ADMMGLA (0.00 ~ 1.00)


%% -- Setup -------------------------------------------------------
% In this script, an utterance in "CMU Arctic Databases" [1] is used 
% instead of the utterances used in the experiments (in "TIMIT Database") 
% due to the license. (Please check 'README.txt').

filename = '../data/target.wav'; 
[target,fs] = audioread(filename);

winLen = 512;                   % window length (1 x 1)
skip = 216;                     % skipping samples (1 x 1)
win = hann(winLen,'periodic');  % analysis window (winLen x 1)
windual = winDual(win,skip);    % synthesis window (winLen x 1)

% !! Ls must be even number due to our STFT/iSTFT implementation !!
Ls = ceil((length(target)+2*(winLen-skip)-winLen)/skip)*skip+winLen;

% zero padding at both ends for adjusting the signal length
target = [zeros(winLen-skip,1);target; ...
    zeros(Ls-length(target)-2*(winLen-skip),1);zeros(winLen-skip,1)];

        
%% -- Magnitude calculation ---------------------------------------
% We consider two-type amplitude spectrograms for phase reconstruction:
% clean amplitude spectrogram and degraded one.

SNRset = {0,20,'clean'};
SNR = SNRset{SNRopt};

if strcmp(SNR,'clean')
    
    C = STFT(target,win,skip,winLen,Ls);  % clean spectrogram
    A = abs(C);
    
else
    
    % Degraded amplitude spectrogram is calculated by Wiener filter.
    % In this script, the Gaussian noise is used for degradation instead of
    % the babble noise due to the licence (Please check 'README.txt').
    
    noise = randn(Ls-2*(winLen-skip),1);
    noise =  [zeros(winLen-skip,1); noise; zeros(winLen-skip,1)];
    C = STFT(target,win,skip,winLen,Ls);  % clean spectrogram
    Cnoise = STFT(noise,win,skip,winLen,Ls);
    A = abs(C).^2./(abs(C).^2+abs(Cnoise).^2);  % ideal Wiener filter
    
end


%% -- Phase reconstruction ----------------------------------------
% The corresponding phase is reconstructed from a given amplitude by 
% GLA [2], FGLA [3], and the proposed algorithm (ADMMGLA).

X0 = A;  % initial complex-valued spectrogram
sig_gla = GLA(X0,A,Iter,win,windual,skip,winLen,Ls);
sig_fgla = FGLA(X0,A,Iter,alpha,win,windual,skip,winLen,Ls);
sig_admmgla = ADMMGLA(X0,A,Iter,rho,win,windual,skip,winLen,Ls);


%% -- Output ------------------------------------------------------
Normalize = @(x) x/max(abs(x));
audiowrite('../results/reconstructed_gla.wav',Normalize(sig_gla),fs);
audiowrite(['../results/reconstructed_fgla_', ...
    num2str(alpha,'%.2f'),'.wav'],Normalize(sig_fgla),fs);
audiowrite(['../results/reconstructed_admmgla_', ...
    num2str(rho,'%.2f'),'.wav'],Normalize(sig_admmgla),fs);


%% -- Evaluation --------------------------------------------------
% Here we evaluate the reconstructed signal by PESQ [4], STOI [5], and the
% spectral convergence [6].
% For evaluating PESQ and STOI, "PhaseLab Toolbox" and 
% "Auditory Modeling Toolbox" are required (Please check 'README.txt').
%
% sig_eval = sig_gla;
% PESQ= pesq2(target,sig_eval,fs);
% STOI = taal2011(target, sig_eval,fs);
% SpCon = norm(A-abs(STFT(sig_eval,win,skip,winLen,Ls)),'fro')/ ...
%              norm(A,'fro');  % spectral convergence


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% -- Reference ------------------------------------------------------------
% [1] John Kominek and Alan W Black, "The CMU Arctic Speech Databases," in
% Proc. 5th ISCA Speech Synthesis Workshop (SSW5), June 2004. pp. 223-224.
% (http://festvox.org/cmu_arctic/)
%
% [2] D. Griffin and J. Lim, "Signal estimation from modified short-time
% Fourier transform," IEEE Trans. Acoust., Speech, Signal Process., vol.
% 32, no. 2, pp. 236-243, Apr. 1984.
%
% [3] N. Perraudin, P. Balazs, and P. L. Sondergaard, "A fast Griffin-Lim
% algorithm," in IEEE Workshop Appl. Signal Process. Audio Acoust.,
% Oct. 2013, pp. 1-4.

% [4] A. W. Rix, J. G. Beerends, M. P. Hollier, and A. P. Hekstra,
% "Perceptual evaluation of speech quality (PESQ) - A new method for speech
% quality assessment of telephone networks and codecs," in IEEE Int.
% Conf. Acoust., Speech Signal Process. (ICASSP), May 2001, vol. 19,
% pp. 2125-2136.
%
% [5] C. H. Taal, R. C. Hendriks, R. Heusdens, and J. Jensen, "An algorithm
% for intelligibility prediction of time-frequency weighted noisy speech,"
% IEEE Trans. Audio, Speech, Lang. Process., vol. 19, no. 7, pp. 2155-2136,
% 2011.
%
% [6] N. Strumel and L. Daudet, "Signal reconstruction from STFT magnitude:
% a state of the ar," in Int. Conf. Digit. Audio Effects (DAFx), Sept.
% 2011, pp. 375-386.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
