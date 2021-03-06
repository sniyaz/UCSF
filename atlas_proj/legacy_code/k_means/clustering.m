%An implementation of k-means clustering for pixels. 
%Who knows, it might just come in handy...
function [centroid_points] = clustering(data_cell, num_centroids)

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
                
                closest_centroid = find_closest_centroid(centroids, data_cell, j, i);
                new_centroid_points{closest_centroid} = vertcat(new_centroid_points{closest_centroid}, [j, i]);
                values_cell{closest_centroid} = vertcat(values_cell{closest_centroid}, data_cell{j, i});
            end
        end
        
        if isequal(new_centroid_points, centroid_points) % have we reached convergence?
            break;
        end
        
        centroid_points = new_centroid_points;
        
        %If one centroid has no points associated with it all, we
        %re-initialize it as a totally random point inside our dimensional
        %space. Otherwise, we do the typical K Means step of re-aligning
        %each centroid to the mean value of every point associated with it.
        for i = 1:num_centroids
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
function [init_centroids] = kmeans_plus(data_cell, num_centroids)

    %init_clusters is the thing that we actually returns out
    %containing an n dimensional cell of data points that will be used as
    %the ACTUAL cetroids in K Means. We build this list up as we go...
    init_centroids = cell(1, 1);

    % random point picked as start centroid!
    init_centroids{1} = random_start_point(data_cell, size(data_cell, 1), size(data_cell, 2))
    
    for i = 2:num_centroids
        distribution = [];
        for y = 1:size(data_cell, 1)
            for x = 1:size(data_cell, 2)
                
                closest_centroid = find_closest_centroid(init_centroids, data_cell, y, x);  
                prob_weight = squared_euc_dist(data_cell{y, x}, init_centroids{closest_centroid});
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
        init_centroids{i} = selected
    end
end


%Even in K Means++, you've gotta pick your first point randomly!
function [rand_centroid] = random_start_point(data_cell, y_dim, x_dim)

    y = randi(y_dim);
    x = randi(x_dim);
    rand_centroid = data_cell{y, x};
end


function [sq_dist] = squared_euc_dist(first_data, second_data)
    sq_dist = 0;
    for i = 1:size(first_data, 2)
        sq_dist = sq_dist + power(first_data(i) - second_data(i), 2);
    end
end


%Returns closest centroid to point given by x and y in the data_cell. 
function [closest_centroid_index] = find_closest_centroid(centroid_array, data_cell, y, x)
    smallest_dist = inf;
    closest_centroid_index = 0;
    num_centroids = size(centroid_array, 2);
    
    for c = 1:num_centroids 
        cur_distance = squared_euc_dist(data_cell{y, x}, centroid_array{c});
        if cur_distance < smallest_dist
            smallest_dist = cur_distance;
            closest_centroid_index = c;
        end
    end
end




    

