
clear; close all; clc

% Load video data
load('cam1_1.mat')
load('cam1_2.mat')
load('cam1_3.mat')
load('cam1_4.mat')
load('cam2_1.mat')
load('cam2_2.mat')
load('cam2_3.mat')
load('cam2_4.mat')
load('cam3_1.mat')
load('cam3_2.mat')
load('cam3_3.mat')
load('cam3_4.mat')

%% Trial 1
close all; % closes open figures

% Trial 1 Camera 1
numFrames1 = size(vidFrames1_1,4); % number of video frames for camera 1
pointTracker = vision.PointTracker; % create PointTracker object
points1 = zeros(2, numFrames1); % initialize points1 matrix
I = vidFrames1_1(:,:,:,1); % first video frame for camera 1
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [319 228]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames1
    I = vidFrames1_1(:,:,:,ii);
    points1(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 1:numFrames1
    I = vidFrames1_1(:,:,:,ii);
    imshow(I);
    hold on
    plot(points1(1,ii),points1(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points1(1,:) = points1(1,:) - mean(points1(1,:));
points1(2,:) = points1(2,:) - mean(points1(2,:));


% Trial 1 Camera 2
numFrames2 = size(vidFrames2_1,4); % number of video frames for camera 2
pointTracker = vision.PointTracker; % create PointTracker object
points2 = zeros(2, numFrames2); % initialize points2 matrix
I = vidFrames2_1(:,:,:,1); % first video frame for camera 2
%imshow(I); % use data tips on image to find initial point
initial_point = [271 278]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames2
    if ii == 20
        setPoints(pointTracker, [273 110])
    end
    if ii == 25
        setPoints(pointTracker, [277 140])
    end
    if ii == 66
        setPoints(pointTracker, [281 142])
    end
    if ii == 186
        setPoints(pointTracker, [313 158])
    end
    I = vidFrames2_1(:,:,:,ii);
    points2(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 1:numFrames2
    I = vidFrames2_1(:,:,:,ii);
    imshow(I); 
    hold on
    plot(points2(1,ii),points2(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points2(1,:) = points2(1,:) - mean(points2(1,:));
points2(2,:) = points2(2,:) - mean(points2(2,:));


% Trial 1 Camera 3 
numFrames3 = size(vidFrames3_1,4); % number of video frames for camera 3
pointTracker = vision.PointTracker; % create PointTracker object
points3 = zeros(2, numFrames3); % initialize points3 matrix
I = vidFrames3_1(:,:,:,1); % first video frame for camera 3
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [317 272]; % initial point of flashlight, got from plot
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points at each time step
for ii = 1:numFrames3
    if ii == 97
        setPoints(pointTracker, [320 258])
    end
    if ii == 139
        setPoints(pointTracker, [341 262])
    end
    I = vidFrames3_1(:,:,:,ii);
    points3(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 1:numFrames3
    I = vidFrames3_1(:,:,:,ii);
    imshow(I); 
    hold on
    plot(points3(1,ii),points3(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points3(1,:) = points3(1,:) - mean(points3(1,:));
points3(2,:) = points3(2,:) - mean(points3(2,:));

% save all points from trial in single matrix
trial1 = zeros(6, 226);
trial1(1:2, :) = points1(:,1:226);
trial1(3:4, :) = points2(:,50:275);
trial1(5:6, :) = points3(:,1:226);

% plots vertical and horizontal displacement of paint can for all three 
% cameras on same figure
figure(1)
subplot(1,3,1)
ylim([-100 100]); xlim([0 226]);
xlabel('Video Frame'); ylabel('Displacement from mean (pixels)')
title('Vertical Displacement Trial 1'); 
hold on
plot(trial1(2,:) , 'b')
plot(trial1(4,:), 'r')
plot(trial1(5,:), 'g')
%legend('Camera 1', 'Camera 2', 'Camera 3');

subplot(1,3,2)
ylim([-100 100]); xlim([0 226]);
xlabel('Video Frame'); ylabel('Displacement from mean (pixels)')
title('Horizontal Displacement Trial 1');
hold on
plot(trial1(1,:) , 'b')
plot(trial1(3,:), 'r')
plot(trial1(6,:), 'g')
legend('Camera 1', 'Camera 2', 'Camera 3');


% Trial 1 Analysis

% singular value decomposition for trial 1
[U1,S1,V1] = svd(trial1, 'econ');


% calculates energy of each rank appromiation
S1_vec = diag(S1).';
S1_vec = S1_vec.^2;
energy1 = S1_vec/sum(S1_vec(1,:));
energy1_sums = cumsum(S1_vec)/sum(S1_vec(1,:));

% log scale of energy covered by each rank approximation
subplot(1,3,3)
plot(1:6,energy1,'ro')
set(gca, 'YScale', 'log')
xlabel('Mode Number'); ylabel('Energy of Mode (log scale)')
title('Mode Energies Trial 1');

% principal components
figure(2)
hold on
X_comp1 = U1(:,1)*S1(1,1)*V1(:,1).';
plot3( X_comp1(1,:),X_comp1(2,:),X_comp1(3,:), 'r.'); 
X_comp2 = U1(:,2)*S1(2,2)*V1(:,2)';
plot3( X_comp2(1,:),X_comp2(2,:),X_comp2(3,:), 'g.');
X_comp3 = U1(:,3)*S1(3,3)*V1(:,3)';
plot3( X_comp3(1,:),X_comp3(2,:),X_comp3(3,:), 'g.');
X_rank2 = U1(:,1:2)*S1(1:2,1:2)*V1(:,1:2)';
plot3( X_rank2(1,:),X_rank2(2,:),X_rank2(3,:), 'b.');
xlabel('Horizontal Displacement'); ylabel('Vertical Displacement')
title('PCA Analysis')
legend('1st Principal Component', '2nd Principal Component', ' Rank 2 Approximation');

%% Trial 2
close all; % closes all figures

% Trial 2 Camera 1
numFrames1 = size(vidFrames1_2,4);  % number of video frames for camera 1
pointTracker = vision.PointTracker; % create PointTracker object
points1 = zeros(2, numFrames1); % initialize points1 matrix
I = vidFrames1_2(:,:,:,1); % first video frame for camera 1
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [325 310]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames1
    I = vidFrames1_2(:,:,:,ii);
    points1(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 1:numFrames1
    I = vidFrames1_2(:,:,:,ii);
    imshow(I);
    hold on
    plot(points1(1,ii),points1(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points1(1,:) = points1(1,:) - mean(points1(1,:));
points1(2,:) = points1(2,:) - mean(points1(2,:));


% Trial 2 Camera 2
numFrames2 = size(vidFrames2_2,4);  % number of video frames for camera 2
pointTracker = vision.PointTracker; % create PointTracker object
points2 = zeros(2, numFrames2); % initialize points2 matrix
I = vidFrames2_2(:,:,:,1); % first video frame for camera 2
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [315 362]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames2
    if ii == 4
        setPoints(pointTracker, [301 334])
    end
    if ii == 59
        setPoints(pointTracker, [257 82])
    end
    if ii == 63
        setPoints(pointTracker, [231 98])
    end
    if ii == 249
        setPoints(pointTracker, [315 186])
    end
    if ii == 291
        setPoints(pointTracker, [331 136])
    end
    if ii == 311
        setPoints(pointTracker, [309 208])
    end
    if ii == 350
        setPoints(pointTracker, [391 278])
    end
    I = vidFrames2_2(:,:,:,ii);
    points2(:,ii) = step(pointTracker, I);
end


%{
% shows where points are expected to be
for ii = 1:numFrames2
    I = vidFrames2_2(:,:,:,ii);
    imshow(I); 
    hold on
    plot(points2(1,ii),points2(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points2(1,:) = points2(1,:) - mean(points2(1,:));
points2(2,:) = points2(2,:) - mean(points2(2,:));


% Trial 2 Camera 3 
numFrames3 = size(vidFrames3_2,4);  % number of video frames for camera 3
pointTracker = vision.PointTracker; % create PointTracker object
points3 = zeros(2, numFrames3); % initialize points3 matrix
I = vidFrames3_2(:,:,:,1); % first video frame for camera 3
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [345 246]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames3
    if ii == 222
        setPoints(pointTracker, [367 270])
    end
    if ii == 247
        setPoints(pointTracker, [335 260])
    end
    I = vidFrames3_2(:,:,:,ii);
    points3(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 1:numFrames3
    I = vidFrames3_2(:,:,:,ii);
    imshow(I); 
    hold on
    plot(points3(1,ii),points3(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points3(1,:) = points3(1,:) - mean(points3(1,:));
points3(2,:) = points3(2,:) - mean(points3(2,:));

% save all points from trial in single matrix
trial2 = zeros(6, 311);
trial2(1:2, :) = points1(:,4:314);
trial2(3:4, :) = points2(:,30:340);
trial2(5:6, :) = points3(:,7:317);

% plots vertical and horizontal displacement of paint can for all three 
% cameras on same figure
figure(1)
subplot(1,3,1)
ylim([-150 150]); xlim([0 311]);
xlabel('Video Frame'); ylabel('Displacement from mean (pixels)')
title('Vertical Displacement Trial 2'); 
hold on
plot(trial2(2,:) , 'b')
plot(trial2(4,:), 'r')
plot(trial2(5,:), 'g')
%legend('Camera 1', 'Camera 2', 'Camera 3');

subplot(1,3,2)
ylim([-150 150]); xlim([0 311]);
xlabel('Video Frame'); ylabel('Displacement from mean (pixels)')
title('Horizontal Displacement Trial 2');
hold on
plot(trial2(1,:) , 'b')
plot(trial2(3,:), 'r')
plot(trial2(6,:), 'g')
legend('Camera 1', 'Camera 2', 'Camera 3');


% Trial 2 Analysis

% singular value decomposition for trial 2
[U2,S2,V2] = svd(trial2, 'econ');


% calculates energy of each rank appromiation
S2_vec = diag(S2).';
S2_vec = S2_vec.^2;
energy2 = S2_vec/sum(S2_vec(1,:));
energy2_sums = cumsum(S2_vec)/sum(S2_vec(1,:));

% log scale of energy covered by each rank approximation
subplot(1,3,3)
plot(1:6,energy2,'ro')
set(gca, 'YScale', 'log')
xlabel('Mode Number'); ylabel('Energy of Mode (log scale)')
title('Mode Energies Trial 2');

% Modes plotted
figure(3)
plot(1:311,V2(:,1),'b',1:311,V2(:,2),'--r',1:311,V2(:,3),':k','Linewidth',2)

% principal components
figure(2)
hold on
X_comp1 = U2(:,1)*S2(1,1)*V2(:,1).';
plot3( X_comp1(1,:),X_comp1(2,:),X_comp1(3,:), 'r.'); 
X_comp2 = U2(:,2)*S2(2,2)*V2(:,2)';
plot3( X_comp2(1,:),X_comp2(2,:),X_comp2(3,:), 'g.');
X_rank2 = U2(:,1:2)*S2(1:2,1:2)*V2(:,1:2)';
plot3( X_rank2(1,:),X_rank2(2,:),X_rank2(3,:), 'b.');
xlabel('Horizontal Displacement'); ylabel('Vertical Displacement')
title('PCA Analysis')
legend('1st Principal Component', '2nd Principal Component', ' Rank 2 Approximation');

%% Trial 3 
close all; % closes open figures

% Trial 3 Camera 1
numFrames1 = size(vidFrames1_3,4);  % number of video frames for camera 1
pointTracker = vision.PointTracker; % create PointTracker object
point1 = zeros(2, numFrames1); % initialize points1 matrix
I = vidFrames1_3(:,:,:,1); % first video frame for camera 1
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [317 288]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames1
    I = vidFrames1_3(:,:,:,ii);
    points1(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 1:numFrames1
    I = vidFrames1_3(:,:,:,ii);
    imshow(I); 
    hold on
    plot(points1(1,ii),points1(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points1(1,:) = points1(1,:) - mean(points1(1,:));
points1(2,:) = points1(2,:) - mean(points1(2,:));


% Trial 3 Camera 2
numFrames2 = size(vidFrames2_3,4);  % number of video frames for camera 2
pointTracker = vision.PointTracker; % create PointTracker object
points2 = zeros(2, numFrames2); % initialize points2 matrix
I = vidFrames2_3(:,:,:,1); % first video frame for camera 2
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [249 294]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames2
    if ii == 10
        setPoints(pointTracker, [299 298])
    end
    if ii == 96
        setPoints(pointTracker, [307 250])
    end
    if ii == 133
        setPoints(pointTracker, [307 274])
    end
    if ii == 260
        setPoints(pointTracker, [323 232])
    end
    I = vidFrames2_3(:,:,:,ii);
    points2(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 1:numFrames2
    I = vidFrames2_3(:,:,:,ii);
    imshow(I); 
    hold on
    plot(points2(1,ii),points2(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points2(1,:) = points2(1,:) - mean(points2(1,:));
points2(2,:) = points2(2,:) - mean(points2(2,:));


% Trial 3 Camera 3
numFrames3 = size(vidFrames3_3,4);  % number of video frames for camera 3
pointTracker = vision.PointTracker; % create PointTracker object
points3 = zeros(2, numFrames3); % initialize points3 matrix
I = vidFrames3_3(:,:,:,1); % first video frame for camera 3
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [351 230]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames3
    I = vidFrames3_3(:,:,:,ii);
    points3(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 1:numFrames3
    I = vidFrames3_3(:,:,:,ii);
    imshow(I); 
    hold on
    plot(points3(1,ii),points3(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points3(1,:) = points3(1,:) - mean(points3(1,:));
points3(2,:) = points3(2,:) - mean(points3(2,:));

% save all points from trial in single matrix
trial3 = zeros(6, 200);
trial3(1:2, :) = points1(:,8:207);
trial3(3:4, :) = points2(:,33:232);
trial3(5:6, :) = points3(:,38:237);

% plots vertical and horizontal displacement of paint can for all three 
% cameras on same figure
figure(1)
subplot(1,3,1)
ylim([-60 60]); xlim([0 200]);
xlabel('Video Frame'); ylabel('Displacement from mean (pixels)')
title('Vertical Displacement Trial 3'); 
hold on
plot(trial3(2,:) , 'b')
plot(trial3(4,:), 'r')
plot(trial3(5,:), 'g')
%legend('Camera 1', 'Camera 2', 'Camera 3');

subplot(1,3,2)
ylim([-60 60]); xlim([0 200]);
xlabel('Video Frame'); ylabel('Displacement from mean (pixels)')
title('Horizontal Displacement Trial 3');
hold on
plot(trial3(1,:) , 'b')
plot(trial3(3,:), 'r')
plot(trial3(6,:), 'g')
legend('Camera 1', 'Camera 2', 'Camera 3');


% Trial 3 Analysis

% singular value decomposition for trial 3
[U3,S3,V3] = svd(trial3, 'econ');

% calculates energy of each rank appromiation
S3_vec = diag(S3).';
S3_vec = S3_vec.^2;
energy3 = S3_vec/sum(S3_vec(1,:));
energy3_sums = cumsum(S3_vec)/sum(S3_vec(1,:));

% log scale of energy covered by each rank approximation
subplot(1,3,3)
plot(1:6,energy3,'ro')
set(gca, 'YScale', 'log')
xlabel('Mode Number'); ylabel('Energy of Mode (log scale)')
title('Mode Energies Trial 3');

% principal components
figure(2)
hold on
X_comp1 = U3(:,1)*S3(1,1)*V3(:,1).';
plot3( X_comp1(1,:),X_comp1(2,:),X_comp1(3,:), 'r.'); 
X_comp2 = U3(:,2)*S3(2,2)*V3(:,2)';
plot3( X_comp2(1,:),X_comp2(2,:),X_comp2(3,:), 'g.');
X_rank2 = U3(:,1:2)*S3(1:2,1:2)*V3(:,1:2)';
plot3( X_rank2(1,:),X_rank2(2,:),X_rank2(3,:), 'b.');
xlabel('Horizontal Displacement'); ylabel('Vertical Displacement')
title('PCA Analysis')
legend('1st Principal Component', '2nd Principal Component', ' Rank 2 Approximation');

%% Trial 4
close all; % closes open figures

% Trial 4 Camera 1
numFrames1 = size(vidFrames1_4,4);  % number of video frames for camera 1
pointTracker = vision.PointTracker; % create PointTracker object
points1 = zeros(2, numFrames1); % initialize points1 matrix
I = vidFrames1_4(:,:,:,1); % first video frame for camera 1
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [400 264]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames1
    if ii == 219
        setPoints(pointTracker, [374 266])
    end
    if ii == 282
        setPoints(pointTracker, [387 294])
    end
    if ii == 308
        setPoints(pointTracker, [364 324])
    end
    I = vidFrames1_4(:,:,:,ii);
    points1(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 1:numFrames1
    I = vidFrames1_4(:,:,:,ii);
    imshow(I); 
    hold on
    plot(points1(1,ii),points1(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points1(1,:) = points1(1,:) - mean(points1(1,:));
points1(2,:) = points1(2,:) - mean(points1(2,:));


% Trial 4 Camera 2
numFrames2 = size(vidFrames2_4,4);  % number of video frames for camera 2
pointTracker = vision.PointTracker; % create PointTracker object
points2 = zeros(2, numFrames2); % initialize points2 matrix
I = vidFrames2_4(:,:,:,1); % first video frame for camera 2
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [245 246]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames2
    if ii == 6
        setPoints(pointTracker, [277 214])
    end
    if ii == 9
        setPoints(pointTracker, [301 196])
    end
    if ii == 10
        setPoints(pointTracker, [305 182])
    end
    if ii == 39
        setPoints(pointTracker, [337 266])
    end
    if ii == 64
        setPoints(pointTracker, [267 144])
    end
    if ii == 214
        setPoints(pointTracker, [305 144])
    end
    if ii == 268
        setPoints(pointTracker, [329 158])
    end
    if ii == 288
        setPoints(pointTracker, [307 200])
    end
    if ii == 293
        setPoints(pointTracker, [313 148])
    end
    if ii == 302
        setPoints(pointTracker, [291 114])
    end
    if ii == 331
        setPoints(pointTracker, [285 178])
    end
    I = vidFrames2_4(:,:,:,ii);
    points2(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 290:numFrames2
    I = vidFrames2_4(:,:,:,ii);
    imshow(I);
    hold on
    plot(points2(1,ii),points2(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points2(1,:) = points2(1,:) - mean(points2(1,:));
points2(2,:) = points2(2,:) - mean(points2(2,:));


% Trial 4 Camera 3
numFrames3 = size(vidFrames3_4,4);  % number of video frames for camera 3
pointTracker = vision.PointTracker; % create PointTracker object
points3 = zeros(2, numFrames3); % initialize points3 matrix
I = vidFrames3_4(:,:,:,1); % first video frame for camera 3
%imshow(I); % use data tips on image (under tools tab) to find initial point
initial_point = [361 236]; % initial point of flashlight
initialize(pointTracker,initial_point,I) % initialize PointTracker

% find and save points for each time step
for ii = 1:numFrames3
    if ii == 16
        setPoints(pointTracker, [323 206])
    end
    if ii == 57
        setPoints(pointTracker, [335 224])
    end
    if ii == 194
        setPoints(pointTracker, [410 204])
    end
    if ii == 216
        setPoints(pointTracker, [347 262])
    end
    if ii == 231
        setPoints(pointTracker, [421 220])
    end
    if ii == 244
        setPoints(pointTracker, [355 204])
    end
    if ii == 263
        setPoints(pointTracker, [371 222])
    end
    if ii == 281
        setPoints(pointTracker, [381 240])
    end
    if ii == 301
        setPoints(pointTracker, [374 250])
    end
    if ii == 322
        setPoints(pointTracker, [379 230])
    end
    I = vidFrames3_4(:,:,:,ii);
    points3(:,ii) = step(pointTracker, I);
end

%{
% shows where points are expected to be
for ii = 200:numFrames3
    I = vidFrames3_4(:,:,:,ii);
    imshow(I);
    hold on
    plot(points3(1,ii),points3(2,ii),'r+', 'MarkerSize', 20);
    pause(0.1)
end
%}

% centers points around mean value
points3(1,:) = points3(1,:) - mean(points3(1,:));
points3(2,:) = points3(2,:) - mean(points3(2,:));

% save all points from trial in single matrix
trial4 = zeros(6, 355);
trial4(1:2, :) = points1(:,1:355);
trial4(3:4, :) = points2(:,7:361);
trial4(5:6, :) = points3(:,40:394);

% plots vertical and horizontal displacement of paint can for all three 
% cameras on same figure
figure(1)
subplot(1,3,1)
ylim([-100 100]); xlim([0 355]);
xlabel('Video Frame'); ylabel('Displacement from mean (pixels)')
title('Vertical Displacement Trial 4'); 
hold on
plot(trial4(2,:) , 'b')
plot(trial4(4,:), 'r')
plot(trial4(5,:), 'g')
%legend('Camera 1', 'Camera 2', 'Camera 3');

subplot(1,3,2)
ylim([-100 100]); xlim([0 355]);
xlabel('Video Frame'); ylabel('Displacement from mean (pixels)')
title('Horizontal Displacement Trial 4');
hold on
plot(trial4(1,:) , 'b')
plot(trial4(3,:), 'r')
plot(trial4(6,:), 'g')
legend('Camera 1', 'Camera 2', 'Camera 3');


% Trial 4 Analysis

% singular value decomposition for trial 4
[U4,S4,V4] = svd(trial4, 'econ');


% calculates energy of each rank appromiation
S4_vec = diag(S4).';
S4_vec = S4_vec.^2;
energy4 = S4_vec/sum(S4_vec(1,:));
energy4_sums = cumsum(S4_vec)/sum(S4_vec(1,:));

% log scale of energy covered by each rank approximation
subplot(1,3,3)
plot(1:6,energy4,'ro')
set(gca, 'YScale', 'log')
xlabel('Mode Number'); ylabel('Energy of Mode (log scale)')
title('Mode Energies Trial 4');

% principal components
figure(2)
hold on
X_comp1 = U4(:,1)*S4(1,1)*V4(:,1).';
plot3( X_comp1(1,:),X_comp1(2,:),X_comp1(3,:), 'r.'); 
X_comp2 = U4(:,2)*S4(2,2)*V4(:,2)';
plot3( X_comp2(1,:),X_comp2(2,:),X_comp2(3,:), 'g.');
X_comp3 = U4(:,3)*S4(3,3)*V4(:,3)';
plot3( X_comp3(1,:),X_comp3(2,:),X_comp3(3,:), 'g.');
X_rank2 = U4(:,1:2)*S4(1:2,1:2)*V4(:,1:2)';
plot3( X_rank2(1,:),X_rank2(2,:),X_rank2(3,:), 'b.');
xlabel('Horizontal Displacement'); ylabel('Vertical Displacement')
title('PCA Analysis')
legend('1st Principal Component', '2nd Principal Component', ' Rank 2 Approximation');
