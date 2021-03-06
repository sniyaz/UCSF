function [out_prob_pair] = intensity_learning(radius) 

    %We initialialize the atlases (iages and segmentations) that form the
    %learning set for our Bayesian Classifier. Note that these
    %segmentations are manually made by human beings, so they are assumed
    %to be "perfect" and thus form a basis for our probability distribution
    %where a vexel has a probabiity of being either IN or OUT of the
    %segmentation.
    atlas_images = cell(1, 3)
    atlas_images{1} = imread('test_data/knees/knee_1.jpg');
    atlas_images{2} = imread('test_data/knees/knee_2.jpg');
    atlas_images{3} = imread('test_data/knees/knee_3.jpg');
    
    atlas_seg = cell(1, 3)
    atlas_seg{1} = dlmread('test_data/knees/knee_seg_1.txt');
    atlas_seg{2} = dlmread('test_data/knees/knee_seg_2.txt');
    atlas_seg{3} = dlmread('test_data/knees/knee_seg_3.txt');
    
    num_atlases = length(atlas_images);
    
    %This is the cell array of helper functions (one for each dimension that we
    %want to use in our Bayesian classifier). Each one if the name of .m
    %file with the corresponding helper function that gives a certain value
    %to every voxel in an image. 
    
    %This is the format these helpers functions must follow:
    %function [out] = helper(y, x, radius, image)
    dimensions_arr = cell(1, 1);
    dimensions_arr{1} = 'intensity_bayes_helper';
    
    
    
    for d = 1:size(dimensions_arr, 2)
        current_dim = dimensions_arr{d}
        
        in_distribution = []
        out_distribution = []

        for i = 1:num_atlases
            lower_x = radius + 1;
            upper_x = size(atlas_images{i}, 2) - radius;

            lower_y = radius + 1;
            upper_y = size(atlas_images{i}, 1) - radius;

            for x = lower_x:upper_x
                for y = lower_y:upper_y
                    current_dim_func = str2func(current_dim);
                    this_voxel_value = current_dim_func(y, x, radius, atlas_images{i});

                    %We use an aray as a histogram for our probability
                    %distribution. Ie index 5 corresponds to the value of
                    %literally 5, and the value in the arrays in_distribution
                    %and out_distribution at index five indicates how many
                    %instances of voxels that returned value 5 there were. 

                    %We also take the value that we got for our curent voxel
                    %and increment its value in the correct histogram (depending
                    %on whether the voxel was in or out of its relevant image
                    %segmentation. Remember, classifiers use conditional
                    %probabilties, and were are trying to classify whether a
                    %voxel is in or out of a segmentation.
                    if atlas_seg{i}(y, x) == 1
                        %Don't want to overreach the array bounds.
                        if size(in_distribution, 2) < this_voxel_value
                            in_distribution(this_voxel_value) = 0;
                        end
                        in_distribution(this_voxel_value) = in_distribution(this_voxel_value) + 1;
                    else
                        if size(out_distribution, 1) < this_voxel_value
                            out_distribution(this_voxel_value) = 0;
                        end
                        out_distribution(this_voxel_value) = out_distribution(this_voxel_value) + 1;
                    end
                end
            end

        end

        dlmwrite(strcat('bayes_data/', current_dim, '_IN_data.txt'), in_distribution)
        dlmwrite(strcat('bayes_data/', current_dim, '_OUT_data.txt'), out_distribution)
    
    end


end

    
    
    
    
    
        
            
                
                
                
                    
                
                
                    
                    
                    
                    
                    
                    
                    
                        
                    
                
                
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        