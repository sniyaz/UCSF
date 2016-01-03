function [mx] = mx_create_3D(target_cube, atlas_cube_cell, i, j, k, radius)
    num_atlases = length(atlas_cube_cell);

    mx = zeros(num_atlases, num_atlases);
    
    for m = 1:num_atlases
        for n = 1:num_atlases
            if ~(mx(n, m) == 0);
                mx(m , n) = mx(n, m);
            else
                mx(m, n) = SCD(target_cube, atlas_cube_cell{m}, atlas_cube_cell{n}, i, j, k, radius);
            end
        end
    end
    
    mx = mx/(max(max(mx)));
end


function [out] = SCD(target_cube, atlas_cube_a, atlas_cube_b, i, j, k, radius)
    sum = 0;
    beta = 3;
    
    for y = i-radius:i+radius
        for x = j-radius:j+radius
            for z = k-radius:k+radius
            
            local_difference_a = abs(target_cube(y,x,z) - atlas_cube_a(y,x,z)); %MatLAB does (y, x, z) indexing!!!
            local_difference_b = abs(target_cube(y,x,z) - atlas_cube_b(y,x,z));
            sum = sum + (local_difference_a*local_difference_b);
            end
         end
    end

    out = power(sum, beta); 
     
      
end
 