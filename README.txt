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


Note:
The proposed algorithm is compared with the Griffin-Lim algorithm (GLA) [1] and the fast GLA (FGLA) [2].

In the letter, we used utterances in "TIMIT Database" contained in the "PhaseLab Toolbox" [3], and the babble noise in "NOISEX-92" [4].
Due to the licence, an utterance in "CMU Arctic Databases" [5] and the Gaussian noise are used in this example script.

The reconstructed signals were evaluated by PESQ [6], STOI [7], and the spectral convergence [8].
For evaluating PESQ and STOI, "pesq2" in "PhaseLab Toolbox" [3] and "taal2011" in "Auditory Modeling Toolbox" [9] were used.
Please download and i those toolboxes.

Note that we use our "STFT" and "iSTFT" for publishing this example script.
However, for the experiment in the letter, "Large Time-Frequency Analysis Toolbox" [10] was used for STFT and iSTFT.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% -- Reference ------------------------------------------------------------
% [1] D. Griffin and J. Lim, "Signal estimation from modified short-time
% Fourier transform," IEEE Trans. Acoust., Speech, Signal Process., vol.
% 32, no. 2, pp. 236-243, Apr. 1984.
%
% [2] N. Perraudin, P. Balazs, and P. L. Sondergaard, "A fast Griffin-Lim
% algorithm," in IEEE Workshop Appl. Signal Process. Audio Acoust.,
% Oct. 2013, pp. 1-4.
%
% [3] P. Mowlaee, J. Kulmer, J. Stahl, and F. Mayer, Single Channel
% Phase-Aware Signal Processing in Speech Communication: Theory and
% Practice, Wiley, 2016.
% (https://www2.spsc.tugraz.at/people/pmowlaee/PhaseLab.html)
%
% [4] A. Varga, H. J. M. Steeneken, M. Tomlinson, and D. Jones, "The NOISEX
% -92 study on the effect of additive noise on automatic speech
% recognition," Technical Report, DRA Speech Research Unit, 1992.
% (http://spib.linse.ufsc.br/noise.html)
%
% [5] John Kominek and Alan W Black, "The CMU Arctic Speech Databases," in
% Proc. 5th ISCA Speech Synthesis Workshop (SSW5), June 2004. pp. 223-224.
% (http://festvox.org/cmu_arctic/)
%
% [6] A. W. Rix, J. G. Beerends, M. P. Hollier, and A. P. Hekstra,
% "Perceptual evaluation of speech quality (PESQ) - A new method for speech
% quality assessment of telephone networks and codecs," in IEEE Int.
% Conf. Acoust., Speech Signal Process. (ICASSP), May 2001, vol. 19,
% pp. 2125-2136.
%
% [7] C. H. Taal, R. C. Hendriks, R. Heusdens, and J. Jensen, "An algorithm
% for intelligibility prediction of time-frequency weighted noisy speech,"
% IEEE Trans. Audio, Speech, Lang. Process., vol. 19, no. 7, pp. 2155-2136,
% 2011.
%
% [8] N. Strumel and L. Daudet, "Signal reconstruction from STFT magnitude:
% a state of the ar," in Int. Conf. Digit. Audio Effects (DAFx), Sept.
% 2011, pp. 375-386.
%
% [9] P. Sondergaard, and P. Majdak, "The Auditory Modeling Toolbox," in 
% The Technology of Binaural Listening, (Springer, Berlin, Heidelberg),
% pp. 33-56. 2013.
% (http://amtoolbox.sourceforge.net/)
%
% [10] Z. Prusa, P. L. Sondergaard, N. Holighaus, C. Wiesmeyr, and P. 
% Balazs, "The Large Time-Frequency Analysis Toolbox 2.0.," in Sound,
% Music, and Motion, Lecture Notes in Computer Science, pp. 419-442. 2014.
% (http://ltfat.github.io/)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
