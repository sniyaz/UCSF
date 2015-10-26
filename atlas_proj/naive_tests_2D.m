function [out] = test()
    
    target = load('HighResSegmentation/SampleImage.mat');
    %Extracting one slice of the MRI Cube.
    target = target.FixedImage.Data(:,:,150);
    
    %Targeting an MFC segmentation currently, on slice 150 of the target
    %cube.
    seg1 = load('HighResSegmentation/Atlas1/MFC_Atlas1.mat');
    %Binarize the atlas mask.
    seg1 = logical(seg1.MovedMask.Data(:,:,150));
    
    seg2 = load('HighResSegmentation/Atlas2/MFC_Atlas2.mat');
    seg2 = logical(seg2.MovedMask.Data(:,:,150));
    
    atlas_seg = cell(1, 2);
    atlas_seg{1} = seg1;
    atlas_seg{2} = seg2;
       
    %Now for the atlas images!
    im_1 = load('HighResSegmentation/Morphed1.mat');
    im_2 = load('HighResSegmentation/Morphed2.mat');
    
    im_1 = im_1.RegMoving.Data(:,:,150);
    im_2 = im_2.RegMoving.Data(:,:,150);

    %eliminating negative intensity values...
    im_1(find(im_1 < 0)) = 0;
    im_2(find(im_2 < 0)) = 0;
    
   
    atlas_images = cell(1, 2);
    atlas_images{1} = double(im_1);
    atlas_images{2} = double(im_2);
      
    %Run the core algorithm.
    test_output = core_algo(target, atlas_images, atlas_seg, 5);
    
    %Sometimes we get anegative consensuses data point. We treat these as probabilities
    %later, so the ones that (rarely) come out negative need to become 0.
    test_output(find(test_output < 0)) = 0;

    %Save it?
    dlmwrite('test_consensus_mat.txt', test_output);
        
    %A crappy attempt at making our consensus matrix into a binary map!
    %Soon to be replaced with Bayesian Classifier! 
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
    imshow(target, [])
    out = test_output
end    