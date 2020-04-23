function detectedSignal = coherentDetector(modulatedSig, Fc, t, type)
  carrier = cos(2*pi*Fc*t);
  demodSignal = modulatedSig .* transpose(carrier);
  switch(type)
    case 'butterworth'
      [b, a] = butter(3, Fc/(Fc * 5 / 2));
      detectedSignal = filter(b, a, demodSignal);
    case 'normal'
      detectedSignal = lowPassFilter(demodSignal, 4e3, 5 * Fc);
    otherwise
      detectedSignal = 0;
  end
      
end