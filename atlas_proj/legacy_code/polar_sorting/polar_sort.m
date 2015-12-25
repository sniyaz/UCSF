function [final_out] = polar_sort(y)

adjacency_thetas = polar_transform(y)

final_out = sortrows(adjacency_thetas, 3)
final_out(:,3) = [] 

end

function [out_list] = polar_transform(y)

thetas_list = []

for i = 1:length(y)
    x_coord = y(i,1)
    y_coord = y(i,2)
    
    theta = atan(y_coord/x_coord)
    
    if theta < 0 
        theta = theta + 2*pi 
    end
    
    if x_coord<0 
        theta = theta + pi
    end
    
    if theta>2*pi 
        theta = theta-2*pi
    end
    
    thetas_list = cat(1, thetas_list, [theta;]) 
end

out_list = cat(2, y, thetas_list)
end



 
    
    
    
        
    
    
    
    
    
        
        
        
        
    
 







