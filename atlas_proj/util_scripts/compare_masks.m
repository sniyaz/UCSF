function [] = compare_masks(slice)

    sizes = dlmread('../project_data/sizes_ds.txt');
    mask1 = dlmread('../project_data/static/target_consensus_threshold.txt');
    mask2 = dlmread('../project_data/static/MT_gold_ds.txt');
    mask1 = reshape(mask1, sizes);
    mask2 = reshape(mask2, sizes);

    slice1 = mask1(:,:,slice);
    slice2 = mask2(:,:,slice);
    
    subplot(1,2,1);
    imshow(slice1, []);
    subplot(1,2,2);
    imshow(slice2, []);

end
