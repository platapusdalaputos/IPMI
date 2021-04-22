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
imgArray = imrotate(double(cell2mat(imgsAtlas(13))),-90);
imgArray2 = flipud(double(cell2mat(imgsAtlas(14))));
imgArray3 = flipud(double(cell2mat(imgsAtlas(15))));

% Rotating the tune (target) CTimage and flipping stem and cord
imgTune = imrotate(double(cell2mat(imgsTune(7))),-90);
imgTune2 = flipud(double(cell2mat(imgsTune(8))));
imgTune3 = flipud(double(cell2mat(imgsTune(9))));


% Displaying the CT image alongside the contours 
figure(1);
dispImage(imgArray);
hold on
b = imcontour(imgArray2,'g');
bb = imcontour(imgArray3,'r');

% Displaying the CT image alongside the contours 
figure(2);
dispImage(imgTune);
hold on
b1 = imcontour(imgTune2,'g');
bb1 = imcontour(imgTune3,'r');

%% Performing Demons Registration

% Z counter for the ith loop
Z = 1;

for i = 1:3
        
        % Importing the tuning images  
        imgTune1 = imrotate(double(cell2mat(imgsTune(Z))),-90);
        imgTune2 = flipud(double(cell2mat(imgsTune(Z+1))));
        imgTune3 = flipud(double(cell2mat(imgsTune(Z+2))));       
        
        % Displaying the tuning images
        figure;
        dispImage(imgTune1); hold on; imcontour(imgTune2,'g');imcontour(imgTune3,'r');
        title('tune');
        pause(1.0)
        
        % counters for the ith and jth loop respectively 
        Z = Z+3;
        X = 1;

        for j = 1:5
           
            % Importing the Atlas images
            imgAtlas1 = imrotate(double(cell2mat(imgsAtlas(X))),-90);
            imgAtlas2 = flipud(double(cell2mat(imgsAtlas(X+1))));
            imgAtlas3 = flipud(double(cell2mat(imgsAtlas(X+2))));
            
            % Computing the registration          
            [warp_img_loop, def_field_loop]= demonsReg(imgAtlas1, imgTune1, sigma_elastic, sigma_fluid, num_lev, true);

            
            % Re-sampling the segmented images with the calc def field
            resamp_img = resampImageWithDefField(imgAtlas2, def_field_loop, 'linear' , NaN);
            resamp_img2 = resampImageWithDefField(imgAtlas3, def_field_loop, 'linear' , NaN);
            
            % ensuring the resampled brain-stem image is a binary image
            mask1 = resamp_img;
            mask1(resamp_img>0) = 1;
            mask1(isnan(resamp_img)) = 0;  
            
            % ensuring the resampled spinal cord image is a binary image
            mask2 = resamp_img2;
            mask2(resamp_img2>0) = 1;
            mask2(isnan(resamp_img2)) = 0;
            
            % re-orienting the masked images 
            jj = flipud(mask1);
            jj2 = flipud(mask2);
            
            % displaying the registered and def field warped images  
            dispImage(warp_img_loop); hold on; imcontour(flipud(jj),'g');imcontour(flipud(jj2),'r');
            title('Atlas');
            ylim([0 275]);
            pause(1.0)
            
            baseFileName = sprintf('Image #%d.png', k);
            fullFileName = fullfile(folder, baseFileName);
            imwrite(yourImage, fullFileName);
            
            
            
            %dispImage(imgAtlas1); hold on; imcontour(imgAtlas2,'g');imcontour(imgAtlas3,'r');
            %[warp_img_loop, def_field_loop]= demonsReg(imgAtlas1, imgTune1);            
            %resamp_img = resampImageWithDefField(imgAtlas2, def_field_loop, 'linear' , NaN);
            %resamp_img2 = resampImageWithDefField(imgAtlas3, def_field_loop, 'linear' , NaN);
            
            % X counter for the jth loop 
            X = X+3;
            
        end 
 

end 
%% 

sigma_elastic = 1;
sigma_fluid=1;
num_lev=3;
use_composition= false;


figure(1);

dispImage(imgTune1); hold on; imcontour(imgTune2,'g');imcontour(imgTune3,'r');

ax = gca;

title('tune');


formatSpec = 'PV %d_%d_%d_%d.jpg';
A1 = sigma_elastic; A2 = sigma_fluid; A3 = num_lev; A4 = use_composition;
fullFileName = fullfile('./Coursework/PVimages', sprintf(formatSpec,A1,A2,A3,A4));
exportgraphics(ax,fullFileName,'Resolution',300)








    

%%
% 
% %  bbb = double(cell2mat(imgsTune(7));
% 
% [warp_img, def_field]= demonsReg(imgArray,imgTune);
% 
% % resamp_img = resampImageWithDefField(imgArray, def_field, 'linear' , NaN);
% 
% % figure(1);
% % dispImage(imgArray);
%%
% figure(3);
% 
% dispImage(warp_img);

resamp_img = resampImageWithDefField(imgArray2, def_field, 'linear' , NaN);
resamp_img2 = resampImageWithDefField(imgArray3, def_field, 'linear' , NaN);
resamp_img3 = resampImageWithDefField(imgArray, def_field, 'linear' , NaN);

% jj = imrotate(flipud(resamp_img), -90);
% jj2 = imrotate(flipud(resamp_img2), -90);

% perform thresholding by logical indexing
mask1 = resamp_img;
mask1(resamp_img>0) = 1;
mask1(isnan(resamp_img)) = 0;


%%
jj = flipud(mask1);
jj2 = flipud(resamp_img2);



figure(4);
dispImage(jj);
% hold on
% imcontour(flipud(jj));
% hold on
% imcontour(flipud(jj2));



