import math

#assume that we pass in a list of lists, where each sublist is an x,y coordinate pair.
def polar_transform(cartesians):

    polars = []

    for point in cartesians:
        x_coord = point[0]
        y_coord = point[1]

        radius = math.sqrt(math.pow(x_coord, 2) + math.pow(y_coord, 2))
        try:
            theta = math.atan(y_coord/x_coord)
        except ZeroDivisionError:
            if (y_coord < 0):
                theta = 3/2*math.pi
            else:
                theta = 1/2*math.pi

        if (theta < 0):
            theta = theta + 2*math.pi

        if (x_coord < 0):
            theta = theta + math.pi

        polars.append([radius, theta])

    return polars

#I could have used a built in python sorting method, but I wanted to do this manually so we can eaily transfer this 
#to MATLAB or another language that isn't as nice as Python. Each point in the polar set is used to sort its corresponding point 
#in the cartesian set

#Note that this is a standard selection sort. In the future, I may implement a faster sort such as merge-sort to improve run-time
#on large data sets.
def sort_points(cartesians, polars):

    for i in range(0, len(polars)):
        min_theta = i
        for x in range(i, len(cartesians)):
            if (polars[x][1] < polars[min_theta][1]):
                min_theta = x
        polars[i], polars[min_theta] = polars[min_theta], polars[i]
        cartesians[i], cartesians[min_theta] = cartesians[min_theta], cartesians[i]

    return cartesians
            
#helpers function are used to ease debugging
def polar_order(cartesians):

    polars = polar_transform(cartesians)
    sort_points(cartesians, polars)

    return cartesians


#testing function
def test():

    cartesians = [[0, 1], [1, 0], [3, 4], [-3, -4], [5, -2]]
    print(polar_order(cartesians))

test()
