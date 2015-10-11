function [out] = consensus_3d()
    
    clear all
    close all

    target_cube = load('HighResSegmentation/SampleImage.mat');
    seg1_cube = load('HighResSegmentation/Atlas1/MFC_Atlas1.mat');
    seg2_cube = load('HighResSegmentation/Atlas2/MFC_Atlas2.mat');
    im_1_cube = load('HighResSegmentation/Morphed1.mat');
    im_2_cube = load('HighResSegmentation/Morphed2.mat');
    
    consensus_cube = zeros(size(target_cube.FixedImage.Data), 'double');

    for slice = 1:size(target_cube.FixedImage.Data, 3)
        %Extracting one slice of the MRI Cube.
        target = target_cube.FixedImage.Data(:,:,slice);

        %Binarize the atlas mask.
        seg1 = logical(seg1_cube.MovedMask.Data(:,:,slice));
        seg2 = logical(seg2_cube.MovedMask.Data(:,:,slice));

        atlas_seg = cell(1, 2);
        atlas_seg{1} = seg1;
        atlas_seg{2} = seg2;

        %Now for the atlas images!        
        im_1 = im_1_cube.RegMoving.Data(:,:,slice);
        im_2 = im_2_cube.RegMoving.Data(:,:,slice);

        atlas_images = cell(1, 2);
        atlas_images{1} = double(im_1);
        atlas_images{2} = double(im_2);

        %Run the core algorithm.
        consensus_cube(:,:,slice) = core_algo(target, atlas_images, atlas_seg, 5);
    end
    

    %Save it?
    out = consensus_cube;
    linear_cube = reshape(consensus_cube, size(consensus_cube(:)));
    dlmwrite('linear_consensus_cube.txt', linear_cube);
    
end    