function [out] = consensus_3d()
    
    clear all
    close all

    sizes_3d = dlmread('project_data/sizes_ds.txt');
    
    target = dlmread('project_data/target_ds.txt');
    target = reshape(target, sizes_3d);
    
    seg1 = logical(dlmread('project_data/seg1_ds.txt'));
    seg1 = reshape(seg1, sizes_3d);
    seg1_orig = seg1;
    
    seg2 = logical(dlmread('project_data/seg2_ds.txt'));
    seg2 = reshape(seg2, sizes_3d);
    seg2_orig = seg2;

    
    im_1 = dlmread('project_data/im1_ds.txt');
    im_1 = reshape(im_1, sizes_3d);
    
    im_2 = dlmread('project_data/im2_ds.txt');
    im_2 = reshape(im_2, sizes_3d);
        
    %We do this multiple times becasue the original voxels were not
    %isotrophic, and we need to upsample to make them so (just for
    %consensus generation).
    target = resize(target, [size(target, 1), size(target, 2), 221]);
    
    seg1 = resize(seg1, [size(target, 1), size(target, 2), 221]);
    seg2 = resize(seg2, [size(target, 1), size(target, 2), 221]);
   
    atlas_seg = cell(1, 2);
    atlas_seg{1} = seg1;
    atlas_seg{2} = seg2;

    %Now for the atlas images!
    im_1 = resize(im_1, [size(target, 1), size(target, 2), 221]);
    im_2 = resize(im_2, [size(target, 1), size(target, 2), 221]);

    atlas_images = cell(1, 2);
    atlas_images{1} = im_1;
    atlas_images{2} = im_2;

    %Run the core algorithm.
    consensus_cube = core_algo_3D(target, atlas_images, atlas_seg, 2);
    
    %Need to downsample the consensus_cube to match the original MRI cube
    consensus_cube = resize(consensus_cube, sizes_3d);
    
    %"Purify" the cube after the downsampling
    no_hope = intersect(find(seg1_orig == 0), find(seg2_orig == 0));
    consensus_cube(no_hope) = 0;
    
    %Save it?
    dlmwrite('project_data/consensus_ds.txt', consensus_cube);
    
    imshow(consensus_cube(:,:,75), [])
    
end    