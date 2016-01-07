function [labeled_image, super_pixel_cell] = kmeans_init(num_centroids, grad_weight, use_gc)
  
    sizes_3d = dlmread('project_data/sizes_ds.txt');
    
    target_cube = dlmread('project_data/static/target_ds.txt');
    target_cube = reshape(target_cube, sizes_3d);
    
    consensus_cube = dlmread('project_data/static/target_consensus_ds.txt');
    consensus_cube = reshape(consensus_cube, sizes_3d);
    
    %{
    %Extra cruft for SVM initialiation
    target_cube = dlmread('project_data/im1_ds.txt');
    target_cube = reshape(target_cube, sizes_3d);
    
    consensus_cube = dlmread('project_data/seg1_ds.txt');
    consensus_cube = reshape(consensus_cube, sizes_3d);
    %Extra SVM Cruft Ends!
    %}
    
    
    target_cube_size_copy = size(target_cube);
    interest_points = find(consensus_cube ~= 0);
    [I, J, K] = ind2sub(size(target_cube), interest_points);
    rsc_is = [min(I), max(I), min(J), max(J), min(K), max(K)]
    target_cube = target_cube(min(I):max(I), min(J):max(J), min(K):max(K));
    consensus_cube = consensus_cube(min(I):max(I), min(J):max(J), min(K):max(K));
    target_cube_copy = target_cube;
    
    
    
    
    %set every voxel with zero probability in the target image equal to some
    %ridiculous value so that all of them fall into a single
    %bucket upon the implementation of the graph cut algorithm
    target_cube(find(consensus_cube == 0)) = 100000000;
    point_mapping = find(consensus_cube ~= 0);
    
   
    %Call to KMeans for initialization...
    target_points = target_cube(point_mapping);
    %Normalize the intensity values so intensity and probability have equal
    %influence in KMeans
    target_points = target_points/max(target_points);
    
    %Including propbability information in KMeans.
    probability_data = consensus_cube(point_mapping);
    %Normalize the probability values so intensity and probability have equal
    %influence in KMeans
    probability_data = probability_data/norm(probability_data);
    probability_data = probability_data;
    %target_points = horzcat(target_points, probability_data);
    
    %Including spatial information in KMeans. Not always done.
%     spatial_data = horzcat(I, J, K);
%     spatial_data = spatial_data/max(max(spatial_data));
%     target_points = horzcat(target_points, spatial_data);
    
    %We want the behavior of KMeans to be deterministic. So we take
    %num_centroid evenly spaced points in the target_points input as our
    %start centroids.
    kmeans_start_indicies = transpose(int32(linspace(1, size(target_points, 1), num_centroids)));
    kmeans_start_centroids = target_points(kmeans_start_indicies, :);
    
    %[idx, c] = kmeans(target_points, num_centroids);
    [idx, c] = kmeans(target_points, [], 'start', kmeans_start_centroids);
    
    %Plotting the kmeans clusters as a sanity  check!
    kmeans_cube = zeros(size(target_cube));
    kmeans_cube(point_mapping) = idx;
%     kmeans_labels = kmeans_cube(:,:,5)
%     imagesc(kmeans_labels); 
        
    labeled_image = zeros(target_cube_size_copy);
    labeled_image(find(labeled_image == 0)) = num_centroids+1;
    
    if use_gc == 1
    
        super_pixel_cell = cell(1, num_centroids);

        %BEGIN graph cut portion of super-pixel creation.

        %We have an extra centroid/label in our label_cost matrix. This is due
        %to the fact that we need to account for the extra label that all the
        %zero probability pixels fall into (remembering that we set their
        %intensity to an absurd value)

        absurd_cost = single(100000000);

        % calculate the data cost per cluster center
        label_costs = zeros(size(target_cube, 1), size(target_cube, 2), size(target_cube, 3), num_centroids + 1, 'single');
        for ci=1:num_centroids
            % use covariance matrix per cluster
            icv = inv(cov(target_points(idx==ci)));    
            dif = target_points - repmat(c(ci,:), [size(target_points,1) 1]);
            % data cost is minus log likelihood of the pixel to belong to each
            % cluster according to its intensity value
            individual_costs = sum((dif*icv).*dif./2,2);
            new_label_cube = zeros(size(target_cube, 1), size(target_cube, 2), size(target_cube, 3));
            new_label_cube(point_mapping) = individual_costs;
            new_label_cube(find(consensus_cube == 0)) = absurd_cost;
            label_costs(:,:,:,ci) = new_label_cube;
        end

        last_centroid_costs = zeros(size(target_cube, 1), size(target_cube, 2), size(target_cube, 3), 'single');
        last_centroid_costs(point_mapping) = absurd_cost;
        label_costs(:,:,:,num_centroids+1) = last_centroid_costs;

        % smoothness term: 
        % constant part
        sC = ones(num_centroids+1);

        gch = GraphCut('open', label_costs, sC, target_cube)

        [gch L] = GraphCut('expand',gch)
        gch = GraphCut('close', gch);

        L = reshape(L, size(target_cube));

        %Prepare values for return.
        
        labeled_image(rsc_is(1):rsc_is(2), rsc_is(3):rsc_is(4), rsc_is(5):rsc_is(6)) = L+1;


        %{
        for i = 1:size(labeled_image, 1)
            for j = 1:size(labeled_image, 2)
                for k = 1:1:size(labeled_image, 3)
                    current_label = labeled_image(i,j,k);
                    %That extra centroid is just bunk that we don't care about!
                    if current_label ~= num_centroids+1




                        super_pixel_cell{current_label} = vertcat(super_pixel_cell{current_label}, [i, j, k]);

                        %for plotting at the the end:

                        %colors = [0, 600, 400, 200, 800, 1000, 1200];
                        %color_selector = mod(current_label, 7) + 1;
                        %target_im_cpy(i, j) = colors(color_selector);
                    end

                end
            end
        end
        %}

        %upsample back
        %labeled_image = resize(labeled_image, final_cube_size);


        % show results

        %sample_slice = labeled_image(:,:,70);

        sample_slice = L(:,:,4);
        sample_slice = sample_slice + 1;
        imagesc(sample_slice);

        %Overlay

        %{
        imshow(target_cube(:,:,70))
        hold on
        sample_slice = L(:,:,10);
        sample_slice = sample_slice + 1;
        h = imagesc(sample_slice);
        hold off
        alpha = zeros(size(target_cube_copy(:,:,10)));
        alpha(find(alpha == 0)) = 0.1;
        set(h, 'AlphaData', 0.5);
        %}
    elseif use_gc == 0
        labeled_image(rsc_is(1):rsc_is(2), rsc_is(3):rsc_is(4), rsc_is(5):rsc_is(6)) = kmeans_cube;
    end
    
    %Save it?
    out = labeled_image;
    dlmwrite('project_data/target_cluster.txt', labeled_image);
    
    
    
    %cropped_labeled_image = labeled_image(min(I):max(I), min(J):max(J))
    
    %subplot(1, 2, 1)
   
    
    %imagesc(cropped_labeled_image)
    %colorbar
    %colormap('hsv')
    
    %subplot(1, 2, 2)
    
    %{
    figure
    mri_slice = target_struc.FixedImage.Data(:,:,150)
    mri_slice = mri_slice(min(I):max(I), min(J):max(J))
    imshow(mri_slice, [])
    %}
    
    %imshow(target_im_cpy, []);
    %imshow(target_im, [])
    %hold on;
    %PlotLabels(L);

    
    %{
    %Create both forms of output for k means ONLY implementation.
    for m = 1:size(idx, 1)
        assigned_centroid = idx(m, 1);
        %Set the label matrx aligning to the input image.
        labeled_image(target_points(m, 1), target_points(m, 2)) = assigned_centroid;
        %Set the cell that clumps pixels into super pixels
        super_pixel_cell{assigned_centroid} = vertcat(super_pixel_cell{assigned_centroid}, [target_points(m, 1), target_points(m, 2)])
    end
    %}
          
end


