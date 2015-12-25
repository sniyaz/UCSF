function [entropy] = local_entropy(y, x, radius, image)
    %dd Bayes Dimension: Entropy around this pixel.

    entropy_matrix = entropyfilt(image);
    entropy = entropy_matrix(y, x);
end
