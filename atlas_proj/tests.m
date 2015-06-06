function [out] = test()
    
    target = imread('test_data/brains/brain_1.jpg')
    seg1 = dlmread('test_data/brains/brain_2_seg.txt') 
    seg2 = dlmread('test_data/brains/brain_3_seg.txt')
    seg3 = dlmread('test_data/brains/brain_4_seg.txt')
    
    %seg4 = dlmread('test_data/ball_seg_4.txt')
    %seg5 = dlmread('test_data/ball_seg_5.txt')
    
    
    atlas_images = cell(1, 3)
    atlas_images{1} = imread('test_data/brains/brain_2.jpg');
    atlas_images{2} = imread('test_data/brains/brain_3.jpg');
    atlas_images{3} = imread('test_data/brains/brain_4.jpg');
    
    %atlas_images{4} = target;
    %atlas_images{5} = target;
    
    
    atlas_seg = cell(1, 3)
    atlas_seg{1} = seg1;
    atlas_seg{2} = seg2;
    atlas_seg{3} = seg3;
    
    %atlas_seg{4} = seg4;
    %atlas_seg{5} = seg5;
    
    
    
    
    %A crappy attempt at making our consensus matrix into a binary map!
    %Soon to be replaced with Bayesian Classifier! 
    test_output = consensus(target, atlas_images, atlas_seg);
    
    %Save it?
    dlmwrite('test_consensus_mat.txt', test_output)
        
    for i = 1:size(test_output, 2)
        for j = 1:size(test_output, 1)
            if test_output(j, i) > 0.5
                test_output(j, i) = 1;
            else
                test_output(j, i) = 0;
            end
        end
    end
    
    
    target(~test_output) = 0;
    imshow(target)
    out = test_output
end    