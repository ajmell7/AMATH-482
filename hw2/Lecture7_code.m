% Section 13.7

%% Construct signal and plot signal and FFT
clear; close all; clc

L=10; n=2048;
t2=linspace(0,L,n+1); t=t2(1:n); 
k=(2*pi/L)*[0:n/2-1 -n/2:-1]; 
ks=fftshift(k);

S=(3*sin(2*t)+0.5*tanh(0.5*(t-3))+ 0.2*exp(-(t-4).^2)... 
    +1.5*sin(5*t)+4*cos(3*(t-6).^2))/10+(t/20).^3;
St=fft(S);

figure(1)
subplot(2,1,1) 
plot(t,S,'k','Linewidth',2) 
set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('S(t)')

subplot(2,1,2) 
plot(ks,abs(fftshift(St))/max(abs(St)),'r','Linewidth',2); axis([-50 50 0 1])
set(gca,'Fontsize',16)
xlabel('frequency (\omega)'), ylabel('FFT(S)')


%% Construct Ganor window and add to time domain plot
tau = 4;
a = 1;
g = exp(-a*(t-tau).^2);
subplot(2,1,1)
plot(t,S,'k',t,g,'m','Linewidth',2) 
set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('S(t)')


%% Apply filter and take fft
Sg = g.*S;
Sgt = fft(Sg);

figure(2)
subplot(3,1,1) 
plot(t,S,'k','Linewidth',2) 
hold on 
plot(t,g,'m','Linewidth',2)
set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('S(t)')

subplot(3,1,2) 
plot(t,Sg,'k','Linewidth',2) 
set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('Sg(t)')

subplot(3,1,3) 
plot(ks,abs(fftshift(Sgt))/max(abs(Sgt)),'r','Linewidth',2); axis([-50 50 0 1])
set(gca,'Fontsize',16)
xlabel('frequency (\omega)'), ylabel('FFT(Sg)')

%% Change window size - wider window
tau = 4;
a = .2;
g = exp(-a*(t-tau).^2);
Sg = g.*S;
Sgt = fft(Sg);

figure(3)
subplot(3,1,1) 
plot(t,S,'k','Linewidth',2) 
hold on 
plot(t,g,'m','Linewidth',2)
set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('S(t)')

subplot(3,1,2) 
plot(t,Sg,'k','Linewidth',2) 
set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('Sg(t)')

subplot(3,1,3) 
plot(ks,abs(fftshift(Sgt))/max(abs(Sgt)),'r','Linewidth',2); axis([-50 50 0 1])
set(gca,'Fontsize',16)
xlabel('frequency (\omega)'), ylabel('FFT(Sg)')

%% Change window size - narrower window
tau = 4;
a = 5;
g = exp(-a*(t-tau).^2);
Sg = g.*S;
Sgt = fft(Sg);

figure(4)
subplot(3,1,1) 
plot(t,S,'k','Linewidth',2) 
hold on 
plot(t,g,'m','Linewidth',2)
set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('S(t)')

subplot(3,1,2) 
plot(t,Sg,'k','Linewidth',2) 
set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('Sg(t)')

subplot(3,1,3) 
plot(ks,abs(fftshift(Sgt))/max(abs(Sgt)),'r','Linewidth',2); axis([-50 50 0 1])
set(gca,'Fontsize',16)
xlabel('frequency (\omega)'), ylabel('FFT(Sg)')

%% Animation of shifting window
figure(5)
a = 1;
tslide=0:0.1:10;

for j=1:length(tslide)
    g=exp(-a*(t-tslide(j)).^2);  
    Sg=g.*S; 
    Sgt=fft(Sg); 
    
    subplot(3,1,1) 
    plot(t,S,'k','Linewidth',2) 
    hold on 
    plot(t,g,'m','Linewidth',2)
    hold off
    set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('S(t)')

    subplot(3,1,2) 
    plot(t,Sg,'k','Linewidth',2) 
    set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('Sg(t)')

    subplot(3,1,3) 
    plot(ks,abs(fftshift(Sgt))/max(abs(Sgt)),'r','Linewidth',2); axis([-50 50 0 1])
    set(gca,'Fontsize',16)
    xlabel('frequency (\omega)'), ylabel('FFT(Sg)')
    drawnow
    pause(0.1)
end

%% Calculate Gabor transform and plot spectrogram
a = 1;
tslide=0:0.1:10;
Sgt_spec = zeros(length(tslide),n);
for j=1:length(tslide)
    g=exp(-a*(t-tslide(j)).^2); 
    Sg=g.*S; 
    Sgt=fft(Sg); 
    Sgt_spec(j,:) = fftshift(abs(Sgt)); % We don't want to scale it
end

figure(6)
pcolor(tslide,ks,Sgt_spec.'), 
shading interp 
set(gca,'Ylim',[-50 50],'Fontsize',16) 
colormap(hot)

%% Spectrograms for varying window sizes
figure(7)

a_vec = [5 1 0.2];
for jj = 1:length(a_vec)
    a = a_vec(jj);
    tslide=0:0.1:10;
    Sgt_spec = zeros(length(tslide),n);
    for j=1:length(tslide)
        g=exp(-a*(t-tslide(j)).^2); 
        Sg=g.*S; 
        Sgt=fft(Sg); 
        Sgt_spec(j,:) = fftshift(abs(Sgt)); 
    end
    
    subplot(2,2,jj)
    pcolor(tslide,ks,Sgt_spec.'), 
    shading interp 
    title(['a = ',num2str(a)],'Fontsize',16)
    set(gca,'Ylim',[-50 50],'Fontsize',16) 
    colormap(hot) 
end


Sgt_spec = repmat(fftshift(abs(St)),length(tslide),1);
subplot(2,2,4)
pcolor(tslide,ks,Sgt_spec.'), 
shading interp 
title('fft','Fontsize',16)
set(gca,'Ylim',[-50 50],'Fontsize',16) 
colormap(hot) 

%% MATLAB's built-in spectrogram
figure(8)
spectrogram(S)
colormap(hot)

%% Put frequency on the vertical axis
figure(9)
spectrogram(S,'yaxis')
colormap(hot)

%% Control the size and overlap of the windows
figure(10)
spectrogram(S,300,280,'yaxis')
colormap(hot)

%% Zoom in on the important regions
figure(11)
spectrogram(S,300,280,'yaxis')
colormap(hot)
set(gca,'Ylim',[0 .1],'Fontsize',16)

%% Plot both positive and negative frequencies
figure(12)
spectrogram(S,300,280,'centered','yaxis')
colormap(hot)
set(gca,'Ylim',[-.1 .1],'Fontsize',16)

%% Add in the correct time and frequency axes
figure(13)
[Sp,w,times]=spectrogram(S,300,280,-50:.01:50,n/L);
pcolor(times,w,abs(Sp))
shading interp
colormap(hot)
set(gca,'Ylim',[-50 50],'Fontsize',16)

%% Zoom in on the important regions again
figure(14)
pcolor(times,w,abs(Sp))
shading interp
colormap(hot)
set(gca,'Ylim',[-10 10],'Fontsize',16)


%% Rescale our Gabor transform spectrograms to have the same units for frequency
figure(15)
k=(1/L)*[0:n/2-1 -n/2:-1]; 
ks=fftshift(k);

% Spectrograms for varying a
a_vec = [5 1 0.2];
for jj = 1:length(a_vec)
    a = a_vec(jj);
    tslide=0:0.1:10;
    Sgt_spec = zeros(length(tslide),n);
    for j=1:length(tslide)
        g=exp(-a*(t-tslide(j)).^2); 
        Sg=g.*S; 
        Sgt=fft(Sg); 
        Sgt_spec(j,:) = fftshift(abs(Sgt)); 
    end

    subplot(2,2,jj)
    pcolor(tslide,ks,Sgt_spec.'), 
    shading interp 
    title(['a = ',num2str(a)],'Fontsize',16)
    set(gca,'Ylim',[-10 10],'Fontsize',16) 
    colormap(hot) 
end


Sgt_spec = repmat(fftshift(abs(St)),length(tslide),1);
subplot(2,2,4)
pcolor(tslide,ks,Sgt_spec.'), 
shading interp 
title('fft','Fontsize',16)
set(gca,'Ylim',[-10 10],'Fontsize',16) 
colormap(hot) 
