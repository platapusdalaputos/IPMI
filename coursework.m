%% Load in functions
src_dir = './Coursework/';

% Make the functions available to use
addpath(strcat(src_dir,'functions/'));

%% Load in images

% Produce data stores for for all the images
imagesAtlas = imageDatastore('Coursework/images/atlas/*.png');
imagesTune = imageDatastore('Coursework/images/tune/*.png');
imagesTest = imageDatastore('Coursework/images/test/*.png');

% Read all images in the image data stores
imgsAtlas = readall(imagesAtlas);
imgsTune = readall(imagesTune);
imgsTest = readall(imagesTest);

%% Shifting the data

% CT image, brain stem and spinal cord

% Rotating the atlas (source) CT image and flipping stem and cord
imgArray = imrotate(double(cell2mat(imgsAtlas(1))),-90);
imgArray2 = imrotate(double(cell2mat(imgsAtlas(2))),-90);
imgArray3 = imrotate(double(cell2mat(imgsAtlas(3))),-90);

% Rotating the tune (target) CTimage and flipping stem and cord
imgTune = imrotate(double(cell2mat(imgsTune(1))),-90);
imgTune2 = imrotate(double(cell2mat(imgsTune(2))),-90);
imgTune3 = imrotate(double(cell2mat(imgsTune(3))),-90);

% Rotating the test (target) CTimage and flipping stem and cord
imgTest = imrotate(double(cell2mat(imgsTest(1))),-90);
imgTest2 = imrotate(double(cell2mat(imgsTest(2))),-90);
imgTest3 = imrotate(double(cell2mat(imgsTest(3))),-90);

% Displaying the first CT Atlas (source) image alongside the contours 
figure(1);
dispImage(imgArray);
hold on
contour(imgArray2','g');
contour(imgArray3','r');

% Displaying the first CT Tune (target) image alongside the contours 
figure(2);
dispImage(imgTune);
hold on
contour(imgTune2','g');
contour(imgTune3','r');

% Displaying the first CT Test (target) image alongside the contours 
figure(3);
dispImage(imgTest);
hold on
contour(imgTest2','g');
contour(imgTest3','r');


%% Performing the demons Registration


% for i = 2:4
    sigma_elastic = 1.4;
    sigma_fluid= 1.2;
    num_lev = 1;
    use_composition= false;
    
%     lmsd = performRegimg(12,imgsAtlas, imgsTune,sigma_elastic, sigma_fluid, num_lev, use_composition);

%     performRegimg(i,imgsAtlas, imgsTune,sigma_elastic(i), sigma_fluid(i), num_lev(i), use_composition);
% end 

[lmsd_map] = performRegimg(imgsAtlas, imgsTune, sigma_elastic, sigma_fluid, num_lev, use_composition);

% Pre Function code
% % Z counter for the ith loop
% 
% lmsd_map = [];
% storemask1 = zeros(3,5,340,270);
% storemask2 = zeros(3,5,340,270);
%     Z = 1;
%     for i = 1:3
%         
%         % Importing the tuning images  
%         imgTune1 = imrotate(double(cell2mat(imgsTune(Z))),-90);
%         imgTune2 = flipud(double(cell2mat(imgsTune(Z+1))));
%         imgTune3 = flipud(double(cell2mat(imgsTune(Z+2))));       
%         
%         % Displaying the tuning images
%         figure;
%         dispImage(imgTune1); hold on; imcontour(imgTune2,'g');imcontour(imgTune3,'r');
%         title('tune');
%         pause(1.0)
%         
%         % counters for the ith and jth loop respectively 
%         Z = Z+3;
%         X = 1;
% 
%         for j = 1:5
%            
%             % Importing the Atlas images
%             imgAtlas1 = imrotate(double(cell2mat(imgsAtlas(X))),-90);
%             imgAtlas2 = imrotate(double(cell2mat(imgsAtlas(X+1))),-90);
%             imgAtlas3 = imrotate(double(cell2mat(imgsAtlas(X+2))),-90); 
%            
%             % Computing the registration          
%             [warp_img_loop, def_field_loop]= demonsReg(imgAtlas1, imgTune1,sigma_elastic, sigma_fluid, num_lev, use_composition);
%             
%             % Re-sampling the segmented images with the calc def field
%             resamp_img = resampImageWithDefField(imgAtlas2, def_field_loop, 'linear' , NaN);
%             resamp_img2 = resampImageWithDefField(imgAtlas3, def_field_loop, 'linear' , NaN);
%                         
%             % ensuring the resampled brain-stem image is a binary image
%             mask1 = resamp_img;
%             mask1(resamp_img>0) = 1;
%             mask1(isnan(resamp_img)) = 0; 
%             storemask1(i,j,:,:)= mask1;
%            
%             % ensuring the resampled spinal cord image is a binary image
%             mask2 = resamp_img2;
%             mask2(resamp_img2>0) = 1;
%             mask2(isnan(resamp_img2)) = 0;
%             storemask2(i,j,:,:)= mask2;
%             
%             % displaying the registered and def field warped images  
%             dispImage(warp_img_loop); 
%             hold on; imcontour(mask1','g') ; imcontour(mask2','r');
%             ax = gca;
%             title('Atlas');
%             pause(1.0);
% 
%             % Exporting the trial and error images
%             % exportgraphics(ax,fullfile('./Coursework/ParamImages', sprintf('Param_%d_tune_%d_atlas_%d PV%d_%d_%d_%d.jpg',l,i,j,sigma_elastic(l),sigma_fluid(l),num_lev(l),use_composition)),'Resolution',300)
%             
%             % Calculating the LMSD 
%             lmsd_map(i,j,:,:) = calcLMSD(warp_img_loop,imgTune1, 20);
%             
%             
%             % X counter for the jth loop 
%             X = X+3;
%             
%         end 
%  
% 
%     end
% %    
%% Calculating MAS

% Tuning Images

imgTuned1 = imrotate(double(cell2mat(imgsTune(1))),-90);
imgTuned2 = imrotate(double(cell2mat(imgsTune(4))),-90);
imgTuned3 = imrotate(double(cell2mat(imgsTune(7))),-90);

% calculate the MAS for Tune1, Tune2 and Tune3
[m1tune1, m2tune1, ~] = MASfunc(lmsd_map(1,:,:,:), storemask1(1,:,:,:), storemask2(1,:,:,:),5);
[m1tune2, m2tune2, ~] = MASfunc(lmsd_map(2,:,:,:), storemask1(2,:,:,:), storemask2(2,:,:,:),5);
[m1tune3, m2tune3, ~] = MASfunc(lmsd_map(3,:,:,:), storemask1(3,:,:,:), storemask2(3,:,:,:),5);

% Figures for 
figure;
dispImage(imgTuned2);
hold on
imcontour
imcontour((m1tune1'), 'm');
imcontour((m2tune1'), 'c');


