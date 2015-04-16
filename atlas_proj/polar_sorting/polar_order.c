#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define pi 3.14159265358979323846

//this blows up when you enter coordinates as 1/2, but its fine for 0.5. I have no damn clue why.
double** polar_transform(double (*cartesians)[2], int num_points){

	double **polars = (double**) malloc(sizeof(double**)*num_points);	
	for (int i = 0; i < num_points; i++){
		polars[i] = (double*) malloc(sizeof(double)*2);
	}

	for (int i = 0; i < num_points; i++){
		
		double x_coord = cartesians[i][0];
		double y_coord = cartesians[i][1];

		
		double radius = sqrt(pow(x_coord, 2) + pow(y_coord, 2));
		
		//for some reason this doesn't explode when x is zero like the python version.
		//Perhaps math.h has error checking built in? Wow.
		double theta = atan(y_coord/x_coord); 

		if (theta < 0){
			theta += 2*pi;
		}

		if (x_coord < 0){
			theta += pi;
		}

		if (theta > 2*pi){
			theta -= 2*pi;
		}

		polars[i][0] = radius;
		polars[i][1] = theta;

		//printf("survived that\n");
	}

	
	for (int i = 0; i < num_points; i++){

		printf("%f ", polars[i][0]);
		printf("%f\n", polars[i][1]);
	}
	
	printf("\n");

	return polars;
	
}


void sort_points(double (*cartesians)[2], double **polars,	 int num_points){

	/*
	for (int i = 0; i < 4; i++){
		printf("%f ", polars[i][0]);
		printf("%f\n", polars[i][1]);
	}
	*/

	for (int i = 0; i < num_points; i++){
		int min_theta = i;
		for (int x = i; x < num_points; x++){
			if (polars[x][1] < polars[min_theta][1]){
				min_theta = x;
			}
		}
		double temp[2]; 
		temp[0] = polars[i][0];
		temp[1] = polars[i][1];

		//polars[i] = polars[min_theta];
		polars[i][0] = polars[min_theta][0];
		polars[i][1] = polars[min_theta][1];
		
		polars[min_theta][0] = temp[0];
		polars[min_theta][1] = temp[1];

		double temp2[2]; 
		temp2[0] = cartesians[i][0];
		temp2[1] = cartesians[i][1];

		//polars[i] = polars[min_theta];
		cartesians[i][0] = cartesians[min_theta][0];
		cartesians[i][1] = cartesians[min_theta][1];
		
		cartesians[min_theta][0] = temp2[0];
		cartesians[min_theta][1] = temp2[1];

	}
	
}

void polar_order(double (*cartesians)[2], int num_points){

	double **polars_new = polar_transform(cartesians, num_points);
	sort_points(cartesians, polars_new, num_points);

}

int main(){

	double test[6][2] = {{0.5, 0.5}, {5, -5}, {-1, 1}, {-1, -3}, {0, 5}, {4, 9}};

	polar_order(test, 6);
	
	printf("\n");
	
	for (int i = 0; i < 6; i++){
		printf("%f ", test[i][0]);
		printf("%f\n", test[i][1]);
	}
	
}