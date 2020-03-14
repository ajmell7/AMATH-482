% This function takes in values for the transformed data of all training
% song clips and the number of features. It returns the U matrix from the
% SVD of this data along with its two largest eigenvectors (w, w2), the 
% location of each song clip in two dimensional space (mid1, mid2, mid3), 
% and the projection of each song onto the two largest eigenvectors (v,
% v_2).
function [U,w,w2,mid1,mid2,mid3,v,v_2] = song_trainer(spec_songs,feature)

    % Separate out songs
    song1_0 = spec_songs(:,1:18);
    song2_0 = spec_songs(:,19:36);
    song3_0 = spec_songs(:,37:54);
    
    % length of Songs
    n1 = size(song1_0,2); n2 = size(song2_0,2); n3 = size(song3_0,2);
    
    [U,S,V] = svd([song1_0 song2_0 song3_0],'econ'); % SVD
    songs = S*V'; % projection onto principal components
    
    % Extracts data corresponding to specified feature number
    U = U(:,1:feature);
    song1 = songs(1:feature,1:n1);
    song2 = songs(1:feature,n1+1:2*n1);
    song3 = songs(1:feature,2*n1+1:3*n1);
 
    % Finds mean value for each song
    m = mean(songs(1:feature),2);
    m1 = mean(song1,2);
    m2 = mean(song2,2);
    m3 = mean(song3,2);
   
    % Calculates within class variance
    Sw = 0;
    for k=1:n1
        Sw = Sw + (song1(:,k)-m1)*(song1(:,k)-m1)';
    end
    for k=1:n2
        Sw = Sw + (song2(:,k)-m2)*(song2(:,k)-m2)';
    end
    for k=1:n3
        Sw = Sw + (song3(:,k)-m3)*(song3(:,k)-m3)';
    end
    
    % Calculates between class variance
    Sb = (m1-m)*(m1-m)' + (m2-m)*(m2-m)' + (m3-m)*(m3-m)'; 
    
    % Linear discriminant analysis
    [V2,D] = eig(Sb,Sw); 
    
    % Finds two largest eigenvectors and projects data onto each of them
    [~,ind] = max(abs(diag(D)));
    w = V2(:,ind); w = w/norm(w,2);
    D(ind,ind) = 0; % remove largest eigenvalue
    [~,ind] = max(abs(diag(D)));
    w2 = V2(:,ind); w2 = w2/norm(w2,2); 
    
    % Projects songs onto two largest eigenvectors
    v1 = w'*song1; 
    v2 = w'*song2;
    v3 = w'*song3;
    v = [v1; v2; v3];
    v1_2 = w2'*song1;
    v2_2 = w2'*song2;
    v3_2 = w2'*song3;
    v_2 = [v1_2; v2_2; v3_2];
    
    % Finds approximate two dimensional position of each song
    mid1 = [mean(v1), mean(v1_2)];
    mid2 = [mean(v2),mean(v2_2)];
    mid3 = [mean(v3),mean(v3_2)];
end