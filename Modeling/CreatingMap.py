# import gmplot, csv package
import gmplot
import csv
#latitude_list = []
#longitude_list = []
cords = []

for num in range(0, 1):
    with open('C:\\Users\\cross\\Desktop\\DM\\NewDataset\\dataset' + str(num) + '.csv') as csvfile:
        rdr = csv.DictReader(csvfile)
        for i in rdr:
            cords.append((float(i['lat']), float(i['lon'])))
            #latitude_list.append(float(i['lat']))
            #longitude_list.append(float(i['lon']))

#Place map
gmap3 = gmplot.GoogleMapPlotter(37.242837, 127.080046, 13)

#Set different latitude and longitude points
Charminar_top_attraction_lats, Charminar_top_attraction_lons = zip(*cords)

# Plot method Draw a line in between given coordinates
gmap3.plot(Charminar_top_attraction_lats, Charminar_top_attraction_lons, 'cornflowerblue', edge_width = 2)

# Scatter map
gmap3.scatter( Charminar_top_attraction_lats, Charminar_top_attraction_lons, 'cornflowerblue',size = 1, marker = False )

#gmap.apikey = "Your_API_KEY"
gmap3.apikey = "AIzaSyCfUGC2hJI1clxvAleUCJugmh-3rpO8gHI"
# Location where you want to save your file.
gmap3.draw( "C:\\Users\\cross\\Desktop\\DM\\Modeling\\basicMap.html" )