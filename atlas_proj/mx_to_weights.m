function [weights] = mx_to_weights(mx_input)
    mx_size = size(mx_input, 1);
    
    %This is to test the alpha factor
    alpha = 0.025;
    m_alpha = alpha*eye(mx_size);
    mx_input = mx_input + m_alpha;
    
    mx_inverse = inv(mx_input);
    ones_n = ones(mx_size, 1);
    weights = mx_inverse*ones_n;
    constant = (transpose(ones_n)*(mx_inverse*ones_n));
    weights = weights/constant;
    
    if weights(1, 1) < 0 || weights(2, 1) < 0
        
        bad_mx = mx_input
        bad_weights = weights
    end
    
    
end