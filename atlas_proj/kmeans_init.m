function [labeled_image, super_pixel_cell] = kmeans_init(target_im, consensus_mat)

    clear all
    
    target_im = load('HighResSegmentation/SampleImage.mat');
    %Extracting one slice of the MRI Cube.
    target_im = target_im.FixedImage.Data(:,:,150);
    
    
    target_im = im2double(target_im);
    
    %For Display purposes at the end...
    target_im_cpy = target_im;
    target_im_cpy2 = target_im;
    
    consensus_mat = dlmread('test_consensus_mat.txt');
    
    

    target_points = [];
    point_array_mapping = []

    for i = 1:size(target_im, 1)
        for j = 1:size(target_im, 2)
            if (consensus_mat(i, j) == 0)
                %set every voxel in the target image equal to some
                %ridiculous value so that all of them fall into a single
                %bucket upon the implementation of the graph cut algorithm
                target_im(i, j) = 100000000;
                
            else
                target_points = vertcat(target_points, [target_im(i, j)]); 
                point_array_mapping = vertcat(point_array_mapping, [i, j]);
            end
        end      
    end
    
    num_centroids = 30
    [idx, c] = kmeans(target_points, num_centroids);
    
    super_pixel_cell = cell(1, num_centroids);
    
    %BEGIN graph cut portion of super-pixel creation.
    
    % calculate the data cost per cluster center
    label_costs = zeros(size(target_im, 1), size(target_im, 2), num_centroids + 1, 'single');
    for ci=1:num_centroids
        % use covariance matrix per cluster
        icv = inv(cov(target_points(idx==ci)));    
        dif = target_points - repmat(c(ci,:), [size(target_points,1) 1]);
        % data cost is minus log likelihood of the pixel to belong to each
        % cluster according to its value
        individual_costs = sum((dif*icv).*dif./2,2);
        for p = 1:size(individual_costs, 1)
            i_coord = point_array_mapping(p, 1);
            j_coord = point_array_mapping(p, 2);
            label_costs(i_coord, j_coord, ci) = individual_costs(p);
        end
    end
    
    %We have an extra centroid/label in our label_cost matrix. This is due
    %to the fact that we need to account for the extra label that all the
    %zero probability pixels fall into (remembering that we set their
    %intensity to an absurd value)
    
    absurd_cost = single(1000000);
    
    for i = 1:size(label_costs, 1)
        for j = 1:size(label_costs, 2)
            %Is this a zero probability pixel?
            if consensus_mat(i, j) == 0
                for real_centroid = 1:num_centroids;
                    label_costs(i, j, real_centroid) = absurd_cost;
                end
                label_costs(i, j, num_centroids + 1) = 0;
            else
                label_costs(i, j, num_centroids + 1) = absurd_cost;
                
                
                
                
            end
        end
    end
    
    % smoothness term: 
    % constant part
    sC = ones(num_centroids+1);
    [hC, vC] = spatial_varying_cost_gen(target_im);
    
    gch = GraphCut('open', 10*label_costs, sC, 10000*vC, 10000*hC);
    
    [gch L] = GraphCut('expand',gch);
    gch = GraphCut('close', gch);
    
    %Prepare values for return:
    labeled_image = L+1
    for i = 1:size(labeled_image, 1)
        for j = 1:size(labeled_image, 2)
            current_label = labeled_image(i,j);
            %That extra centroid is just bunk that we don't care about!
            if current_label ~= num_centroids+1
                
                
                %DEBUGGING:
                if consensus_mat(i, j) == 0
                    %THIS IS A PROBLEM!
                    foo = 1
                end
                
                super_pixel_cell{current_label} = vertcat(super_pixel_cell{current_label}, [i, j]);
                
                %for plotting at the the end:
                
                colors = [0, 600, 400, 200, 800, 1000, 1200];
                color_selector = mod(current_label, 7) + 1;
                target_im_cpy(i, j) = colors(color_selector);
                           
            end
        end
    end
    
    
    
    % show results
    imshow(target_im_cpy, []);
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

function [hC, vC] = spatial_varying_cost_gen(im)
    
    im_height = size(im, 1);
    im_width = size(im, 2);
    
    vC = zeros(im_height, im_width, 'single');
    hC = zeros(im_height, im_width, 'single');
    
    for i = 1:(im_height - 1)
        for j = 1:im_width
            vC(i, j) = single(abs(im(i, j) - im(i+1, j)));
        end
    end
    
    for i = 1:(im_height)
        for j = 1:(im_width-1)
            hC(i, j) = single(abs(im(i, j) - im(i, j+1)));
        end
    end
    
end

%-----------------------------------------------%
function ih = PlotLabels(L)

L = single(L);

bL = imdilate( abs( imfilter(L, fspecial('log'), 'symmetric') ) > 0.1, strel('disk', 1));
LL = zeros(size(L),class(L));
LL(bL) = L(bL);
Am = zeros(size(L));
Am(bL) = .5;
ih = imagesc(LL); 
set(ih, 'AlphaData', Am);
colorbar;
colormap 'jet';

end



