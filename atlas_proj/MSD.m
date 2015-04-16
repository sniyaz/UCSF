function [msd] = MSD(target_image, atlas_image)

radius = 3
sum = 0

lower_x = radius
upper_x = size(target_image, 2) - radius

lower_y = radius
upper_y = size(target_image, 1) - radius

for x = lower_x:upper_x
    for y = lower_y:upper_y
        
        for i = x-radius:x+radius
            for j = y-radius:y+radius



end
