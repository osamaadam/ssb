function filteredSignal = lowPassFilter(signal, threshold, Fs)
  d = designfilt('lowpassfir', 'FilterOrder', 8000, 'CutoffFrequency', threshold, 'SampleRate', Fs);
  filteredSignal = filter(d, signal);
end