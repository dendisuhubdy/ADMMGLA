# -*- coding: utf-8 -*-
"""
Created on Tue Dec  4 16:53:10 2018
@author: Yoshiki Masuyama

This script requires following additioal functions

winDual: calculate dual window
STFT   : calculate short-time Fourier transform
iSTFT  : calculate inverse short-time Fourier transform

Please replace 'my_modules' to your own modules.
"""
## Import
import numpy as np
from scipy import hanning
import my_modules as mine

def Pc1(X, win, windual, nfft, shift, T):
    x  = mine.myiSTFT(X, win, nfft, shift, T)
    Xr = mine.mySTFT(x, windual, nfft, shift, T)
    return Xr

def Pc2(X, A):
    return A*np.sign(X)


## Setup
filename = 'target.wav'
target, fs = mine.audioread(filename)

nfft    = 512
shift   = 216
win     = hanning(nfft)
windual = mine.winDual(win, shift)
maxiter = 10

## Adjust Signal length
# Because of the difference of the STFT/iSTFT imprementation, the adjusting
# rule is different from the code in the code ocean (in MATLAB).
T = int(np.floor((len(target) - nfft)/float(shift)))
target = target[0:(T-1)*shift+nfft]
target[0:shift] = 0.0
target[-shift:-1] = 0.0

## Consider only the clean case
C = mine.mySTFT(target, win, nfft, shift, T)
A = np.abs(C).astype(np.complex128)
Z = A

## GLA
for i in range(maxiter):
    X = Pc2(Z, A)
    Z = Pc1(X, win, windual, nfft, shift, T)
    
sig_gla = mine.myiSTFT(X, windual, nfft, shift, T)

## ADMMGLA
Z = A
U = np.zeros(Z.shape,Z.dtype)
for i in range(maxiter):
    X = Pc2(Z-U, A)
    Z = Pc1(X+U, win, windual, nfft, shift, T)
    U = U + X - Z
    
sig_admmgla = mine.myiSTFT(X, windual, nfft, shift, T)

## Output
#mine.audiowrite('gla.wav', mine.normalize(sig_gla), fs)
#mine.audiowrite('admmgla.wav', mine.normalize(sig_admmgla), fs)

