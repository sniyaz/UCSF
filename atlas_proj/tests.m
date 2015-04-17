function [out] = test()
    
    target = imread('/home/sherdil/UCSF/atlas_proj/ball.png')
    seg1 = dlmread('test_data/ball_seg_1.txt')
    
    seg2 = dlmread('test_data/ball_seg_2.txt')
    
    %seg3 = dlmread('test_data/ball_seg_3.txt')
    %seg4 = dlmread('test_data/ball_seg_4.txt')
    %seg5 = dlmread('test_data/ball_seg_5.txt')
    
    
    
    atlas_images = cell(1, 2)
    atlas_images{1} = target
    atlas_images{2} = target
    
    %atlas_images{3} = target
    %atlas_images{4} = target
    %atlas_images{5} = target
    
    
    atlas_seg = cell(1, 2)
    atlas_seg{1} = seg1
    atlas_seg{2} = seg2
    
    %atlas_seg{3} = seg3
    %atlas_seg{4} = seg4
    %atlas_seg{5} = seg5
    
    %A crappy attempt at making our consensus matrix into a binary map!
    test_output = consensus(target, atlas_images, atlas_seg);
    for i = 1:length(test_output, 2)
        for j = 1:length(test_output, 1)
            if test_output(i, j) > 0.5
                test_output(i, j) = 1
            else
                test_output(i, j) = 0
            end
        end
    end
    
    
    
    
    target(~test_output) = 0
    image(target)
end

    
    
    
    
    