function [JI] = cluster_eval(num_clusters)

    num_labels = num_clusters + 1

    sizes_3d = dlmread('project_data/sizes_ds.txt');
    sizes_2d = [sizes_3d(1), sizes_3d(2)];
  
    %Suite to evaluate clustering on target image (usually used)
    
    labeled_mri = dlmread('project_data/atlas1_orig_cluster_ds.txt');
    labeled_mri = reshape(labeled_mri, sizes_3d);
    
    ground_truth = dlmread('project_data/seg1_orig_ds.txt');
    ground_truth = reshape(ground_truth, sizes_3d);
    
    best_seg = zeros(sizes_3d);
    
    for l = 1:num_labels     
        label_points = find(labeled_mri == l);
        decision_points = ground_truth(label_points);
        best_seg(label_points) = mode(decision_points);
    end

    intersect_size = size(intersect(find(best_seg == 1), find(ground_truth == 1)), 1);
    union_size = size(union(find(best_seg == 1), find(ground_truth == 1)), 1);
    JI = intersect_size/union_size

end
