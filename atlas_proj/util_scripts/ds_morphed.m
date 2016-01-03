function [] = ds_morphed()

    %To be run from the atlas_proj directroy, where file paths are set
    %correctly. Script to downsize for the warped atlases.
    
    sizes = dlmread('../project_data/sizes_ds.txt');
    
%     warped_MRI = load('../newDataHigRes_Segmentation/Atlas1/Morphed1.mat');
%     warped_MRI = warped_MRI.RegMoving.Data;
%     warped_MRI_ds = resize(warped_MRI, sizes);
%     dlmwrite('../project_data/static/morphed_im1_ds.txt', warped_MRI_ds);
    
    warped_mask = load('../newDataHigRes_Segmentation/Atlas3/MT_Atlas3.mat');
    warped_mask = warped_mask.MovedMask.Data;
    warped_mask(find(warped_mask >= 0.5)) = 1;
    warped_mask(find(warped_mask < 0.5)) = 0;
    warped_mask = logical(warped_mask);
    warped_mask_ds = resize(warped_mask, sizes);
    dlmwrite('../project_data/static/MT_morphed_seg3_ds.txt', warped_mask_ds);
    
end
