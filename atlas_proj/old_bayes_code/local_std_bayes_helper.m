function [local_std] = local_std(y, x, radius, image)
%Add Bayes Dimesion: STD of pixels around this one.

%An over-ride of the radius given to reduce uneeded computation.
radius = 2
intensities = []
for m = x-radius:x+radius
    for n = y-radius:y+radius
        intensities = vertcat(intensities, [int64(image(n, m))]);
    end
end

local_std = std(intensities);
end
