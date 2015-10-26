function [consensus_cube] = core_algo(target_cube, image_cube_cell, seg_cell, radius)

    consensus_cube = zeros(size(target_cube));    
    atlas_num = size(image_cube_cell, 2);
    
    
    lower_i = radius + 1;
    upper_i = size(target_cube, 1) - radius;

    lower_j = radius + 1;
    upper_j = size(target_cube, 2) - radius;
    
    lower_k = radius + 1;
    upper_k = size(target_cube, 3) - radius;

    for i = lower_i:upper_i
        for j = lower_j:upper_j
            for k = lower_k:upper_k
                
                %Massive computation savings if all atlas segmentations say
                %that this voxel must be zero. Then there's no need to do
                %all of this work.
                must_inspect = 0;
                for seg_matrix = 1:size(seg_cell, 2)
                    cur_matrix = seg_cell{seg_matrix};
                    if cur_matrix(i, j, k) ~= 0
                        must_inspect = 1;
                        break
                    end
                end
                
                if must_inspect == 1
                    mx = mx_create_3D(target_cube, image_cube_cell, i, j, k, radius);
                    weights = mx_to_weights(mx);
                    atlas_points = [];
                    for a = 1:atlas_num
                        atlas_points(a) = seg_cell{a}(i, j, k);
                    end
                    consensus_cube(i, j, k) = atlas_points*weights;
                end
                
            end
        end
    end 
end


