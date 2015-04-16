function [consensus_matrix] = consensus(target_image, label, image_cell, seg_cell)

    consensus_matrix = []    
    atlas_num = size(image_cell, 2)
    radius = 2
    
    lower_x = radius
    upper_x = size(target_image, 2) - radius

    lower_y = radius
    upper_y = size(target_image, 1) - radius

    for x = lower_x:upper_x
        for y = lower_y:upper_y
            
            total_ssd = 0
            consensus_sum = 0
            for i = 1:atlas_num
                weighting = SSD(target_image, atlas{i}, x y, radius)
                matching = not(xor(label(x, y), atlas{i}(x,y)))
                total_ssd = total_ssd + weighting
                consensus_sum = = consensus_sum + weighting*(matching)
                
            end
            
            consensus_sum = consensus_sum/total_ssd
            consensus_matrix(x,y) = consensus_sum
        end
        
    end  
           

end
