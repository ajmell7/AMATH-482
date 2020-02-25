% Create System objects for reading and displaying video, and for
% drawing a bounding box of the object.
videoFileReader = vision.VideoFileReader('visionface.avi');
videoPlayer = vision.VideoPlayer('Position', [100, 100, 680, 520]);
 
% Read the first video frame which contains the object and then show
% the object region
objectFrame = step(videoFileReader);  % read the first video frame
  
objectRegion = [264, 122, 93, 93];  % define the object region
% You can also use the following commands to select the object region
% using a mouse. The object must occupy majority of the region.
% figure; imshow(objectFrame); objectRegion=round(getPosition(imrect))
 
objectImage = insertShape(objectFrame, 'Rectangle', objectRegion, ...
                              'Color', 'red');
figure; imshow(objectImage); title('Red box shows object region');
  
% Detect interest points in the object region
points = detectMinEigenFeatures(rgb2gray(objectFrame), 'ROI', objectRegion);
    
% Display the detected points
pointImage = insertMarker(objectFrame, points.Location, '+', ...
                              'Color', 'white');
figure, imshow(pointImage), title('Detected interest points');
% Create a tracker object.
tracker = vision.PointTracker('MaxBidirectionalError', 1);
  
% Initialize the tracker
initialize(tracker, points.Location, objectFrame);
  
% Track and display the points in each video frame
while ~isDone(videoFileReader)
    frame = step(videoFileReader);             % Read next image frame
    [points, validity] = step(tracker, frame);  % Track the points
    out = insertMarker(frame, points(validity, :), '+'); % Display points
    step(videoPlayer, out);                    % Show results
end
  
release(videoPlayer);
release(videoFileReader);
   
   