function modulatedSig = dsbSCMod(message, Fc, t)
  carrier = cos(2*pi*Fc*t);
  modulatedSig = message .* transpose(carrier);
end