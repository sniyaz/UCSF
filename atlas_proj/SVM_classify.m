function [] = SVM_classify()

clear all
close all

sizes_3d = dlmread('project_data/sizes_ds.txt');

target_cube = dlmread('project_data/static/target_ds.txt');
target_cube = reshape(target_cube, sizes_3d);

labeled_target = dlmread('project_data/target_cluster.txt');
labeled_target = reshape(labeled_target, sizes_3d);

final_mask = logical(zeros(size(target_cube)));

num_centroids = 15;

certainty_SVM_input_data = [];

for l = 1:num_centroids+1
    
    super_voxel_data = cluster_SVM_row_vector(l, labeled_target, target_cube);
    certainty_SVM_input_data = [certainty_SVM_input_data; super_voxel_data];
    
end

%load up our first (certainty) SVM!
load('project_data/trained_certainty_svm.mat','certainty_svm');
certainty_classification = svmclassify(certainty_svm, certainty_SVM_input_data);

%Now that we have certainty decisions, we can process the classified super
%voxels accordingly. We start with the certain (non boder) voxels, and
%classify them as in or out.
certain_labels = transpose(find(certainty_classification == 1));
in_out_svm_input_data = certainty_SVM_input_data(certain_labels, :);
load('project_data/in_out_svm.mat','in_out_svm');
in_out_classification = svmclassify(in_out_svm, in_out_svm_input_data);

for i = 1:size(certain_labels, 2)
    
    current_label = certain_labels(i);
    classified_label = in_out_classification(i,:);
    final_mask(find(labeled_target == current_label)) = classified_label;

end

%Finally, we classify individually the pixels that landed in "border case"
%super voxels...
border_labels = transpose(find(certainty_classification == 0));
border_points = [];
border_intensities = [];
for i = 1:size(border_labels, 2)
    
    current_label = border_labels(i);
    label_points = find(labeled_target == current_label);
    label_intensities = target_cube(label_points);
    border_intensities = [border_intensities; label_intensities];
    border_points = [border_points; label_points];

end

load('project_data/border_case_svm.mat','border_case_svm');
border_case_classification = svmclassify(border_case_svm, border_intensities);
final_mask(border_points) = border_case_classification;ls


test_slice = target_cube(:,:,75);
test_seg = final_mask(:,:,75);
test_slice(~test_seg) = 0;
imshow(test_slice, [])

dlmwrite('project_data/SVM_mask.txt', final_mask);

end