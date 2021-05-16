function [lmsd_map, storemask1, storemask2] = performRegimg(imgsAtlas, imgsTune,sigma_elastic, sigma_fluid, num_lev, use_composition)
% Function to carry out the registration and extraction of LMSD

lmsd_map = [];
storemask1 = zeros(3,5,340,270);
storemask2 = zeros(3,5,340,270);
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
            imgAtlas2 = imrotate(double(cell2mat(imgsAtlas(X+1))),-90);
            imgAtlas3 = imrotate(double(cell2mat(imgsAtlas(X+2))),-90); 
           
            % Computing the registration          
            [warp_img_loop, def_field_loop]= demonsReg(imgAtlas1, imgTune1,sigma_elastic, sigma_fluid, num_lev, use_composition);
            
            % Re-sampling the segmented images with the calc def field
            resamp_img = resampImageWithDefField(imgAtlas2, def_field_loop, 'linear' , NaN);
            resamp_img2 = resampImageWithDefField(imgAtlas3, def_field_loop, 'linear' , NaN);
                        
            % ensuring the resampled brain-stem image is a binary image
            mask1 = resamp_img;
            mask1(resamp_img>0) = 1;
            mask1(isnan(resamp_img)) = 0; 
            storemask1(i,j,:,:)= mask1;
           
            % ensuring the resampled spinal cord image is a binary image
            mask2 = resamp_img2;
            mask2(resamp_img2>0) = 1;
            mask2(isnan(resamp_img2)) = 0;
            storemask2(i,j,:,:)= mask2;
            
            % displaying the registered and def field warped images  
            dispImage(warp_img_loop); 
            hold on; imcontour(mask1','g') ; imcontour(mask2','r');
            ax = gca;
            title('Atlas');
            pause(1.0);

            % Exporting the trial and error images
%             exportgraphics(ax,fullfile('./Coursework/ParamImages', sprintf('Param_%d_tune_%d_atlas_%d PV%d_%d_%d_%d.jpg',l,i,j,sigma_elastic(l),sigma_fluid(l),num_lev(l),use_composition)),'Resolution',300)
            exportgraphics(ax,fullfile('./final_imgs', sprintf('tune_%d_atlas_%d.jpg',i,j)),'Resolution',300)
            
            % Calculating the LMSD 
            lmsd_map(i,j,:,:) = calcLMSD(warp_img_loop,imgTune1, 20);
            
            
            % X counter for the jth loop 
            X = X+3;
            
        end 
 

    end