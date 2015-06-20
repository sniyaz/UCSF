% A method so that we pick our inital clusters by the K Means++ algorithm!
function [init_clusters] = kmeans_plus(data_cell, num_centroids, dimension, radius)

    selected_centroids = []

    % random point picked as start centroid!
    start_coords = random_start_point(data_cell, size(data_cell, 1), size(data_cell, 2))
    init_clusters = cell(1, num_centroids)
    init_clusters{1} = data_cell{start_coords(0) start_coords(1)}
    selected_centroids = vertcat(selected_centroids, start_coords)
    
    for i = 2:num_centroids
        
    
    
    
    
    
    
    

    

end

%Even in K Means++, you've gotta pick your first point randomly!
function [y, x] = random_start_point(data_cell, y_dim, x_dim)

    x = 0;
    y = 0;
    
    while true   
        y = randi(y_dim);
        x = randi(x_dim);
        if (size(data_cell{y, x}, 2) ~= 0)
            break
        end
    end
end

    function 

