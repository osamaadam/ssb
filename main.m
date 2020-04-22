clc;
clear;

[audio, Fs] = audioread('eric.wav');
s = length(audio) / Fs;
t = linspace(0, s, s*Fs + 1);
fs = linspace(-Fs/2, Fs/2, s*Fs + 1);

d = designfilt('lowpassfir', 'FilterOrder', 8000, 'CutoffFrequency', 4000, 'SampleRate', Fs);
filteredSig = filter(d, audio); % Low pass filter

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

% DSB-SC

modulatedSCSig = dsbSCMod(message, Fc, t); % DSC-SC Modulation

d = designfilt('lowpassfir', 'FilterOrder', 8000, 'CutoffFrequency', 1e5, 'SampleRate', Fs);
modulatedSCSig = filter(d, modulatedSCSig); % Low pass filter

figure; 
subplot(2,1,1);
plot(t, modulatedSCSig);
title('SSB-SC Time Domain')
subplot(2,1,2); 
plot(fs, real(fftshift(fft(modulatedSCSig))));
title('SSB-SC Frequency Domain')


% Coherent Detection

coherentSC = coherentDetector(modulatedSCSig, Fc, t); % DSB-SC coherent det
audiowrite('coherentSC.wav', coherentSC, Fs);

figure;
subplot(2, 1, 1);
plot(t, coherentSC);
title('Suppressed Carrier Coherent')
subplot(2, 1, 2);
plot(fs, real(fftshift(fft(coherentSC))));
title('Suppressed Carrier Coherent Spectrum');


