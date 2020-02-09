clear; close all; clc
load Testdata % load data from 20 measurements
L=15; % spatial domain
n=64; % fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x; % evenly spaced positions values
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; % scaled frequency values
ks=fftshift(k); % shifted frequency values
[X,Y,Z]=meshgrid(x,y,z); % 3D grid of position values
[Kx,Ky,Kz]=meshgrid(ks,ks,ks); % 3D grid of frequency values

% Plots the data at time 1 before averaging and reducing noise.
Un(:,:,:)=reshape(Undata(1,:),n,n,n);
close all; isosurface(X,Y,Z,abs(Un),0.4)
grid on; drawnow
set(gca,'FontSize',15)
xlabel('Kx'); ylabel('Ky'); zlabel('Kz');
title('Fourier Transform of Data at Time 1', 'Fontsize', 25);
grid on; drawnow
print('time_1', '-dpng');

% The following code averages the 20 data measurements in Undata and
% uses fftn to convert them to frequency space.
avg = zeros(n,n,n);
for t=1:20
   Un(:,:,:) = reshape(Undata(t,:),n,n,n);
   avg = avg + fftn(Un);
end
avg = avg/20;

% Plots the averaged measurements from above in frequency space.
% In order to graph correctly, the data is shifted using fftshift
close all;
isosurface(Kx, Ky, Kz, fftshift(abs(avg))/max(abs(avg),[],'all'),0.99)
set(gca,'FontSize',15)
xlabel('Kx'); ylabel('Ky'); zlabel('Kz');
title('Fourier Transform of Averaged Data', 'Fontsize', 25);
grid on; drawnow
print('average', '-dpng');

% Uses the maximum value of the averaged data set in order to find
% the indices of the center x,y, and z frequencies.
max_val = max(abs(avg),[],'all'); % find maximum value across all averaged data
a_avg = abs(avg);
[i_max,j_max,k_max] = ind2sub(size(a_avg),find(a_avg == max_val)); % indices of max value

% Uses indices from above to set filter center.
k0_x = Kx(i_max,j_max,k_max); % x frequency
k0_y = Ky(i_max,j_max,k_max); % y frequency
k0_z = Kz(i_max,j_max,k_max); % z frequency 

tau = 20; % filter width

filter = exp(-tau.*((Kx-k0_x).^2+(Ky-k0_y).^2+(Kz-k0_z).^2)); % create filter

% Initiazes vectors to hold values for location of marble at each time.
x_path = zeros(1,20);
y_path = zeros(1,20);
z_path = zeros(1,20);

% Loop goes through each of the 20 data measurements. Applies filter each
% time and plots the filtered data with reduced noise using isosurface.
% Also determines the center of the data at each measurement and saves
% those x, y, and z values in the vectors created above to mark the path of
% the marble.
close all;
for t = 1:20
    Un(:,:,:) = reshape(Undata(t,:),n,n,n);
    Un = filter.*fftn(Un);
    Un = ifftn(Un);
    isosurface(X,Y,Z,abs(Un)/max(abs(Un),[],'all'),0.99)
    grid on; drawnow
    hold on
    max_val = max(abs(Un),[],'all');
    [i_max,j_max,k_max] = ind2sub(size(Un),find(abs(Un) == max_val));
    x_path(t) = X(i_max,j_max,k_max);
    y_path(t) = Y(i_max,j_max,k_max);
    z_path(t) = Z(i_max,j_max,k_max);
end
set(gca,'FontSize',15)
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Marble Point Path', 'Fontsize', 25);
print(iso_path','-dpng');

% Plots the path of the marble over time.
close all;
plot3(x_path,y_path,z_path);
set(gca,'FontSize',15)
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Marble Line Path', 'Fontsize', 25); 
grid on; drawnow
print('path', '-dpng');

% Saves location of marble at 20th time measurement.
final_location = [x_path(20), y_path(20), z_path(20)];
