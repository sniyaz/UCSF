function [] = SVM_training()

close all
clear all

sizes_3d = dlmread('project_data/sizes_ds.txt');
num_centroids = 15;

orig_image = dlmread('project_data/im1_ds.txt');
orig_image = reshape(orig_image, sizes_3d);

training_data1 = dlmread('project_data/gc_labeled_ds.txt');
training_data1 = reshape(training_data1, sizes_3d);

training_data2 = dlmread('project_data/gc_labeled_ds.txt');
training_data2 = reshape(training_data2, sizes_3d);

ground_truth1 = logical(dlmread('project_data/seg1_ds.txt'));
ground_truth1 = reshape(ground_truth1, sizes_3d);

ground_truth2 = logical(dlmread('project_data/seg2_ds.txt'));
ground_truth2 = reshape(ground_truth2, sizes_3d);

labeled_cell = {training_data1, training_data2};
ground_truth_cell = {ground_truth1, ground_truth2};

%Let the training begin! We will train three SVMs: one for seperating
%border superpixels from non-border superpixels. Then two sub SVMs, one for
%classiying non-border pixels, and one to handle border pixels.

certain_super_voxel_data = [];
border_super_voxel_data = [];

%for those voxels that we determine as "certain", are they in or out? (For
%a later SVM)
certain_super_voxel_labels = [];

border_pixel_intensities = [];
border_pixel_labels = [];

for i = 1:1
    
    training_data = labeled_cell{i};
    ground_truth = ground_truth_cell{i};
    
    for l = 1:num_centroids+1
        points = find(training_data == l);
        truth_points = ground_truth(points);
        supposed_label = mode(truth_points, 1);
        intensities = double(orig_image(points));

        super_voxel_data = cluster_SVM_row_vector(l, training_data, orig_image);

        error = mean(truth_points ~= supposed_label);
        %Adjust to change how picky we are about what pixel is "certain" and
        %which are not...
        certain_flag = error < 0.05;

        if (certain_flag)
            certain_super_voxel_data = [certain_super_voxel_data; super_voxel_data];
            certain_super_voxel_labels = [certain_super_voxel_labels; supposed_label];
        else
            border_super_voxel_data = [border_super_voxel_data; super_voxel_data];
            border_pixel_intensities = [border_pixel_intensities; intensities];
            border_pixel_labels = [border_pixel_labels; truth_points];
        end

    end
end

%TO-DO

%Let's train up that first SVM! This will distinguish between uncertain and
%border super-voxels
certainty_training_table = [certain_super_voxel_data; border_super_voxel_data];
certainty_level_labels = vertcat(ones(size(certain_super_voxel_data, 1), 1), zeros(size(border_super_voxel_data, 1), 1));
certainty_svm = svmtrain(certainty_training_table, logical(certainty_level_labels));
%Now save this trained SVM for later!
save('project_data/trained_certainty_svm.mat','certainty_svm');

%Now to train up the second SVM! If a point gets classified by the first SVM
%as being a certain point (its not crossing a segmentation boundry), we can
%classify it with a label!
in_out_svm = svmtrain(certain_super_voxel_data, certain_super_voxel_labels);
save('project_data/in_out_svm.mat','in_out_svm');

%Finally, we train up the third SVM. This one handles the cases where the
%supervoxel is classified as being on the boundary of a segmentation.
%Without this, there is no way to come back from a case like this. This SVM
%classifies the PIXELS in these border super voxels individually.
border_case_svm = svmtrain(border_pixel_intensities, border_pixel_labels);
save('project_data/border_case_svm.mat','border_case_svm');


end