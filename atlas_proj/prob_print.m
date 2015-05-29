function [] = prob_print()

distribution = dlmread('bayes_data/intensity_bayes_helper_IN_data.txt')
out_matrix = []

holder = []
for i = 1:size(distribution, 2)
    if (distribution(i) ~= 0)
        holder(1) = i;
        holder(2) = distribution(i);
        out_matrix = vertcat(out_matrix, holder);
    end
end

dlmwrite('dist_out.txt', out_matrix)
    
   
end


