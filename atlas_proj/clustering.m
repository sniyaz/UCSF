%An implementation of k-means clustering for pixels. 
%Who knows, it might just come in handy...
function [centroid_points] = clustering(data_cell, dimension, radius, num_centroids)

    centroids = cell(1, num_centroids) %
    centroid_points = cell(1, num_centroids) %

    for i = 1:num_centroids
        centroids{i}(1) = randi(367)
        centroids{i}(2) = randi(367)
        centroid{i}(3) = randi(256) %single pixel value
        
        %\centroid{i}(1) = randi(30) %which sector we belong to
        %centroid{i}(2) = randi(256) %single pixel value
        %centroid{i}(3) = randi(5000) %neighbor intensity sum
    end
    
    lower_x = radius + 1;
    upper_x = size(data_cell, 2) - radius;

    lower_y = radius + 1;
    upper_y = size(data_cell, 1) - radius;
        
    while true
        new_centroid_points = cell(1, num_centroids)
        values_cell = cell(1, num_centroids)
        
        for i = lower_x:upper_x
            for j = lower_y:upper_y
                if size(data_cell{j, i}, 2) == 0
                    continue
                end
                
                closest_centroid = 0
                smallest_distance = inf
                for c = 1:num_centroids
                    dist = 0
                    for d = 1:dimension
                        current_pixel = data_cell{j, i}
                        dist = dist + power((current_pixel(d) - centroids{c}(d)), 2)      
                    end
    
                    dist = sqrt(dist)
      
                    if dist < smallest_distance
                        closest_centroid = c
                        smallest_distance = dist
                    end
                end
                new_centroid_points{closest_centroid} = vertcat(new_centroid_points{closest_centroid}, [j, i])
                values_cell{closest_centroid} = vertcat(values_cell{closest_centroid}, data_cell{j, i})
            end
        end
        
        if isequal(new_centroid_points, centroid_points) % have we reached convergence?
            break
        end
        
        centroid_points = new_centroid_points
        
        for i = 1:num_centroids
            if size(values_cell{i}, 1) == 0
                centroids{i} = [0, 0]
            elseif size(values_cell{i}, 1) == 1
                centroids{i} = values_cell{i}
            else
                centroids{i} = sum(values_cell{i})/(size(values_cell{i}, 1))
            end
            
        end
    end
    
    dlmwrite('k_means_test.txt', centroid_points{1})
    
    
end
