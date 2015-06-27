%An implementation of k-means clustering for pixels. 
%Who knows, it might just come in handy...
function [centroid_points] = clustering(data_cell, dimension, num_centroids)

    centroids = kmeans_plus(data_cell, num_centroids); %
    centroid_points = cell(1, num_centroids); %

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
                centroids{i}(3) = randi(256);
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
function [init_clusters] = kmeans_plus(data_cell, num_centroids)

    %init_clusters is the thing that we actually returns out
    %containing an n dimensional cell of data points that will be used as
    %the ACTUAL cetroids in K Means. We build this list up as we go...
    init_clusters = cell(1, 1)

    % random point picked as start centroid!
    start_coords = random_start_point(data_cell, size(data_cell, 1), size(data_cell, 2)) 
    init_clusters{1} = data_cell{start_coords(1), start_coords(2)}
    
    for i = 2:num_centroids
        distribution = [];
        for y = 1:size(data_cell, 1)
            for x = 1:size(data_cell, 2)
                
                smallest_dist = inf;
                closest_centroid = 0;
                for c = 1:(i-1)
                    
                    if size(init_clusters{c}, 2) == 0
                        a = 5
                    end
                    
                    cur_distance = squared_euc_dist(data_cell{y, x}, init_clusters{c});
                    if cur_distance < smallest_dist
                        smallest_dist = cur_distance;
                        closest_centroid = c;
                    end
                end
                
                prob_weight = squared_euc_dist(data_cell{y, x}, init_clusters{closest_centroid});
                %prob_weight = idivide(prob_weight, 10, 'floor');
                
                %.....TBD...proportional to its sq distance from the
                %nearest centroid, therefor weighting it by that factor in
                %the overall distribution...
                
                aug_point = horzcat([prob_weight], data_cell{y, x});
                distribution = vertcat(distribution, aug_point);     
            end
        end
        
        %Add along the columns of the dist matrix
        total = sum(distribution);
        %only the first column had the weights
        total = total(1);
        %random point among those weights
        rand_point = randi(total);
        
        index = 1;
        sum_passed = int64(0);

        
        while sum_passed + int64(distribution(index, 1)) < rand_point
            sum_passed = sum_passed + int64(distribution(index, 1));
            index = index + 1;
            if index > size(distribution, 1)
                a = 3
            end
        end
        
        selected = distribution(index, :);
        %Have to remove the weight that was appended to the centroid point.
        selected(1) = [];
        init_clusters{i} = selected
    end
    
end



%Even in K Means++, you've gotta pick your first point randomly!
function [points] = random_start_point(data_cell, y_dim, x_dim)

    x = 0;
    y = 0;
    
    while true   
        y = randi(y_dim);
        x = randi(x_dim);
        if (size(data_cell{y, x}, 2) ~= 0)
            break
        end
    end
    
    points = [y, x]
end



function [sq_dist] = squared_euc_dist(first_data, second_data)
    sq_dist = 0;
    for i = 1:size(first_data, 2)
        sq_dist = sq_dist + power(first_data(i) - second_data(i), 2);
    end
end



    

