function [mx] = mx_create(target_image, atlas_image_cell, x, y)

    num_atlases = length(atlas_image_cell);

    mx = zeros(num_atlases, num_atlases);
 
    radius = 5;
    
    for i = 1:num_atlases
        for j = 1:num_atlases
            if ~(mx(j, i) == 0);
                mx(i , j) = mx(j, i);
            else
                mx(i, j) = SSD(target_image, atlas_image_cell{i}, atlas_image_cell{j}, x, y, radius);
            end
        end
    end
 
end


function [out] = SSD(target_image, atlas_image_a, atlas_image_b, x, y, radius)

    sum = 0;
    beta = 3;
    
    for i = x-radius:x+radius
        for j = y-radius:y+radius
            
            local_difference_a = target_image(j,i) - atlas_image_a(j,i); %MatLAB does (y, x) indexing!!!
            local_difference_b = target_image(j,i) - atlas_image_b(j,i);
            sum = sum + (local_difference_a*local_difference_b);
        end
    end
    
    out = power(sum, beta);
    
    
end

