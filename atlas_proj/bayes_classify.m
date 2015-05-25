function [label] = bayes_classify(consensus_matrix, conditional_prob_matrix, x, y)

    in_prob = 1
    out_prob = 1

    for i = 1:size(conditional_prob_matrix, 1)
        in_prob = in_prob*conditional_prob_matrix(i, 0)
    end
    
    for j = 1:size(conditional_prob_matrix, 1)
        out_prob = out_prob*conditional_prob_matrix(j, 1)
    end
    
    in_prob = in_prob*consensus_matrix(y, x)
    out_prob = out_prob*(1 - consensus_matrix(y, x))
    
    if in_prob > out_prob
        label = 1
    else
        label = 0
    end
    
end