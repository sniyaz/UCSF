function [out_prob_pair] = intensity_learning(radius, fun_str) 

    atlas_images = cell(1, 3)
    atlas_images{1} = imread('test_data/knees/knee_1.jpg');
    atlas_images{2} = imread('test_data/knees/knee_2.jpg');
    atlas_images{3} = imread('test_data/knees/knee_3.jpg');
    
    atlas_seg = cell(1, 3)
    seg1 = dlmread('test_data/knees/knee_seg_1.txt') 
    seg2 = dlmread('test_data/knees/knee_seg_2.txt')
    seg3 = dlmread('test_data/knees/knee_seg_3.txt')
    atlas_seg{1} = seg1;
    atlas_seg{2} = seg2;
    atlas_seg{3} = seg3;
    
    num_atlases = length(atlas_images);
    
    in_distribution = []
    out_distribution = []
    
    for i = 1:num_atlases
        lower_x = radius + 1;
        upper_x = size(atlas_images{i}, 2) - radius;
        
        lower_y = radius + 1;
        upper_y = size(atlas_images{i}, 1) - radius;
        
        for x = lower_x:upper_x
            for y = lower_y:upper_y
                sum = double(0);
                for m = x-radius:x+radius
                    for n = y-radius:y+radius
                        sum = sum + double(atlas_images{i}(n, m));
                    end
                end
                
                if atlas_seg{i}(y, x) == 1
                    if size(in_distribution, 2) < sum
                        in_distribution(sum) = 0;
                    end
                    in_distribution(sum) = in_distribution(sum) + 1;
                else
                    if size(out_distribution, 1) < sum
                        out_distribution(sum) = 0;
                    end
                    out_distribution(sum) = out_distribution(sum) + 1;
                end
            end
        end
        
    end
    
    dlmwrite('bayes_data/intensity_in_data.txt', in_distribution)
    dlmwrite('bayes_data/intensity_out_data.txt', out_distribution)
end

    
    
    
    
    
        
            
                
                
                
                    
                
                
                    
                    
                    
                    
                    
                    
                    
                        
                    
                
                
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        