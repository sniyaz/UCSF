function [] = cluster_algo(radius)

    target = imread('test_data/brains/brain_1.jpg');
    binary_seg = dlmread('test_binary_seg.txt');
    
    im_cell = cell(size(target, 1), size(target, 2));
    
    lower_x = radius + 1;
    upper_x = size(im_cell, 2) - radius;

    lower_y = radius + 1;
    upper_y = size(im_cell, 1) - radius;
    
    for i = lower_x:upper_x
        for j = lower_y:upper_y
            im_cell{j, i} = [j, i, int32(target(j, i))];
        end
    end
    
    points = clustering(im_cell, 3, 20);
    
    for i = 1:size(points, 2)
        touched = 0;
        for j = 1:size(points{i}, 1)
            if binary_seg(points{i}(j, 1), points{i}(j, 2)) == 1
                touched = 1;
                break
            end
        end
        if touched == 1
            for p = 1:size(points{i}, 1)
                    binary_seg(points{i}(p, 1), points{i}(p, 2)) = 1;
            end
        end
    end
    
    target(~binary_seg) = 0;
    imshow(target)                
               
end

