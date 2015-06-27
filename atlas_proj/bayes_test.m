function [] = bayes_test()

    %Initialization for testing purposes. Once the program becomes more final, this will be fully integrated
    %into the overall structure. That said, it shouldn't be all that difficult.
    target_image = imread('test_data/brains/brain_1.jpg');
    consensus_matrix = dlmread('test_consensus_mat.txt');
    output_segmentation = consensus_matrix
    radius = 5;
    
    %Making sure we're in the bounding bx given by the radius that certain
    %helper functions need (ie using SSD to provide one dimension used by
    %the Bayesian classification).
    lower_x = radius + 1;
    upper_x = size(target_image, 2) - radius;

    lower_y = radius + 1;
    upper_y = size(target_image, 1) - radius;

    for i = lower_x:upper_x
        for j = lower_y:upper_y
            %If the a priori probability is zero (as given by the consensus
            %matrix), then there is nohope for the  a posteriori
            %probabiity. This is actually the vast majority of points, so
            %doing this saves a LOT of computation time.
            if (consensus_matrix(j, i) == 0)
                output_segmentation(j, i) = 0;
            else
                %Otherwise, let's do some Bayesian classifying!
                output_segmentation(j, i) = bayes_classify(target_image, consensus_matrix, i, j, 5);
        end
    end
    
    target_image(~consensus_matrix) = 0;
    imshow(target_image)

end
