classdef UCSFUnitTests < matlab.unittest.TestCase  
    methods (Test)
        
        function mxToWeightTest(testCase)
            mx1 = [0.5,0.1;0.1,0.2]
            actual1 = mx_to_weights(mx1)
            expected1 = [0.2115;0.7885]
            testCase.verifyEqual(actual1, expected1, 'AbsTol', 0.0001)
            
            mx2 = [0.5,0.1,0.5;0.1,0.2,0.1;0.5,0.1,0.5]
            actual2 = mx_to_weights(mx2)
            expected2 = [0.1068; 0.7864; 0.1068]
            testCase.verifyEqual(actual2, expected2, 'AbsTol', 0.0001)
        end
        
        function mxCreateTest(testCase)
            targetImage = [2,5,7,5,5; 13,5,2,9,1; 2,3,4,8,9; 3,4,8,9,10; 11,3,6,5,1;]
            testImage1 = [1,1,1,1,1; 1,1,1,1,1; 8,8,14,1,1; 7,5,7,1,1; 3,2,1,1,1]
            testImage2 = [1,1,1,1,1; 1,1,1,1,1; 9,4,3,1,1; 8,5,7,1,1; 9,1,8,1,1]
            
            image_cell = cell(1,2)
            image_cell{1} = testImage1
            image_cell{2} = testImage2
            
            actual = mx_create(targetImage, image_cell, 4, 2, 1)
            expected = [1,0.3977; 0.3977,0.3345]
            testCase.verifyEqual(actual, expected, 'AbsTol', 0.0001)     
        end
        
        
    end
     
end
