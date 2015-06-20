%An implementation of k-means clustering for pixels. 
%Who knows, it might just come in handy...
function [centroid_points] = clustering(data_cell, dimension, num_centroids)

    centroids = cell(1, num_centroids); %
    centroid_points = cell(1, num_centroids); %

    for i = 1:num_centroids
        centroids{i}(1) = randi(367);
        centroids{i}(2) = randi(367);
        centroids{i}(3) = randi(256)*10000; %single pixel value
        
        %\centroid{i}(1) = randi(30) %which sector we belong to
        %centroid{i}(2) = randi(256) %single pixel value
        %centroid{i}(3) = randi(5000) %neighbor intensity sum
    end
  
    while true
        new_centroid_points = cell(1, num_centroids);
        values_cell = cell(1, num_centroids);
        
        for i = 1:size(data_cell, 2)
            for j = 1:size(data_cell, 1)
                if size(data_cell{j, i}, 2) == 0
                    continue;
                end
                
                closest_centroid = 0;
                smallest_distance = inf;
                for c = 1:num_centroids;
                    dist = 0;
                    for d = 1:dimension
                        current_pixel = data_cell{j, i};
                        dist = dist + power((current_pixel(d) - centroids{c}(d)), 2);      
                    end
    
                    dist = sqrt(double(dist));
      
                    if dist < smallest_distance
                        closest_centroid = c;
                        smallest_distance = dist;
                    end
                end
                new_centroid_points{closest_centroid} = vertcat(new_centroid_points{closest_centroid}, [j, i]);
                values_cell{closest_centroid} = vertcat(values_cell{closest_centroid}, data_cell{j, i});
            end
        end
        
        if isequal(new_centroid_points, centroid_points) % have we reached convergence?
            break;
        end
        
        centroid_points = new_centroid_points;
        
        for i = num_centroids:-1:1
            if size(values_cell{i}, 1) == 0
                centroids{i}(1) = randi(367);
                centroids{i}(2) = randi(367);
                centroids{i}(3) = randi(256)*10000;
            elseif size(values_cell{i}, 1) == 1
                centroids{i} = values_cell{i};
            else
                centroids{i} = sum(values_cell{i})/(size(values_cell{i}, 1));
            end
            
        end          
        
    end
    
    dlmwrite('k_means_test.txt', centroid_points{1})
    
    
end


% A method so that we pick our inital clusters by the K Means++ algorithm!
function [init_clusters] = kmeans_plus(data_cell, num_centroids, dimension, radius)

    selected_centroids = []

    % random point picked as start centroid!
    start_coords = random_start_point(data_cell, size(data_cell, 1), size(data_cell, 2))
    init_clusters = cell(1, num_centroids)
    init_clusters{1} = data_cell{start_coords(0) start_coords(1)}
    selected_centroids = vertcat(selected_centroids, start_coords)
    
    for i = 2:num_centroids
        distribution = []
        for y = 1:size(data_cell, 1)
            for x = 1:size(data_cell, 2)
                
                smallest_dist = inf
                closest_centroid = 0
                for c = 1:size(selected_centroids, 2)
                    cur_distance = squared_euc_distance(y, x, selected_centroids{c}(1), selected_centroids{c}(2)
                    if cur_dista
    
    end
    
        
  
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

function [sq_dist] = squared_euc_dist(y1, x1, y2, x2)
    sq_dist = power(y1 - y2, 2) + power(x1 - x2, 2)
end



    

