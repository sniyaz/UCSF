function [JI] = cluster_eval(num_clusters)

    num_labels = num_clusters + 1

    sizes_3d = dlmread('project_data/sizes_ds.txt');
    
    %Suite to evaluate clustering on target image (usually used)
    
    labeled_mri = dlmread('project_data/target_cluster.txt');
    labeled_mri = reshape(labeled_mri, sizes_3d);
    
    ground_truth = dlmread('project_data/static/MT_gold_ds.txt');
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
    
    slice1 = best_seg(:,:,69);
    slice2 = ground_truth(:,:,69);
   
    slice_intersect_size = size(intersect(find(slice1 == 1), find(slice2 == 1)), 1);
    slice_union_size = size(union(find(slice1 == 1), find(slice2 == 1)), 1);
    slice_JI = slice_intersect_size/slice_union_size
    

end
