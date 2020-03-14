%% Test 1 Traning - Band Classification
clc; clear all; close all

test = 1; % specify test number for plotting at bottom

% Contains all training songs for test 1
song_titles = {
    'vienna1.wav', 'vienna2.wav', 'vienna3.wav', ...
    'piano_man1.wav', 'piano_man2.wav', 'piano_man3.wav', ...
    'uptown1.wav', 'uptown2.wav', 'uptown3.wav', ...
    'my_life1.wav', 'my_life2.wav', 'my_life3.wav', ...
    'still_rock1.wav', 'still_rock2.wav', 'still_rock3.wav', ...
    'good_die1.wav', 'good_die2.wav', 'good_die3.wav', ...
    'better1.wav', 'better2.wav', 'better3.wav', ... 
    'mind_sale1.wav', 'mind_sale2.wav', 'mind_sale3.wav', ... 
    'upside1.wav', 'upside2.wav', 'upside3.wav', ... 
    'banana1.wav', 'banana2.wav', 'banana3.wav', ...
    'sunsets1.wav', 'sunsets2.wav', 'sunsets3.wav', ...
    'remember1.wav', 'remember2.wav', 'remember3.wav', ...
    'we_were1.wav', 'we_were2.wav', 'we_were3.wav', ... 
    'cop_car1.wav', 'cop_car2.wav', 'cop_car3.wav', ... 
    'fighter1.wav', 'fighter2.wav', 'fighter3.wav', ...
    'blue1.wav', 'blue2.wav', 'blue3.wav', ...
    'parallel1.wav', 'parallel2.wav', 'parallel3.wav', ...
    'female1.wav', 'female2.wav', 'female3.wav'
    };

feature = 10; % set feature number
num_songs = length(song_titles); % number of training songs
spec_songs = zeros(5622750, num_songs); % initialize spectrogram data

% Get all transformed data for each song clip and set each clip as a column
% in the spec_songs matrix
for ii = 1:num_songs
    [y,Fs] = audioread(song_titles{ii});
    Fs = Fs/2;
    y = y(1:2:length(y));
    [spec] = get_spec(y, Fs);
    spec_songs(:,ii) = reshape(spec,5622750,1);
end

% Take the SVD of all transformed song clips
[U,w,w2,mid1,mid2,mid3,v,v_2] = song_trainer(spec_songs, feature);


%% Test 1 Testing - Band Classification

% Contains all testing songs for test 1
test_songs = {
    'billy_woman.wav', 'billy_longest.wav', 'billy_innocent.wav', ...
    'billy_shot.wav', 'billy_dreams.wav', 'billy_lullabye.wav', ...
    'billy_right.wav', 'billy_york.wav', 'billy_alexa.wav', ...
    'billy_extremes.wav', ...
    'jack_constellations.wav', 'jack_flake.wav', 'jack_angel.wav', ...
    'jack_tape.wav', 'jack_belle.wav', 'jack_fade.wav', ...
    'jack_staple.wav', 'jack_believe.wav', 'jack_radiate.wav', ...
    'jack_ones.wav', ...
    'keith_john.wav', 'keith_texas.wav', 'keith_thunder.wav', ...
    'keith_habit.wav', 'keith_worry.wav', 'keith_shame.wav', ...
    'keith_camaro.wav', 'keith_everything.wav', 'keith_georgia.wav', ...
    'keith_winning.wav'
    };
 
test_num = length(test_songs); % total tested songs
num_correct = zeros(1,test_num); % stores if song was correctly classified

% Tests each song clip to determine which category it should be placed in
% based on training data. Saves whether or not the correct value is given 
% for each clip.
for ii = 1:test_num
    [y, Fs] = audioread(test_songs{ii});
    Fs = Fs/2;
    y = y(1:2:length(y));
    [spec] = get_spec(y,Fs);
    test_spec(:,1) = reshape(spec,5622750,1);
    TestMat = U'*test_spec;
    x_pos = w'*TestMat;
    y_pos = w2'*TestMat;
    dist1 = sqrt((mid1(1)-x_pos)^2 + (mid1(2)-y_pos)^2);
    dist2 = sqrt((mid2(1)-x_pos)^2 + (mid2(2)-y_pos)^2);
    dist3 = sqrt((mid3(1)-x_pos)^2 + (mid3(2)-y_pos)^2);
    dist = [dist1 dist2 dist3];
    if find(dist == min(dist)) == 1 && ii <= 10
        num_correct(ii) = 1;
    elseif find(dist == min(dist)) == 2 && ii > 10 && ii <= 20
        num_correct(ii) = 1;
    elseif find(dist == min(dist)) == 3 && ii > 20 && ii <= 30
        num_correct(ii) = 1;
    end
end

% Gives percentage of correctly classified songs
percent_correct = sum(num_correct)/length(num_correct);

%% Test 2 Training - Same Genre
clc; clear all; close all

test = 2; % specify test number for plotting at bottom

% Contains all training songs for test 2
song_titles = {
    'vienna1.wav', 'vienna2.wav', 'vienna3.wav', ...
    'piano_man1.wav', 'piano_man2.wav', 'piano_man3.wav', ...
    'uptown1.wav', 'uptown2.wav', 'uptown3.wav', ...
    'my_life1.wav', 'my_life2.wav', 'my_life3.wav', ...
    'still_rock1.wav', 'still_rock2.wav', 'still_rock3.wav', ...
    'good_die1.wav', 'good_die2.wav', 'good_die3.wav', ...
    'tiny_dancer1.wav', 'tiny_dancer2.wav', 'tiny_dancer3.wav', ...
    'rocket1.wav', 'rocket2.wav', 'rocket3.wav', ...
    'bennie1.wav', 'bennie2.wav', 'bennie3.wav', ...
    'your_song1.wav', 'your_song2.wav', 'your_song3.wav', ...
    'standing1.wav', 'standing2.wav', 'standing3.wav', ...
    'daniel1.wav', 'daniel2.wav', 'daniel3.wav', ...
    'jack_diane1.wav', 'jack_diane2.wav', 'jack_diane3.wav', ...
    'small_town1.wav', 'small_town2.wav', 'small_town3.wav', ...
    'aint_done1.wav', 'aint_done2.wav', 'aint_done3.wav', ...
    'hurts_good1.wav', 'hurts_good2.wav', 'hurts_good3.wav', ...
    'cherry1.wav', 'cherry2.wav', 'cherry3.wav', ...
    'life_now1.wav', 'life_now2.wav', 'life_now3.wav'
    };

feature = 10; % set feature number
num_songs = length(song_titles); % number of training songs
spec_songs = zeros(5622750, num_songs); % initialize spectrogram data

% Get all transformed data for each song clip and set each clip as a column
% in the spec_songs matrix
for ii = 1:num_songs
    [y,Fs] = audioread(song_titles{ii});
    Fs = Fs/2;
    y = y(1:2:length(y));
    [spec] = get_spec(y, Fs);
    spec_songs(:,ii) = reshape(spec,5622750,1);
end

% Take the SVD of all transformed song clips
[U,w,w2,mid1,mid2,mid3,v,v_2] = song_trainer(spec_songs, feature);

%% Test 2 Testing - Same Genre

% Contains all testing songs for test 2
test_songs = {
    'billy_woman.wav', 'billy_longest.wav', 'billy_innocent.wav', ...
    'billy_shot.wav', 'billy_dreams.wav', 'billy_lullabye.wav', ...
    'billy_right.wav', 'billy_york.wav', 'billy_alexa.wav', ...
    'billy_extremes.wav', ...
    'elton_candle.wav', 'elton_blues.wav', 'elton_crocodile.wav', ...
    'elton_sacrifice.wav', 'elton_sorry.wav', 'elton_lucy.wav', ...
    'elton_breaking.wav', 'elton_honky.wav', 'elton_train.wav', ...
    'elton_wcn.wav', ...
    'john_crumbling.wav', 'john_not_running.wav', 'john_paper_fire.wav', ...
    'john_wild_night.wav', 'john_rumbleseat.wav', 'john_dance.wav', ...
    'john_minutes.wav', 'john_china.wav', 'john_brass.wav', ...
    'john_troubled.wav'
    };
    
test_num = length(test_songs); % total tested songs
num_correct = zeros(1,test_num); % stores if song was correctly classified

% Tests each song clip to determine which category it should be placed in
% based on training data. Saves whether or not the correct value is given 
% for each clip.
for ii = 1:test_num
    [y, Fs] = audioread(test_songs{ii});
    Fs = Fs/2;
    y = y(1:2:length(y));
    [spec] = get_spec(y,Fs);
    test_spec(:,1) = reshape(spec,5622750,1);
    TestMat = U'*test_spec;
    x_pos = w'*TestMat;
    y_pos = w2'*TestMat;
    dist1 = sqrt((mid1(1)-x_pos)^2 + (mid1(2)-y_pos)^2);
    dist2 = sqrt((mid2(1)-x_pos)^2 + (mid2(2)-y_pos)^2);
    dist3 = sqrt((mid3(1)-x_pos)^2 + (mid3(2)-y_pos)^2);
    dist = [dist1 dist2 dist3];
    if find(dist == min(dist)) == 1 && ii <= 10
        num_correct(ii) = 1;
    elseif find(dist == min(dist)) == 2 && ii > 10 && ii <= 20
        num_correct(ii) = 1;
    elseif find(dist == min(dist)) == 3 && ii > 20 && ii <= 30
        num_correct(ii) = 1;
    end
end

% Gives percentage of correctly classified songs
percent_correct = sum(num_correct)/length(num_correct);

%% Test 3 Training - Genre Classification
clc; clear all; close all

test = 3; % specify test number for plotting at bottom

% Contains all training songs for test 3
song_titles = {
    'vienna2.wav', 'piano_man2.wav', 'uptown2.wav', ...
    'my_life2.wav', 'still_rock2.wav', 'good_die2.wav', ...
    'tiny_dancer2.wav', 'rocket2.wav', 'bennie2.wav'...
    'your_song2.wav', 'standing2.wav', 'daniel2.wav', ...
    'jack_diane2.wav', 'small_town2.wav', 'aint_done2.wav', ...
    'hurts_good2.wav', 'cherry2.wav', 'life_now2.wav', ...
    'better2.wav', 'mind_sale2.wav', 'upside2.wav', ... 
    'banana2.wav', 'sunsets2.wav', 'remember2.wav', ...
    'new_light.wav', 'wonderland.wav', 'burning_room.wav', ...
    'gravity.wav', 'carry_me.wav', 'daughters.wav', ...
    'give_up.wav', 'have_it.wav', 'yours.wav', ...
    'unlonely.wav', 'million_miles.wav', 'lucky.wav', ...
    'we_were2.wav', 'cop_car2.wav', 'fighter2.wav', ...
    'blue2.wav', 'parallel2.wav', 'female2.wav', ...
    'god_country.wav', 'sangria.wav', 'guy_girl.wav', ...
    'hell_right.wav', 'name_dogs.wav', 'honey_bee.wav', ...
    'neon_church.wav', 'thought.wav', 'humble.wav', ...
    'like_dying.wav', 'something_like_that.wav', 'smile.wav'
    };

feature = 10; % set feature number
num_songs = length(song_titles); % number of training songs
spec_songs = zeros(5622750, num_songs); % initialize spectrogram data

% Get all transformed data for each song clip and set each clip as a column
% in the spec_songs matrix
for ii = 1:num_songs
    [y,Fs] = audioread(song_titles{ii});
    Fs = Fs/2;
    y = y(1:2:length(y));
    [spec] = get_spec(y, Fs);
    spec_songs(:,ii) = reshape(spec,5622750,1);
end

% Take the SVD of all transformed song clips
[U,w,w2,mid1,mid2,mid3,v,v_2] = song_trainer(spec_songs, feature);

%% Test 3 Testing - Genre Classification

% Contains all testing songs for test 3
test_songs = {
    'billy_woman.wav', 'billy_longest.wav', 'billy_innocent.wav', ...
    'elton_candle.wav', 'elton_blues.wav', 'elton_crocodile.wav', ...
    'john_crumbling.wav', 'john_not_running.wav', 'john_paper_fire.wav', ...
    'jack_constellations.wav', 'jack_flake.wav', 'jack_angel.wav', ...
    'john_who_says.wav', 'john_georgia.wav', 'john_wildfire.wav', ...
    'jason_night.wav', 'jason_dance.wav', 'jason_remedy.wav', ...
    'keith_john.wav', 'keith_texas.wav', 'keith_thunder.wav', ...
    'blake_cool.wav', 'blake_beach.wav', 'blake_fool.wav', ...
    'like_love.wav', 'tim_speak.wav', 'tim_southern.wav'
    };
    
test_num = length(test_songs); % total tested songs
num_correct = zeros(1,test_num); % stores if song was correctly classified

% Tests each song clip to determine which category it should be placed in
% based on training data. Saves whether or not the correct value is given 
% for each clip.
for ii = 1:test_num
    [y, Fs] = audioread(test_songs{ii});
    Fs = Fs/2;
    y = y(1:2:length(y));
    [spec] = get_spec(y,Fs);
    test_spec(:,1) = reshape(spec,5622750,1);
    TestMat = U'*test_spec;
    x_pos = w'*TestMat;
    y_pos = w2'*TestMat;
    %{
    dist1 = sqrt((abs(mid1(1)-x_pos)/1000) + abs(mid1(2)-y_pos));
    dist2 = sqrt((abs(mid2(1)-x_pos)/1000) + abs(mid2(2)-y_pos));
    dist3 = sqrt((abs(mid3(1)-x_pos)/1000) + abs(mid3(2)-y_pos));
    %}
    dist1 = sqrt((mid1(1)-x_pos)^2 + (mid1(2)-y_pos)^2);
    dist2 = sqrt((mid2(1)-x_pos)^2 + (mid2(2)-y_pos)^2);
    dist3 = sqrt((mid3(1)-x_pos)^2 + (mid3(2)-y_pos)^2);
    dist = [dist1 dist2 dist3];
    if find(dist == min(dist)) == 1 && ii <= 9
        num_correct(ii) = 1;
    elseif find(dist == min(dist)) == 2 && ii > 9 && ii <= 18
        num_correct(ii) = 1;
    elseif find(dist == min(dist)) == 3 && ii > 18 && ii <= 27
        num_correct(ii) = 1;
    end
end

% Gives percentage of correctly classified songs
percent_correct = sum(num_correct)/length(num_correct);

%% Plot Single Song

% Get data for test song
[y, Fs] = audioread('keith_john.wav'); % specify song to test
Fs = Fs/2;
y = y(1:2:length(y));
[spec] = get_spec(y,Fs);
test_spec(:,1) = reshape(spec,5622750,1);

% Calculate position of test song
TestMat = U'*test_spec;
x_pos = w'*TestMat;
y_pos = w2'*TestMat;

% Calculate distances between test song and center of each traning set
    dist1 = sqrt((mid1(1)-x_pos)^2 + (mid1(2)-y_pos)^2);
    dist2 = sqrt((mid2(1)-x_pos)^2 + (mid2(2)-y_pos)^2);
    dist3 = sqrt((mid3(1)-x_pos)^2 + (mid3(2)-y_pos)^2);
dist = [dist1 dist2 dist3];

% Blue: Test 1 - Billy Joel, Test 2 - Billy Joel, Test 3 - Rock
p1 = plot(v(1,:),v_2(1,:),'ob','Linewidth',2);
hold on

% Red: Test 1 - Jack Johnson, Test 2 - Elton John, Test 3 - Folk
p2 = plot(v(2,:),v_2(2,:),'or','Linewidth',2);

% Black: Test 1 - Keith Urban, Test 2 - John Mellencamp, Test 3 - Country
p3 = plot(v(3,:),v_2(3,:), 'ok','Linewidth',2);

p4 = plot(mid1(1),mid1(2),'*b'); % plots center of blue points
p5 = plot(mid2(1),mid2(2),'*r'); % plots center of red points
p6 = plot(mid3(1),mid3(2),'*k'); % plots center of black points
p7 = plot(x_pos,y_pos,'*','color',[0 0.7 0]); % plots test song in green

xlabel('First Eigenvector Projection', 'FontSize', 15);
ylabel('Second Eigenvector Projection', 'FontSize', 15);

% Creates legend and title depending on test number
if test == 1
    legend([p1 p2 p3 p7],'Billy Joel', 'Jack Johnson', 'Keith Urban', 'Test Song', 'FontSize', 10);
    title('Projection of Song Clips onto Eigenvectors Test 1');
elseif test == 2
    legend([p1 p2 p3 p7],'Billy Joel', 'Elton John', 'John Mellencamp', 'Test Song', 'FontSize', 10);
    title('Projection of Song Clips onto Eigenvectors Test 2');
else
    legend([p1 p2 p3 p7],'Rock','Folk','Country','Test Song', 'FontSize', 10);
    title('Projection of Song Clips onto Eigenvectors Test 3');
end
