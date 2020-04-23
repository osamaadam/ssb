clc;
clear;

[audio, Fs] = audioread('eric.wav');
s = length(audio) / Fs;
t = linspace(0, s, s*Fs + 1);
fs = linspace(-Fs/2, Fs/2, s*Fs + 1);

% Filtering

filteredSig = lowPassFilter(audio, 4e3, Fs);

audiowrite('filteredSig.wav', filteredSig, Fs);

figure;subplot(2, 1, 1)
plot(t, audio);
title('Before Filter')
subplot(2, 1, 2);
plot(t, filteredSig);
title('After Filter');

figure;
subplot(2, 1, 1);
plot(fs, real(fftshift(fft(audio))));
title('Before Filter');
subplot(2, 1, 2);
plot(fs, real(fftshift(fft(filteredSig))));
title('After Filter');

Fc = 100e3;
message = resample(filteredSig, 5 * Fc, Fs); % Upsampling signal to 5 * Fc
Fs = 5*Fc;
s = length(message)/Fs;
t = linspace(0, s, s*Fs);
fs = linspace(-Fs/2, Fs/2, s*Fs);

audiowrite('message.wav', message, Fs);

% Single Sideband Suppressed Carrier Modulation

modulatedSCSig = dsbSCMod(message, Fc, t); % DSC-SC Modulation
modulatedSCSig = lowPassFilter(modulatedSCSig, Fc, Fs);

figure; 
subplot(2,1,1);
plot(t, modulatedSCSig);
title('SSB-SC Time Domain')
subplot(2,1,2); 
plot(fs, real(fftshift(fft(modulatedSCSig))));
title('SSB-SC Frequency Domain')

% Coherent Detection

coherentSC = coherentDetector(modulatedSCSig, Fc, t, 'normal'); % DSB-SC coherent det
audiowrite('coherentSC.wav', coherentSC, Fs);

figure;
subplot(2, 1, 1);
plot(t, coherentSC);
title('Suppressed Carrier Coherent');
subplot(2, 1, 2);
plot(fs, real(fftshift(fft(coherentSC))));
title('Suppressed Carrier Coherent Spectrum');

% Butterworth Coherent Detection

butteredSig = coherentDetector(modulatedSCSig, Fc, t, 'butterworth');

figure;
subplot(2, 1, 1);
plot(t, butteredSig);
title('Suppressed Carrier Coherent (Butterworth)');
subplot(2, 1, 2);
plot(fs, real(fftshift(fft(butteredSig))));
title('Suppressed Carrier Coherent Spectrum (Butterworth)');

% Bad SNR

coherentSC10SNR = awgn(coherentSC, 10);
coherentSC30SNR = awgn(coherentSC, 30);

audiowrite('coherentSC10SNR.wav', coherentSC10SNR, Fs);
audiowrite('coherentSC30SNR.wav', coherentSC30SNR, Fs);

figure;
subplot(2, 1, 1);
plot(t, coherentSC10SNR);
title('Suppressed Carrier Coherent 10 SNR')
subplot(2, 1, 2);
plot(fs, real(fftshift(fft(coherentSC10SNR))));
title('Suppressed Carrier Coherent Spectrum 10 SNR');

figure;
subplot(2, 1, 1);
plot(t, coherentSC30SNR);
title('Suppressed Carrier Coherent 30 SNR')
subplot(2, 1, 2);
plot(fs, real(fftshift(fft(coherentSC30SNR))));
title('Suppressed Carrier Coherent Spectrum 30 SNR');

% Corrupted Coherent Detection

corruptedSignal = coherentDetector(modulatedSCSig, 100.1e3, t, 'normal');

figure;
subplot(2, 1, 1);
plot(t, corruptedSignal);
title('Corrupted Coherent - Time Domain')
subplot(2, 1, 2);
plot(fs, real(fftshift(fft(corruptedSignal))));
title('Corrupted Coherent - Frequency Domain');

% Transmitted Carrier Modulation

modulatedTCSig = dsbTCMod(message, Fc, t); 
modulatedTCSig = lowPassFilter(modulatedTCSig, Fc, Fs);

figure;
subplot(2, 1, 1);
plot(t, modulatedTCSig);
title('DSB-TC Time Domain');
subplot(2, 1, 2);
plot(fs, real(fftshift(fft(modulatedTCSig))));
title('DSB-TC Frequency Domain');

% Envelope Detection

envelopeTC = abs(hilbert(modulatedTCSig)); % DSB-TC envelope detection
audiowrite('envelopeTC.wav', envelopeTC, Fs);


figure;
subplot(2, 1, 1);
plot(t, envelopeTC);
title('Transmitted Carrier Envelope');
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(envelopeTC))));
title('Transmitted Carrier Envelope Spectrum');


