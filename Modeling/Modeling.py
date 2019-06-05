import folium
import pandas as pd, numpy as np, matplotlib.pyplot as plt
import random
from numpy import sin,cos,arctan2,sqrt,pi
from shapely.geometry import MultiPoint
from sklearn.cluster import DBSCAN
from geopy.distance import great_circle

####################################
## functions below are taken (and modified a bit) from blog post published by Geoff Boeing
## http://geoffboeing.com/2014/08/clustering-to-reduce-spatial-data-set-size/
####################################

def getDbScanClustersCenters(df, epsInKm, minObjects):
    clusters = getDbScanClusters(df, epsInKm, minObjects)
    return getClustersCenters(clusters)
    
def getDbScanClusters(df, epsInKm, minObjects):
    coords = df.as_matrix()
    kms_per_radian = 6371.0088
    epsilon = epsInKm / kms_per_radian
    db = DBSCAN(eps=epsilon, min_samples=minObjects, algorithm='ball_tree', metric='haversine').fit(np.radians(coords))
    cluster_labels = db.labels_
    print('Number of clusters: {}'.format(len(set(cluster_labels))))
    return pd.Series([coords[cluster_labels == n] for n in range(len(set(cluster_labels)) - 1)])

def get_centermost_point(cluster):
    centroid = (MultiPoint(cluster).centroid.x, MultiPoint(cluster).centroid.y)
    centermost_point = min(cluster, key=lambda point: great_circle(point, centroid).m)
    return centermost_point

def getClustersCenters(clusters):
    centermost_points = clusters.map(get_centermost_point)
    lats, lons = zip(*centermost_points)
    return pd.DataFrame({'lat':lats, 'lon':lons}).values.tolist()

####################################

def drawPointsOnMap(superMap, points, color, radiusSize):
    print('Drawing {} points on map'.format(len(points)))
    for point in points:
        folium.CircleMarker(point, radius = radiusSize, fill_color = color, color = color).add_to(superMap)
        
def getDistanceBetweenPoints(point1, point2):
        lon1 = point1[1] * pi / 180.0
        lon2 = point2[1] * pi / 180.0
        lat1 = point1[0] * pi / 180.0
        lat2 = point2[0] * pi / 180.0
        
        # haversine formula #### Same, but atan2 named arctan2 in numpy
        dlon = lon2 - lon1
        dlat = lat2 - lat1
        a = (sin(dlat/2))**2 + cos(lat1) * cos(lat2) * (sin(dlon/2.0))**2
        c = 2.0 * arctan2(sqrt(a), sqrt(1.0-a))
        km = 6371.0 * c
        return km
    
def getEndPoint(points):
    pointsForFindingLineEnd = list(points)
    currentPoint = random.choice(pointsForFindingLineEnd)

    pointsForFindingLineEnd.remove(currentPoint)

    while(len(pointsForFindingLineEnd) > 0):
        nextPoint = None
        distanceToNextPoint = float("inf")
        for point in pointsForFindingLineEnd:
            distance = getDistanceBetweenPoints(point, currentPoint)
            if (distance < distanceToNextPoint):
                nextPoint = point
                distanceToNextPoint= distance
    
        pointsForFindingLineEnd.remove(nextPoint)
        currentPoint = nextPoint
    
    return currentPoint

def getLineFromPoints(points, startingPoint):
    linePoints = list(points)
    currentPoint = startingPoint
    line = []
    while(len(linePoints) > 0):
        nextPoint = None
        distanceToNextPoint = float("inf")
        for point in linePoints:
            distance = getDistanceBetweenPoints(point,currentPoint)
            if (distance < distanceToNextPoint):
                nextPoint = point
                distanceToNextPoint= distance

        linePoints.remove(nextPoint)
        currentPoint = nextPoint
        line.append(currentPoint)

    return line

for i in range(1, 6):
    df = pd.read_csv('C:\\Users\\cross\\Desktop\\DM\\NewDatasetB\\dataset' + str(i) + '.csv', index_col = False, header=0)
    superMap = folium.Map(location=[37.242837, 127.080046], zoom_start=20, tiles='OpenStreetMap')
    #drawPointsOnMap(superMap, df.values, '#3186cc', 0.1)

    clustersCenters = getDbScanClustersCenters(df, 0.003, 5)
    #drawPointsOnMap(superMap, clustersCenters, '#ff0000', 1)

    endPoint = getEndPoint(clustersCenters)
    drawPointsOnMap(superMap, [endPoint], '#3186cc', 3)
    line = getLineFromPoints(clustersCenters, endPoint)

    superMap.add_child(folium.PolyLine(locations = line, weight = 5, color="#d63b3b", ))
    
    if(i == 1):
        superMap.save('C:\\Users\\cross\\Desktop\\DM\\ClusteringResults\\MondayB_trajectory.html')
    elif(i == 2): 
        superMap.save('C:\\Users\\cross\\Desktop\\DM\\ClusteringResults\\TuesdayB_trajectory.html')
    elif(i == 3):
        superMap.save('C:\\Users\\cross\\Desktop\\DM\\ClusteringResults\\WendsdayB_trajectory.html')
    elif(i == 4):
        superMap.save('C:\\Users\\cross\\Desktop\\DM\\ClusteringResults\\ThursdayB_trajectory.html')
    elif(i == 5):
        superMap.save('C:\\Users\\cross\\Desktop\\DM\\ClusteringResults\\FridayB_trajectory.html')
