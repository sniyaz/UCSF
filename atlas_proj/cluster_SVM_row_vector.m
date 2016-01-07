function [super_voxel_data] = cluster_SVM_row_vector(l, labeled_cube, target_cube)

    points = find(labeled_cube == l);
    intensities = double(target_cube(points));
    
    super_voxel_data = [];
    
    %average intensity dimension
    average_intensity = mean(intensities, 1);
    super_voxel_data = [super_voxel_data average_intensity];
    
    %average gradient dimension
    grad = gradient(intensities);
    avg_grad = mean(grad, 1);
    super_voxel_data = [super_voxel_data avg_grad];
    
%     %average spatial info dimension
%     spatial_info = points;
%     avg_spat = mean(spatial_info, 1);
%     super_voxel_data = [super_voxel_data avg_spat];

end