function [eval] = cluster_eval(num_clusters)

    num_labels = num_clusters + 1

    sizes_3d = dlmread('project_data/sizes_ds.txt');
    sizes_2d = [sizes_3d(1), sizes_3d(2)];
  
    %Suite to evaluate clustering on target image (usually used)
    
    labeled_mri = dlmread('project_data/gc_labeled_ds.txt');
    labeled_mri = reshape(labeled_mri, sizes_3d);
    
    base_truth1 = dlmread('project_data/ground_truths/MFC75_gt.txt');
    base_truth1 = reshape(base_truth1, sizes_2d);
    
    base_truth2 = dlmread('project_data/ground_truths/MFC76_gt.txt');
    base_truth2 = reshape(base_truth2, sizes_2d);
    
    base_truth3 = dlmread('project_data/ground_truths/MFC77_gt.txt');
    base_truth3 = reshape(base_truth3, sizes_2d);
    
    base_truth4 = dlmread('project_data/ground_truths/MFC78_gt.txt');
    base_truth4 = reshape(base_truth4, sizes_2d);
    
    
    
    %Suite (usually commented out) to evaluate clusterings on atlas images,
    %for which the truth is certain (and not my terrible segmentations...)
    
    labeled_mri = dlmread('project_data/atlas1_cluster_ds.txt');
    labeled_mri = reshape(labeled_mri, sizes_3d);
    actual_seg = dlmread('project_data/seg1_ds.txt');
    actual_seg = reshape(actual_seg, sizes_3d);
    
    base_truth1 = actual_seg(:,:,75);
    base_truth2 = actual_seg(:,:,76);
    base_truth3 = actual_seg(:,:,77);
    base_truth4 = actual_seg(:,:,78);
    
    %End atlas clustering evaluation stuff....
    
    
    base_truth_cell = {};
    base_truth_cell{1} = base_truth1;
    base_truth_cell{2} = base_truth2;
    base_truth_cell{3} = base_truth3;
    base_truth_cell{4} = base_truth4;
    
    

    base_image_index = 74;
    jaccard_indicies = [];
    
    for i = 1:4
        
        index = base_image_index + i;
        current_slice = labeled_mri(:,:,index);
        best_seg = zeros(size(current_slice));
        ground_truth = base_truth_cell{i};
        
        for l = 1:num_labels     
            label_points = find(current_slice == l);
            decision_points = ground_truth(label_points);
            best_seg(label_points) = mode(decision_points);
        end
        
        intersect_size = size(intersect(find(best_seg == 1), find(ground_truth == 1)), 1);
        union_size = size(union(find(best_seg == 1), find(ground_truth == 1)), 1);
        JI = intersect_size/union_size;
        
        jaccard_indicies = [jaccard_indicies, JI];
            
    end
    
    
    eval = mean(jaccard_indicies)

end
