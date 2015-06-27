function [label] = bayes_classify(target_image, consensus_matrix, x, y, radius)
    %Note that we maximize the log of probabilities in this classifier, an effort to prevent underflow.
    
    conditional_prob_matrix = [];

    %Enter the name of every bayesian helper function used into the cell array
    %Aka the functions used to calculuate each "dimension" of a certain voxel.
    dimensions_arr = cell(1, 1);
    dimensions_arr{1} = 'intensity_bayes_helper';
    
    
    in_distribution = [];
    out_distribution = [];
    smoothing_constant = 0;
    
    
    for i = 1:size(dimensions_arr, 2)
          
        current_dim = dimensions_arr{i};
        current_dim_func = str2func(current_dim);
        in_distribution = dlmread(strcat('bayes_data/', current_dim, '_IN_data.txt'));
        out_distribution = dlmread(strcat('bayes_data/', current_dim, '_OUT_data.txt'));
        %Laplace Smoothing to prevent zero probabilities killing us
        smoothing_constant = (0.0001)/((sum(in_distribution) + sum(out_distribution))/2);
        
        prob_matrix_contribution = [];
        target_voxel_value = current_dim_func(x, y, radius, target_image);
        prob_matrix_contribution(1) = log((in_distribution(target_voxel_value))/(sum(in_distribution)) + smoothing_constant);
        prob_matrix_contribution(2) = log((out_distribution(target_voxel_value))/(sum(out_distribution)) + smoothing_constant);
        conditional_prob_matrix = vertcat(conditional_prob_matrix, prob_matrix_contribution);
    end
    

    in_prob = 0;
    out_prob = 0;

    for i = 1:size(conditional_prob_matrix, 1)
        in_prob = in_prob+conditional_prob_matrix(i, 1);
    end
    
    for j = 1:size(conditional_prob_matrix, 1)
        out_prob = out_prob+conditional_prob_matrix(j, 2);
    end
    
    in_prob = in_prob + log(consensus_matrix(y, x) + smoothing_constant);
    out_prob = out_prob + log((1 - consensus_matrix(y, x)) + smoothing_constant);
    
    if in_prob > out_prob
        label = 1;
    else
        label = 0;
    end
    
end