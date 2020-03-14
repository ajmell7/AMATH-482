% This function takes in values for the sampled data and sampling rate for
% a given song clip. It returns the transformed data of this clip by
% finding the frequencies associated with the spectrogram.
function [spec] = get_spec(y, Fs)
v = y.';
L = 5;
n = Fs*L;
t2 = linspace(0,L,n+1); t = t2(1:n);
a = 1;
tslide=0:0.1:L;
spec = zeros(length(tslide),n);

for j=1:length(tslide)
    g=exp(-a*(t-tslide(j)).^2); 
    vg=g.*v; 
    vgt=fft(vg);
    spec(j,:) = fftshift(abs(vgt));
end

end
