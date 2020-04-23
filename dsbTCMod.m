function modulatedSig = dsbTCMod(message, Fc, t)
  carrier = cos(2*pi*Fc*t);
  message = message + (max(message) * 2);
  modulatedSig = message .* transpose(carrier);
end