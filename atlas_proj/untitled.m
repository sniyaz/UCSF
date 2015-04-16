function [weights] = mx_to_weights(mx_input)
    
    mx_size = (mx_input, 1)
    mx_inverse = inv(mx_input)
    1n = ones(mx_size, 1)
    weights = mx_inverse*1n
    constant = (transpose(1n)*(mx_inverse*1n))
    weights = weights/constant
    
    
 