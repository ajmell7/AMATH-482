%% Filter for overtones - Piano

[y,Fs] = audioread('music1.wav');
v = y.';
tr_piano=length(y)/Fs; 
L=tr_piano; n=length(v); 
t2=linspace(0,L,n+1); 
t=t2(1:n); 
k=(1/L)*[0:n/2-1 -n/2:-1];
ks=fftshift(k);
%vt = fft(v);
g = zeros(1,length(k));
for ii = 1:length(k)
    if k(ii) > 200 && k(ii) < 400
        g(ii) = 1;
    end
end

tslide=0:0.1:L;
vgt_spec = zeros(length(tslide),n);
for jj=1:length(tslide)
    vg=g.*v; 
    vgt=fft(vg); 
    vgt_spec(jj,:) = fftshift(abs(vgt));
end
pcolor(tslide,ks,vgt_spec.')
shading interp 
title('Piano Spectrogram','Fontsize',16)
ylim([0 600])
colorbar
colormap(hot)

%% Test filtering - Piano
clear; close all; clc

[y,Fs] = audioread('music1.wav');
v = y.';
tr_piano=length(y)/Fs;  % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Mary had a little lamb (piano)');
%p8 = audioplayer(y,Fs); playblocking(p8);

L=tr_piano; n=length(v); 
t2=linspace(0,L,n+1); 
t=t2(1:n); 
k=(1/L)*[0:n/2-1 -n/2:-1];
ks=fftshift(k);

a = 0.00005;
tslide=0:0.1:L;
vgt_spec = zeros(length(tslide),n);
for jj=1:length(tslide)
    g = exp(-a*(t-300).^2);
    vg=g.*v; 
    vgt=fft(vg); 
    vgt_spec(jj,:) = fftshift(abs(vgt));
end
pcolor(tslide,ks,vgt_spec.')
shading interp 
title('Piano Spectrogram','Fontsize',16)
ylim([200 1000]); % 200 to 400
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
colorbar
colormap(hot)


%% Code used to find frequencies when filtering for overtones
a = 1;
tslide=0:0.1:L;
index = zeros(2,length(tslide));
diff = zeros(1,length(tslide));
freq = zeros(1,length(tslide));


% Find frequencies

for ii = 1:length(tslide)
    g = exp(-a*(t-tslide(ii)).^2);
    vg=g.*v; 
    temp=fftshift(fft(vg)); 
    index(:,ii) = find(abs(temp) == max(abs(temp)));
    diff(ii) = index(2,ii) - index(1,ii);
    freq(ii) = ks(index(2,ii));
    freq(ii) = freq(ii);
end


%% Visual Depiction of Shannon Step Function

a = 1;
%tslide=0:0.1:L;
%step_1 = 1;
%step = fix(length(v)/length(tslide));
%step_2 = step;
step_1 = 1;
step_2 = 2000;

for j=1:72
    g = zeros(1,length(v));
    g(step_1:step_2) = 1;
    vg=g.*v;
    vgt=fft(vg);
    
    step_1 = step_1 + 1000;
    step_2 = step_2 + 1000;
    
    subplot(3,1,1) 
    plot(t,v,'k','Linewidth',2) 
    hold on 
    plot(t,g,'m','Linewidth',2)
    hold off
    set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('S(t)')

    subplot(3,1,2) 
    plot(t,vg,'k','Linewidth',2) 
    set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('Sg(t)')

    subplot(3,1,3) 
    plot(ks,abs(fftshift(vgt))/max(abs(vgt)),'r','Linewidth',2)
    set(gca,'Fontsize',16)
    xlabel('frequency (\omega)'), ylabel('FFT(vg)')
    drawnow
end

%% Visual Depiction of Mexican Hat Wavelet
%{
t_vec = [0.1, 0.5, 1];
for ii = 1:length(t_vec)
    tslide=0:t_vec(ii):L;
    vgt_spec = zeros(length(tslide),n);
    for jj=1:length(tslide)
        g =(1-(t-tslide(jj)).^2).*exp(-((t-tslide(jj)).^2)/2);
        vg=g.*v; 
        vgt=fft(vg); 
        vgt_spec(jj,:) = fftshift(abs(vgt)); % We don't want to scale it
    end
    subplot(length(t_vec),1,ii)
    pcolor(tslide,ks,vgt_spec.')
    shading interp 
    title(['a = ',num2str(t_vec(ii))],'Fontsize',16)
    colorbar
    colormap(hot)
end
%}
a = 100;
tslide=0:0.1:L;
for j=1:length(tslide)
    g =(1-a*(t-tslide(j)).^2).*exp(-(a*(t-tslide(j)).^2)/2);
    vg=g.*v;
    vgt=fft(vg);
    
    subplot(3,1,1) 
    plot(t,v,'k','Linewidth',2) 
    hold on 
    plot(t,g,'m','Linewidth',2)
    hold off
    set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('S(t)')

    subplot(3,1,2) 
    plot(t,vg,'k','Linewidth',2) 
    set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('Sg(t)')

    subplot(3,1,3) 
    plot(ks,abs(fftshift(vgt))/max(abs(vgt)),'r','Linewidth',2)
    set(gca,'Fontsize',16)
    xlabel('frequency (\omega)'), ylabel('FFT(vg)')
    drawnow
end