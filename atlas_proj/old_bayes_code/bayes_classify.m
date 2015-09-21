function [label] = bayes_classify(target_image, consensus_matrix, x, y, radius)
    
    conditional_prob_matrix = [];

    %Enter the name of every bayesian helper function used into the cell array
    %Aka the functions used to calculuate each "dimension" of a certain voxel.
    dimensions_arr = cell(1, 1);
    dimensions_arr{1} = 'intensity_bayes_helper';
    
    
    in_distribution = [];
    out_distribution = [];
    %smoothing_constant = 0;
    
    
    %For each dimesion, we add a layer to a two element-wide matrix that
    %represents [probability of being this point|in segmentation,
    % probability of being this point|out of ssegmentation]
    for i = 1:size(dimensions_arr, 2)
          
        current_dim = dimensions_arr{i};
        current_dim_func = str2func(current_dim);
        in_distribution = dlmread(strcat('bayes_data/', current_dim, '_IN_data.txt'));
        out_distribution = dlmread(strcat('bayes_data/', current_dim, '_OUT_data.txt'));
        %Laplace Smoothing to prevent zero probabilities killing us
        %For when we used logs, which we no longer do.
        %smoothing_constant = (0.0001)/((sum(in_distribution) + sum(out_distribution))/2);
        
        prob_matrix_contribution = [];
        target_voxel_value = current_dim_func(y, x, radius, target_image);
        %In learning, we had to start from 1 since MATLab won't allow 0
        %indexing, and thus we had to 
        if target_voxel_value == 0
            target_voxel_value = 1;
        end
        prob_matrix_contribution(1) = (in_distribution(target_voxel_value))/(sum(in_distribution));
        prob_matrix_contribution(2) = (out_distribution(target_voxel_value))/(sum(out_distribution));
        conditional_prob_matrix = vertcat(conditional_prob_matrix, prob_matrix_contribution);
    end
    
    
    %All of this math follow directly fro Bayes's Rule. We multiply the
    %conditional sub-probabilities for each dimension, then the consensus
    %matrix probability, which we take as the a priori probability of this
    %voxel being part of the segmentation.
    in_prob = 1;
    out_prob = 1;

    for i = 1:size(conditional_prob_matrix, 1)
        in_prob = in_prob*conditional_prob_matrix(i, 1);
    end
    
    for j = 1:size(conditional_prob_matrix, 1)
        out_prob = out_prob*conditional_prob_matrix(j, 2);
    end
    
    in_prob = in_prob*consensus_matrix(y, x);
    out_prob = out_prob*(1 - consensus_matrix(y, x));
    
    if in_prob > out_prob
        label = 1;
    else
        label = 0;
    end
    
end