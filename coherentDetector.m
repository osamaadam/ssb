function detectedSignal = coherentDetector(modulatedSig, Fc, t)
  carrier = cos(2*pi*Fc*t);
  demodSignal = modulatedSig .* transpose(carrier);
  
  d = designfilt('lowpassfir', 'FilterOrder', 8000, 'CutoffFrequency', 4000, 'SampleRate', 5 * Fc);
  detectedSignal = filter(d, demodSignal);
  
end