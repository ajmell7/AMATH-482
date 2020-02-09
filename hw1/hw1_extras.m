
%{
% plot graphs in each frequency space
avg_x = zeros(64,1);
avg_y = zeros(1,64);
avg_z = zeros(1,1,64);
for jj = 1:64
    for kk = 1:64
        avg_x = avg_x + avg(:,jj,kk);
        avg_y = avg_y + avg(jj,:,kk);
        avg_z = avg_z + avg(jj,kk,:);
    end
end

figure(1)
avg_x = avg_x/4096;
avg_x = avg_x.';
plot(ks, abs(fftshift(avg_x)))

figure(2)
avg_y = avg_y/4096;
plot(ks, abs(fftshift(avg_y)))

figure(3)
avg_z = avg_z/4096;
avg_z = reshape(avg_z,1,n);
plot(ks, abs(fftshift(avg_z)))
%}


%{
% filter all data and plot at each time 
k0_x = 2.723;
k0_y = 0.2094;
k0_z = 5.864;

tau = 1; % set filter width
filter_x = exp(-tau*(k-k0_x).^2); % filter
filter_y = exp(-tau*(k-k0_y).^2); % filter
filter_z = exp(-tau*(k-k0_z).^2); % filter

data_x = zeros(64,1);
data_y = zeros(1,64);
data_z = zeros(1,1,64);

point_x = zeros(20,1); point_y = zeros(20,1); point_z = zeros(20,1);

for ii = 1
    data = reshape(Unt(ii,:),n,n,n);
    for jj = 1:64
        for kk = 1:64
            data_x(jj,kk) = data(:,jj,kk).*filter_x;
            data_x = data_x.';
            data_y = data(jj,:,kk).*filter_y;
            data_z = data(jj,kk,:).*filter_z;
            data_z = reshape(data_z,1,n);
        end
    end
    figure(1)
    data_x = abs(ifft(data_x));
    plot(x,data_x)
    data_y = abs(ifft(data_y));
    figure(2)
    plot(y,data_y)
    data_z = abs(ifft(data_z));
    figure(3)
    plot(z,data_z)
    result_x = find(data_x == max(data_x));
    result_y = find(data_y == max(data_y));
    result_z = find(data_z == max(data_z));
    point_x(ii) = x(result_x)
    point_y(ii) = y(result_y)
    point_z(ii) = z(result_z)
    %plot3(point_x, point_y, point_z)
end
%}

%{
freq = mean(mean(mean(abs(avg))));
isosurface(X,Y,Z,(abs(avg)), freq)
%}

%{
freq = mean(mean(mean(abs(avg)))); % center of frequency???

tau = 1; % set filter width
k0 = 2.723; % set filter center
filter = exp(-tau*(k-k0).^2); % filter
%}

%{
avg_f = filter.*avg; % filtered in frequency domain
avg_t=ifft(avg_f); % filtered in time domain 
%}

%{
% filtered x
x_f = filter.*avg_x;
x_i = ifft(x_f);
figure(4)
plot(ks,fftshift(abs(x_f)))
figure(5)
plot(x, abs(x_i))

% filtered y
y_f = filter.*avg_y;
y_i = ifft(y_f);
figure(4)
plot(ks,fftshift(abs(y_f)))
figure(5)
plot(y, abs(y_i))


% filtered z
z_f = filter.*avg_z;
z_i = ifft(z_f);
figure(4)
plot(ks,fftshift(abs(z_f)))
figure(5)
plot(z, abs(z_i))
%}


%{
% filtered signal time domain
figure(2)
isosurface(X,Y,Z,abs(fftshift(avg_t)))
%}



%{
% filter all data and plot at each time 
tau = 0.2; % set filter width
for t = 1:20
    trial = reshape(Undata(t,:),n,n,n);
    trial = fftn(trial);
    for ii = 1:64
        for jj = 1:64
            for kk = 1:64
                filter = exp(-tau*((k(ii)-k0_x).^2 + (k(jj)-k0_y).^2 + (k(kk)-k0_z).^2)); % filter
                trial(ii,jj,kk) = trial(ii,jj,kk)*filter;
            end
        end
    end
    trial = ifft(trial);
    %figure(t)
    %isosurface(X,Y,Z,abs(trial))
end
%}