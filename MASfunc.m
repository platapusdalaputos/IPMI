function [masked1_reshape, masked2_reshape, summ] = MASfunc(lmsd_map, storemask1, storemask2, m)

% Calculating the registration weights (rw) at each pixel

n = m;

lmsd_map_reshape = reshape(lmsd_map, [n,340,270]);

rw = [];

for j = 1:n
    for k = 1:340
        for l =1:270                
            rw(j,k,l) = 1/(1+lmsd_map_reshape(j,k,l));
        end
    end
end

% Summing the registration weights in all the atlas images 

sum_rw = sum(rw);


% Finding the registration weighted norm 

rw_norm = [];

for j = 1:n
    for k = 1:340
        for l =1:270

            rw_norm(j,k,l) = rw(j,k,l)/sum_rw(1,k,l);
%             rw_norm(j,k,l) = rw(j,k,l)/sum_rw;

        end
    end
end

% Performing the probabilistic multi-atlas segmentation (MA) part1

summ = sum(rw_norm);


MA = zeros(n,340,270);
MA2 = zeros(n,340,270);

stored_mask = reshape(storemask1, [n,340,270]);
stored_mask2 = reshape(storemask2, [n,340,270]);

for j = 1:n
    for k = 1:340
        for l =1:270

            MA(j,k,l) = rw_norm(j,k,l)*stored_mask(j,k,l);
            MA2(j,k,l) = rw_norm(j,k,l)*stored_mask2(j,k,l);

        end
    end
end


% Performing the probabilistic multi-atlas segmentation (MAS) part2

MAS = sum(MA);
MAS2 = sum(MA2);



% Masking the MAS (brain) and MAS2 (spinal cord)

masked1 = MAS;
masked1(MAS>=0.5) = 1;
masked1(MAS<0.5) = 0;

masked2 = MAS2;
masked2(MAS2>=0.5) = 1;
masked2(MAS2<0.5) = 0;

masked1_reshape = reshape(masked1,[340, 270]);
masked2_reshape = reshape(masked2,[340, 270]);
