% Section 15.3 Principal component analysis

%% Load weight/height data and plot
clear; close all; clc

load('weightheight.mat');

figure(1)
plot(X(1,:),X(2,:),'k.');
hold on
axis equal
xlabel('weight')
ylabel('height')
set(gca,'Fontsize',16)

%% Calculate reduced SVD
[U,S,V] = svd(X,'econ');

%% Calculate and plot the rank-1 approximation
X_rank1 = S(1,1) * U(:,1) * V(:,1)';
plot(X_rank1(1,:),X_rank1(2,:),'r.');

%% Draw in distance that is minimized (Frobenius norm)
plot([X(1,10) X_rank1(1,10)],[X(2,10) X_rank1(2,10)],'-g','Linewidth',2)

%% Plot sigma_1*u_1 (scaled appropriately)
n = 200;
y1 = S(1,1)/sqrt(n-1)*U(:,1);
c = compass(y1(1),y1(2));
set(c,'Linewidth',2);

%% Plot sigma_2*u_2 (scaled appropriately)
y2 = S(2,2)/sqrt(n-1)*U(:,2);
c = compass(y2(1),y2(2));
set(c,'Linewidth',2);

%% Projection onto principal components:
X_proj = U'*X;
figure(2)
plot(X_proj(1,:),X_proj(2,:),'k.');
axis equal
hold on
y1 = U'*y1;
y2 = U'*y2;
c = compass(y1(1),y1(2));
set(c,'Linewidth',2);
c = compass(y2(1),y2(2));
set(c,'Linewidth',2);


%% Create and plot 3D data
clear;

rng(5); % make random numbers be the same every time
n = 200; % number of data points
X = [3 6 4; 6 3 0; 4 0 1]*randn(3,n); % create n data points in 3d

[U,S,V] = svd(X,'econ');

figure(3)
plot3( X(1,:),X(2,:),X(3,:), 'k.');
title('PCA Example', 'Fontsize', 15)
daspect([1 1 1]);
axis vis3d
hold on
xlabel('x');
ylabel('y');
zlabel('z');

%% Compute rank-1 approximationa and plot
X_rank1 = U(:,1)*S(1,1)*V(:,1).';
plot3( X_rank1(1,:),X_rank1(2,:),X_rank1(3,:), 'r.'); 

%% Plot sigma_1*u_1
vec = S(1,1)/sqrt(n-1) * U(:,1);
quiver3( 0,0,0, vec(1),vec(2),vec(3),0, 'b', 'linewidth',5, 'maxheadsize',1);

%% Plot sigma_1*u_2
vec = S(2,2)/sqrt(n-1) * U(:,2);
quiver3( 0,0,0, vec(1),vec(2),vec(3),0, 'b', 'linewidth',5, 'maxheadsize',1);

%% Plot rank-2 approximation
% X_rank2 = U(:,1)*S(1,1)*V(:,1)'+U(:,2)*S(2,2)*V(:,2)'; Bad way
X_rank2 = U(:,1:2)*S(1:2,1:2)*V(:,1:2)'; % Good way
plot3( X_rank2(1,:),X_rank2(2,:),X_rank2(3,:), 'g.');

%% Creat new 3D data (all falls on a line)
clear;

t = -5:.05:5;
x = 5*t;
y = 4*t;
z = -6*t;
X = [x; y; z];

figure(4)
plot3( X(1,:),X(2,:),X(3,:), 'k.');
daspect([1 1 1]);
axis vis3d
hold on
xlabel('x');
ylabel('y');
zlabel('z');

%% Calculate SVD and show singular values
[U,S,V] = svd(X,'econ');
S

%% Plot rank-1 approximation
X_rank1 = U(:,1)*S(1,1)*V(:,1).';
plot3( X_rank1(1,:),X_rank1(2,:),X_rank1(3,:), 'r.');
