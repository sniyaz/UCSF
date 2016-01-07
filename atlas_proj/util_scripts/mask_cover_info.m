function [] = mask_cover_info()

    sizes = dlmread('../project_data/sizes_ds.txt');
    
    %mask = dlmread('../project_data/static/target_gold_ds.txt');
    %mask = reshape(mask, sizes);
    
    truth = dlmread('../project_data/static/MT_gold_ds.txt');
    truth = reshape(truth, sizes);
    
    other_mask = load('../project_data/static/target_consensus_threshold.txt');
    %morphed = morphed.MovedMask.Data;
    other_mask = reshape(other_mask, sizes);
    other_mask = logical(other_mask);
    
    interest_points = find(other_mask ~= 0);
    [I, J, K] = ind2sub(size(other_mask), interest_points);
    rsc_is = [min(I), max(I), min(J), max(J), min(K), max(K)]
    
    intersect_size = size(intersect(find(other_mask == 1), find(truth == 1)), 1);
    union_size = size(union(find(other_mask == 1), find(truth == 1)), 1);
    JI = intersect_size/union_size
    
    slice1 = other_mask(:,:,73);
    slice2 = truth(:,:,73);
    
    slice_intersect_size = size(intersect(find(slice1 == 1), find(slice2 == 1)), 1);
    slice_union_size = size(union(find(slice1 == 1), find(slice2 == 1)), 1);
    slice_JI = slice_intersect_size/slice_union_size
    
end