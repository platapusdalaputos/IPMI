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

% Testing out the parameters

% for i = 2:4
%     sigma_elastic = [1.0, 1.1, 1.2, 1.3, 1.4, 1.5];
%     sigma_fluid= [1.0, 1.1, 1.2, 1.3, 1.4, 1.5];
%     num_lev = [1, 2, 3, 4, 5, 6, 7];
%     use_composition= false;
%     
%     lmsd = performRegimg(12,imgsAtlas, imgsTune,sigma_elastic, sigma_fluid, num_lev, use_composition);
% 
%     performRegimg(i,imgsAtlas, imgsTune,sigma_elastic(i), sigma_fluid(i), num_lev(i), use_composition);
% end 

% Optimal Parameters

sigma_elastic = 1.4;
sigma_fluid= 1.2;
num_lev = 5;
use_composition= false;

sourceNumber = 3;

% Calculating for the tuning
[lmsd_map, storemask1, storemask2] = performRegimg(imgsAtlas, imgsTune, sigma_elastic, sigma_fluid, num_lev, use_composition);
% Calculating for the testing

%% Calculating and displaying MAS for tuning images

% Tuning Images

imgTuned1 = imrotate(double(cell2mat(imgsTune(1))),-90);
imgTuned2 = imrotate(double(cell2mat(imgsTune(4))),-90);
imgTuned3 = imrotate(double(cell2mat(imgsTune(7))),-90);

% Tuning contours

imgTune2 = imrotate(double(cell2mat(imgsTune(2))),-90);
imgTune3 = imrotate(double(cell2mat(imgsTune(3))),-90);
imgTune5 = imrotate(double(cell2mat(imgsTune(5))),-90);
imgTune6 = imrotate(double(cell2mat(imgsTune(6))),-90);
imgTune8 = imrotate(double(cell2mat(imgsTune(8))),-90);
imgTune9 = imrotate(double(cell2mat(imgsTune(9))),-90);

% calculate the MAS for Tune1, Tune2 and Tune3
[m1tune1, m2tune1, ~] = MASfunc(lmsd_map(1,:,:,:), storemask1(1,:,:,:), storemask2(1,:,:,:),5);
[m1tune2, m2tune2, ~] = MASfunc(lmsd_map(2,:,:,:), storemask1(2,:,:,:), storemask2(2,:,:,:),5);
[m1tune3, m2tune3, ~] = MASfunc(lmsd_map(3,:,:,:), storemask1(3,:,:,:), storemask2(3,:,:,:),5);

% Figures for Tuning


figure(2);
dispImage(imgTuned1);
hold on
imcontour(imgTune2','g') ; imcontour(imgTune3','r');
imcontour(m1tune1','m') ; imcontour(m2tune1','c');
ax = gca;
exportgraphics(ax,fullfile('./final_imgs', 'MAStune1.jpg'),'Resolution',300)


figure(3);
dispImage(imgTuned2);
hold on
imcontour(imgTune5','g') ; imcontour(imgTune6','r');
imcontour(m1tune2','m') ; imcontour(m2tune2','c');
exportgraphics(ax,fullfile('./final_imgs', 'MAStune2.jpg'),'Resolution',300)

figure(4);
dispImage(imgTuned3);
hold on
imcontour(imgTune8','g') ; imcontour(imgTune9','r');
imcontour(m1tune3','m') ; imcontour(m2tune3','c');
exportgraphics(ax,fullfile('./final_imgs', 'MAStune3.jpg'),'Resolution',300)

%% Calculating and displaying MAS for testing images


sourceNumber = 5;

% Optimal Parameters
sigma_elastic = 1.4;
sigma_fluid= 1.2;
num_lev = 5;
use_composition= false;

% Calculating for the tuning
[lmsd_map, storemask1, storemask2] = performRegimg(imgsAtlas, imgsTest, sigma_elastic, sigma_fluid, num_lev, use_composition, sourceNumber);

% Calculating for the testing

% Testing Images
imgTest1 = imrotate(double(cell2mat(imgsTest(1))),-90);
imgTest4 = imrotate(double(cell2mat(imgsTest(4))),-90);
imgTest7 = imrotate(double(cell2mat(imgsTest(7))),-90);
imgTest10 = imrotate(double(cell2mat(imgsTest(10))),-90);
imgTest13 = imrotate(double(cell2mat(imgsTest(13))),-90);

% Testing contours
imgTest2 = imrotate(double(cell2mat(imgsTest(2))),-90);
imgTest3 = imrotate(double(cell2mat(imgsTest(3))),-90);
imgTest5 = imrotate(double(cell2mat(imgsTest(5))),-90);
imgTest6 = imrotate(double(cell2mat(imgsTest(6))),-90);
imgTest8 = imrotate(double(cell2mat(imgsTest(8))),-90);
imgTest9 = imrotate(double(cell2mat(imgsTest(9))),-90);
imgTest11 = imrotate(double(cell2mat(imgsTest(11))),-90);
imgTest12 = imrotate(double(cell2mat(imgsTest(12))),-90);
imgTest14 = imrotate(double(cell2mat(imgsTest(14))),-90);
imgTest15 = imrotate(double(cell2mat(imgsTest(15))),-90);

% calculate the MAS for testing images
[m1test1, m2test1, ~] = MASfunc(lmsd_map(1,:,:,:), storemask1(1,:,:,:), storemask2(1,:,:,:),5);
[m1test2, m2test2, ~] = MASfunc(lmsd_map(2,:,:,:), storemask1(2,:,:,:), storemask2(2,:,:,:),5);
[m1test3, m2test3, ~] = MASfunc(lmsd_map(3,:,:,:), storemask1(3,:,:,:), storemask2(3,:,:,:),5);
[m1test4, m2test4, ~] = MASfunc(lmsd_map(4,:,:,:), storemask1(4,:,:,:), storemask2(4,:,:,:),5);
[m1test5, m2test5, ~] = MASfunc(lmsd_map(5,:,:,:), storemask1(5,:,:,:), storemask2(5,:,:,:),5);


% Figures for Testing
figure(1);
dispImage(imgTest1);
hold on
imcontour(imgTest2','g') ; imcontour(imgTest3','r');
imcontour(m1test1','m') ; imcontour(m2test1','c');
ax = gca;
exportgraphics(ax,fullfile('./final_imgs', 'MAStune1.jpg'),'Resolution',300)

figure(2);
dispImage(imgTest4);
hold on
imcontour(imgTest5','g') ; imcontour(imgTest6','r');
imcontour(m1test2','m') ; imcontour(m2test2','c');
exportgraphics(ax,fullfile('./final_imgs', 'MAStune2.jpg'),'Resolution',300)

figure(3);
dispImage(imgTest7);
hold on
imcontour(imgTest8','g') ; imcontour(imgTest9','r');
imcontour(m1test3','m') ; imcontour(m2test3','c');
exportgraphics(ax,fullfile('./final_imgs', 'MAStune3.jpg'),'Resolution',300)   

figure(4);
dispImage(imgTest10);
hold on
imcontour(imgTest11','g') ; imcontour(imgTest12','r');
imcontour(m1test4','m') ; imcontour(m2test4','c');
exportgraphics(ax,fullfile('./final_imgs', 'MAStune4.jpg'),'Resolution',300)   

figure(5);
dispImage(imgTest13);
hold on
imcontour(imgTest14','g') ; imcontour(imgTest15','r');
imcontour(m1test5','m') ; imcontour(m2test5','c');
exportgraphics(ax,fullfile('./final_imgs', 'MAStune5.jpg'),'Resolution',300)   


