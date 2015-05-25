function [consensus_matrix] = consensus(target_image, image_cell, seg_cell)

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
