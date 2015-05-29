function [] = bayes_test()

    target_image = imread('test_data/knees/knee_1.jpg');
    consensus_matrix = dlmread('test_consensus_mat.txt');
    radius = 5
    
    lower_x = radius + 1;
    upper_x = size(target_image, 2) - radius;

    lower_y = radius + 1;
    upper_y = size(target_image, 1) - radius;

    for i = lower_x:upper_x
        for j = lower_y:upper_y
            consensus_matrix(j, i) = bayes_classify(target_image, [], i, j, 5);
        end
    end
    
    target_image(~consensus_matrix) = 0;
    imshow(target_image)

end
