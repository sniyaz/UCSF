function [consensus_matrix] = core_algo(target_image, image_cell, seg_cell)

    consensus_matrix = zeros(size(target_image, 1), size(target_image, 2));    
    atlas_num = size(image_cell, 2);
    radius = 5;
    
    lower_x = radius + 1;
    upper_x = size(target_image, 2) - radius;

    lower_y = radius + 1;
    upper_y = size(target_image, 1) - radius;

    for x = lower_x:upper_x
        for y = lower_y:upper_y
            mx = mx_create(target_image, image_cell, x, y);
            weights = mx_to_weights(mx);
            atlas_points = [];
            for i = 1:atlas_num
                atlas_points(i) = seg_cell{i}(y, x);
            end
            consensus_matrix(y, x) = atlas_points*weights;
        end
    end 
end


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


function [weights] = mx_to_weights(mx_input)
    mx_size = size(mx_input, 1);
    
    %This is to test the alpha factor
    alpha = 0.01;
    m_alpha = alpha*eye(mx_size);
    mx_input = mx_input + m_alpha;
    
    mx_inverse = inv(mx_input);
    ones_n = ones(mx_size, 1);
    weights = mx_inverse*ones_n;
    constant = (transpose(ones_n)*(mx_inverse*ones_n));
    weights = weights/constant;
    
    % To satisfy that all weights add up to 1!
    weights = weights/sum(weights);
end
 


