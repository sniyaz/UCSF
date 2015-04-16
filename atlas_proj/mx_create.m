function [mx] = mx_create(target_image, atlas_image_cell, x, y)

    num_atlases = length(atlas_image_cell)

    mx = zeros(num_atlases, num_atlases)
 
    radius = 2
    
    for i = 1:num_atlases
        for j = 1:num_atlases
            if ~(mx(j, i) == 0)
                mx(i , j) = mx(j, i)
            else
                mx(i, j) = SSD(target_image, atlas_image_cell{i}, atlas_image_cell{j}, x, y, radius)
            end
        end
    end
 
end


function [ssd] = SSD(target_image, atlas_image_a, atlas_image_b, x, y, radius)

    sum = 0
    
    for i = x-radius:x+radius
        for j = y-radius:y+radius
            
            local_difference_a = target_image(i,j) - atlas_image_a(i,j)
            local_difference_b = target_image(i,j) - atlas_image_b(i,j)
            sum = sum + (local_difference_a*local_difference_b)
        end
    end
    
    ssd = sum
    
    
    end

