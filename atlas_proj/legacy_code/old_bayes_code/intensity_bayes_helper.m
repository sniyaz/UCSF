function [value] = intensity(y, x, radius, image)
%Adds Bayes Dimension: intensity of pixel of interest. 
value = int64(image(y, x));
end
