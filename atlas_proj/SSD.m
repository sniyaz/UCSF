function [ssd] = SSD(target_image, atlas_image_a, atlas_image_b, x, y, radius)

lower_x = radius
upper_x = size(target_image, 2) - radius

lower_y = radius
upper_y = size(target_image, 1) - radius

for x = lower_x:upper_x
    for y = lower_y:upper_y
%}
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