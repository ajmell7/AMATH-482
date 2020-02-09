% Section 13.3
clear; close all; clc

L = 30;
n = 512;

t2 = linspace(-L,L,n+1); 
t = t2(1:n);
k = (2*pi/(2*L))*[0:(n/2-1) -n/2:-1];
ks = fftshift(k);  % We define this so we don't need to use fftshift(k) every time we plot
u=sech(t);
ut = fft(u);

noise = 10;
utn = ut+noise*(randn(1,n)+1i*randn(1,n)); 

figure(1)
plot(ks,fftshift(abs(utn))/max(abs(utn)),'r','Linewidth',2)
set(gca,'Fontsize',16)
xlabel('frequency (k)')
ylabel('|ut|')

%% Average together two noisy signals
ave = zeros(1,n);
for j=1:2
    utn=ut+noise*(randn(1,n)+1i*randn(1,n));
    ave = ave+utn;
end
ave = abs(fftshift(ave))/2;

figure(2)
plot(ks,ave/max(ave),'r','Linewidth',2)
set(gca,'Fontsize',16)
xlabel('frequency (k)')
ylabel('|ut|')

%% Average together 5 noisy signals
ave = zeros(1,n);
for j=1:5
    utn=ut+noise*(randn(1,n)+1i*randn(1,n));
    ave = ave+utn;
end
ave = abs(fftshift(ave))/5;

figure(3)
plot(ks,ave/max(ave),'r','Linewidth',2)
set(gca,'Fontsize',16)
xlabel('frequency (k)')
ylabel('|ut|')

%% Compare the average of (a) 1, (b) 2, (c) 5, and (d) 100 noisy signals
clear; clc
figure(4)

L = 30;
n = 512;

t2 = linspace(-L,L,n+1); 
t = t2(1:n);
k = (2*pi/(2*L))*[0:(n/2-1) -n/2:-1];
ks = fftshift(k);

noise = 10;
labels=['(a)';'(b)';'(c)';'(d)'];
realize=[1 2 5 100];
for jj=1:length(realize)
    u = sech(t);
    ave = zeros(1,n);
    ut = fft(u);
    for j=1:realize(jj)
        utn(j,:)=ut+noise*(randn(1,n)+1i*randn(1,n));
        ave = ave+utn(j,:);
    end
    ave = abs(fftshift(ave))/realize(jj);
    
    subplot(4,1,jj)
    plot(ks,ave/max(ave),'r','Linewidth',2)
    set(gca,'Fontsize',16)
    axis([-20 20 0 1])
    text(-18,0.7,labels(jj,:),'Fontsize',16) 
    ylabel('|fft(u)|','Fontsize',16)
end
hold on
plot(ks,abs(fftshift(ut))/max(abs(ut)),'k:','Linewidth',2)
set(gca,'Fontsize',16)
xlabel('frequency (k)')

%% Show fft's of 21 shifted sech functions
slice=0:0.5:10;
[T,S]=meshgrid(t,slice);
[K,S]=meshgrid(k,slice);

U=sech(T-10*sin(S)).*exp(1i*0*T);
figure(5)
subplot(2,1,1)
waterfall(T,2*S+1,U), colormap([0 0 0]), view(-15,70)
set(gca,'Fontsize',15,'Xlim',[-30 30],'Zlim',[0 2])
xlabel('time (t)'), ylabel('realizations'), zlabel('|u|')

for j=1:length(slice)
    Ut(j,:)=fft(U(j,:));
    Kp(j,:)=fftshift(K(j,:));
    Utp(j,:)=fftshift(Ut(j,:));
    Utn(j,:)=Ut(j,:)+noise*(randn(1,n)+i*randn(1,n));
    Utnp(j,:)=fftshift(Utn(j,:))/max(abs(Utn(j,:)));
    Un(j,:)=ifft(Utn(j,:));
end
subplot(2,1,2)
waterfall(Kp,2*S+1,abs(Utp)/max(abs(Utp(1,:)))), colormap([0 0 0]), view(-15,70)
set(gca,'Fontsize',15,'Xlim',[-28 28])
xlabel('frequency (k)'), ylabel('realizations'), zlabel('|fft(u)|')

%% Show fft's of 21 shifted noisy signals
figure(6)
subplot(2,1,1)
waterfall(T,2*S+1,abs(Un)), colormap([0 0 0]), view(-15,70)
set(gca,'Fontsize',15,'Xlim',[-30 30],'Zlim',[0 2])
xlabel('time (t)'), ylabel('realizations'), zlabel('|u|')

subplot(2,1,2)
waterfall(Kp,2*S+1,abs(Utnp)/max(abs(Utnp(1,:)))), colormap([0 0 0]), view(-15,70)
set(gca,'Fontsize',15,'Xlim',[-28 28])
xlabel('frequency (k)'), ylabel('realizations'), zlabel('|fft(u)|')

%% Compare average in time domain to average in frequency domain
Uave=zeros(1,n);
Utave=zeros(1,n);
for j =1:length(slice)
    Uave=Uave+Un(j,:);
    Utave=Utave+Utn(j,:);
end
Uave=Uave/length(slice);
Utave=fftshift(Utave)/length(slice);

figure(7)
subplot(2,1,1)
plot(t,abs(Uave),'k','Linewidth',2)
set(gca,'Fontsize',15)
xlabel('time (t)')
ylabel('|u|')

subplot(2,1,2)
plot(ks,abs(Utave)/max(abs(Utave)),'r','Linewidth',2)
hold on
plot(ks,abs(fftshift(Ut(1,:)))/max(abs(Ut(1,:))),'k:','Linewidth',2)
axis([-20 20 0 1])
set(gca,'Fontsize',15)
xlabel('frequency (k)')
ylabel('|fft(u)|')