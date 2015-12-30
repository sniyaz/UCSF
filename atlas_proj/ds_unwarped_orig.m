function [] = ds_unwarped_orig()

    %To be run from the atlas_proj directroy, where file paths are set
    %correctly. Script to downsize and create the adhoc consesus matrix for
    %the original, unwarped atlases.
    
    sizes = dlmread('project_data/sizes_ds.txt');
    
    original_MRI = load('newDataHigRes_Segmentation/Atlas2/Original/Image.mat');
    original_MRI = original_MRI.OrImage;
    original_MRI_ds = resize(original_MRI, sizes);
    dlmwrite('project_data/static/im2_orig_ds.txt', original_MRI_ds);
    
    original_mask = load('newDataHigRes_Segmentation/Atlas2/Original/MFC.mat');
    original_mask = original_mask.Mask;
    original_mask = logical(original_mask);
    original_mask_ds = double(resize(original_mask, sizes));
    
    dlmwrite('project_data/static/seg2_orig_ds.txt', original_mask_ds);
    
    %deforming the downsampled mask to make an ad-hoc consensus matrix
    SE = strel('disk', 1);
    mask_dil = imdilate(original_mask_ds, SE);
    mask_erode = imerode(original_mask_ds, SE);
    ad_hoc = original_mask_ds
    ad_hoc(mask_dil & ~mask_erode) = 0.5
    dlmwrite('project_data/static/consensus_adhoc_2.txt', ad_hoc);
    
end
