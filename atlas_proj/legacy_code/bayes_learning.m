function [out_prob_pair] = bayes_learning(num_centroids) 

    %Functions that correspond to each dimension in the Bayes Analysis. Take a pixel and spit out the dimensional value for that pixel.    
    dimensions = {'intensity_bayes_helper', 'neighbor_intensity_bayes_helper','local_entropy_bayes_helper', 'local_std_bayes_helper'}

    %Which slice are you trying to segment in the target cube?    
    target_slice = 150;
    
    %How much to move forward of backwards from target slice in MRI cube to
    %gather data. I.e. if target slice is 105 and this is 3, in each atlas
    %cube we search through slices 102-108! So this is like a learning
    %area.
    lateral_search_dist = 1;
    
    atlas_number = 1;
    atlas_seg = cell(1, 1);
    atlas_images = cell(1, 1);
  
    atlas_seg_cubes = {'HighResSegmentation\Atlas1\MFC_Atlas1.mat', 'HighResSegmentation\Atlas2\MFC_Atlas2.mat'};
    atlas_image_cubes = {'HighResSegmentation/Morphed1.mat', 'HighResSegmentation/Morphed2.mat'};
    
    
    
    for i = 1:size(atlas_seg_cubes, 2)
        cur_seg_cube = load(atlas_seg_cubes{i});
        cur_image_cube = load(atlas_image_cubes{i});
        for j = target_slice-lateral_search_dist:target_slice+lateral_search_dist
            %Binarize the atlas masks.
            cur_seg_slice = logical(cur_seg_cube.MovedMask.Data(:,:,j));
            cur_image_slice = cur_image_cube.RegMoving.Data(:,:,j);
            
            atlas_seg{atlas_number} = cur_seg_slice;
            atlas_images{atlas_number} = cur_image_slice;
            atlas_number = atlas_number + 1;
        end
    end
    
    for d = 1:size(dimensions, 2)
        fun_str = dimensions{d}
        helper = str2func(fun_str)
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

                    result = helper(x, y, radius, atlas_images{i});
                    %Our array histogram can't deal with zero-indexing.
                    if result == 0
                        result = 1;
                    end
                    
                    try 
                        if atlas_seg{i}(y, x) == 1
                            if size(in_distribution, 2) < result
                                in_distribution(result) = 0;
                            end
                            in_distribution(result) = in_distribution(result) + 1;
                        else
                            if size(out_distribution, 2) < result
                                out_distribution(result) = 0;
                            end                        

                            out_distribution(result) = out_distribution(result) + 1;
                        end
                    catch ME
                        a = 7
                    end
                end
            end

        end

        if (size(in_distribution, 2) > size(out_distribution, 2))
            out_distribution(size(in_distribution, 2)) = 0
        else
            in_distribution(size(out_distribution, 2)) = 0
        end

        dlmwrite(strcat('bayes_data/', fun_str, '_IN_data.txt'), in_distribution)
        dlmwrite(strcat('bayes_data/', fun_str, '_OUT_data.txt'), out_distribution)
    end
end
    

    
    
    
    
    
        
            
                
                
                
                    
                
                
                    
                    
                    
                    
                    
                    
                    
                        
                    
                
                
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        