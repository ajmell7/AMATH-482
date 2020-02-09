%% Part 1 Data
clear; close all; clc

% Plots portion of music that will be analyzed
load handel
v = y';

% Plots music signal
plot((1:length(v))/Fs,v);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Signal of Interest, v(n)');


% Plays the music
%p8 = audioplayer(v,Fs);
%playblocking(p8);

% Initializes variables for length, time, frequency, and number of modes
L=9; % seconds
n=length(v); 
t2=linspace(0,L,n+1); t=t2(1:n); 
k=(1/L)*[0:(n-1)/2 -(n-1)/2:-1]; % frequency measures in hertz
ks=fftshift(k); 

%% Gaussian Filter Spectrogram
% Uses a guassian filter to create a spectrogram of the music frequencies
% over time. Changes the width of the filter for each iteration.
% In order to test for different translation distances, replace a_vec with
% a = 1 and change the tslide interval at each iteration as done for the 
% Mexican Hat wavelet below.
a_vec = [0.1 20];
for ii = 1:length(a_vec)
    a = a_vec(ii);
    tslide=0:0.1:L; 
    vgt_spec = zeros(length(tslide),n);
    for jj=1:length(tslide)
        g = exp(-a*(t-tslide(jj)).^2);
        vg=g.*v; 
        vgt=fft(vg); 
        vgt_spec(jj,:) = fftshift(abs(vgt));
    end
    subplot(1,length(a_vec),ii)
    pcolor(tslide,ks,vgt_spec.')
    shading interp 
    title(['Gaussian: \alpha = ',num2str(a)],'Fontsize',14)
    xlabel('Time (sec)'); ylabel('Frequency (Hz)');
    colorbar
    colormap(hot)
end

%% Mexican Hat Filter Spectrogram
% Uses a Mexican Hat filter to create a spectrogram of the music frequencies
% over time. Changes the translational distance of the filter for each 
% iteration.
% In order to test for different widths, replace t_vec with t = 0.1 and 
% change the a value at each iteration as done for the gaussian filter
% above.
t_vec = [0.1 1];
for ii = 1:length(t_vec)
    tslide=0:t_vec(ii):L;
    vgt_spec = zeros(length(tslide),n);
    for jj=1:length(tslide)
        g =(1-(t-tslide(jj)).^2).*exp(-((t-tslide(jj)).^2)/2);
        % Use this instead when changing width of Mexican Hat filter
        % g =(1-a*(t-tslide(jj)).^2).*exp(-(a*(t-tslide(jj)).^2)/2);
        vg=g.*v; 
        vgt=fft(vg); 
        vgt_spec(jj,:) = fftshift(abs(vgt));
    end
    subplot(1,length(t_vec),ii)
    pcolor(tslide,ks,vgt_spec.')
    shading interp 
    title(['Mexican Hat: step = ',num2str(t_vec(ii))],'Fontsize',14)
    xlabel('Time (sec)'); ylabel('Frequency (Hz)');
    colorbar
    colormap(hot)
end

%% Shannon Step-Function Filter Spectrogram
% Uses a Shannon Step-Function filter to create a spectrogram of the music
% frequencies over time. 

% Creates plot using filter width 4000 and step size 2000.
step_1 = 1;
step_2 = 4000;
step = 2000;
vgt_spec = zeros(35,n);
for jj=1:35
    g = zeros(1,length(v));
    g(step_1:step_2) = 1;
    vg=g.*v; 
    vgt=fft(vg); 
    vgt_spec(jj,:) = fftshift(abs(vgt));
    step_1 = step_1 + 2000;
    step_2 = step_2 + 2000;
end
subplot(1,2,1)
pcolor(1:35,ks,vgt_spec.')
shading interp 
title('Shannon: step = 2000','Fontsize',16)
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
colorbar
colormap(hot)

% Creates plot using filter width 200 and step size 100.
step_1 = 1;
step_2 = 200;
vgt_spec = zeros(729,n);
for jj=1:729
    g = zeros(1,length(v));
    g(step_1:step_2) = 1;
    vg=g.*v; 
    vgt=fft(vg); 
    vgt_spec(jj,:) = fftshift(abs(vgt));
    step_1 = step_1 + 100;
    step_2 = step_2 + 100;
end
subplot(1,2,2);
pcolor(1:729,ks,vgt_spec.')
shading interp 
title('Shannon: step = 100','Fontsize',16)
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
colorbar
colormap(hot)

%% Part 2 - Piano
clear; close all; clc

% Reads in the audio file and stores and plots the data.
[y,Fs] = audioread('music1.wav');
v = y.';
tr_piano=length(y)/Fs;  % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Mary had a little lamb (piano)');
%p8 = audioplayer(y,Fs); playblocking(p8); % Plays the music

% Initializes variables for length, time, frequency, and number of modes
L=tr_piano; n=length(v); 
t2=linspace(0,L,n+1); 
t=t2(1:n); 
k=(1/L)*[0:n/2-1 -n/2:-1];
ks=fftshift(k);

% Creates a spectrogram for the piano using a Gaussian filter.
a = 100; % filter width parameter
tslide=0:0.1:L; % translation distance
vgt_spec = zeros(length(tslide),n);
for jj=1:length(tslide)
    g = exp(-a*(t-tslide(jj)).^2);
    vg=g.*v; 
    vgt=fft(vg); 
    vgt_spec(jj,:) = fftshift(abs(vgt));
end
pcolor(tslide,ks,vgt_spec.')
shading interp 
title('Piano Spectrogram','Fontsize',16)
ylim([200 400]); % sets frequency limits for graph to remove overtones
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
colorbar
colormap(hot)

%% Part 2 - Recorder
clear; close all; clc

% Reads in the audio file and stores and plots the data.
[y,Fs] = audioread('music2.wav');
v = y.';
tr_rec=length(y)/Fs;  % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Mary had a little lamb (recorder)');
%p8 = audioplayer(y,Fs); playblocking(p8); % Plays the music

% Initializes variables for length, time, frequency, and number of modes
L=tr_rec; n=length(v); 
t2=linspace(0,L,n+1); 
t=t2(1:n); 
k=(1/L)*[0:n/2-1 -n/2:-1];
ks=fftshift(k);
vt = fft(v);

% Creates a spectrogram for the recorder using a Gaussian filter.
a = 100; % filter width parameter
tslide=0:0.1:L; % translation distance
vgt_spec = zeros(length(tslide),n);
for jj=1:length(tslide)
    g = exp(-a*(t-tslide(jj)).^2);
    vg=g.*v; 
    vgt=fft(vg); 
    vgt_spec(jj,:) = fftshift(abs(vgt));
end
pcolor(tslide,ks,vgt_spec.')
shading interp 
title('Recorder Spectrogram','Fontsize',16)
ylim([700 1100]); % sets frequency limits for graph to remove overtones
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
colorbar
colormap(hot)
