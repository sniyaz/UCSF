function [sum] = neighbor_intensity(y, x, radius, image)
%Adds Bayes Dimension: sum of intensity arund pixel of interest.
    
%manual over-ride. We don't care what the main program radius is, so long
%as it is greater than 2. We use the sum of a 3x3 area including the pixel
%of interest.
radius = 2;    
sum = int64(0);
    for m = x-radius:x+radius
        for n = y-radius:y+radius
            sum = sum + int64(image(n, m));
        end
    end
    
    sum = idivide(sum, int64(10), 'round');
    
    if (sum == 0)
        sum = 1;
    end
  
end
