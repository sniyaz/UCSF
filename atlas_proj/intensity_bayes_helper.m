function [sum] = intensity(y, x, radius, image)
    
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
