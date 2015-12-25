function [] = weight_finder()

    results = [];

    for num_centroids = 1:30
        
        grad_weight = 1;
        
        for grad_weight_pow = 1:7
            
            kmeans_init(num_centroids, grad_weight);
            JI = cluster_eval(num_centroids);
            results = vertcat(results, [num_centroids, grad_weight, JI]);
            
            grad_weight = grad_weight*10
        
        end
    
    
    
    end
    
    dlmwrite('project_data/weight_search.txt', results);
    
end