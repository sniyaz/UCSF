function [out] = consensus_3d()
    
    clear all
    close all

    target_cube = dlmread('project_data/target_ds.txt');
    seg1_cube = load('HighResSegmentation/Atlas1/MFC_Atlas1.mat');
    seg2_cube = load('HighResSegmentation/Atlas2/MFC_Atlas2.mat');
    im_1_cube = load('HighResSegmentation/Morphed1.mat');
    im_2_cube = load('HighResSegmentation/Morphed2.mat');
    

    target = double(target_cube.FixedImage.Data);
    
    %We do this multiple times becasue the original voxels were not
    %isotrophic, and we need to upsample to make them so (just for
    %consensus generation).
    target = resize(target, [size(target, 1), size(target, 2), 442]);
    
    
    %Binarize and upsample the atlas mask.
    seg1 = seg1_cube.MovedMask.Data;
    seg2 = seg2_cube.MovedMask.Data;
    
    seg1 = resize(seg1, [size(target, 1), size(target, 2), 442]);
    seg2 = resize(seg2, [size(target, 1), size(target, 2), 442]);
    %221
    
    seg1 = logical(seg1);
    seg2 = logical(seg2);
    
    
    atlas_seg = cell(1, 2);
    atlas_seg{1} = seg1;
    atlas_seg{2} = seg2;

    %Now for the atlas images!        
    im_1 = im_1_cube.RegMoving.Data;
    im_2 = im_2_cube.RegMoving.Data;
    
    im_1 = resize(im_1, [size(target, 1), size(target, 2), 442]);
    im_2 = resize(im_2, [size(target, 1), size(target, 2), 442]);

    atlas_images = cell(1, 2);
    atlas_images{1} = double(im_1);
    atlas_images{2} = double(im_2);

    %Run the core algorithm.
    consensus_cube = core_algo_3D(target, atlas_images, atlas_seg, 2);
    
    %Need to downsample the consensus_cube to match the original MRI cube
    consensus_cube = resize(consensus_cube, [size(target, 1), size(target, 2), 201]);
    
    %Save it?
    out = consensus_cube;
    linear_cube = reshape(consensus_cube, size(consensus_cube(:)));
    dlmwrite('linear_true_consensus_cube.txt', linear_cube);
    
    imshow(consensus_cube(:,:,150), [])
    
end    