import csv, sys, getopt, re
# Input the file name from stdin.
fname = sys.argv[1]
data = csv.reader((line.replace('\0','') for line in open(fname)), delimiter = ',')
# Open the output file to be written.
f = open(fname + '.kml', 'w')

# Write the kml format headers.
f.write("<?xml version='1.0' encoding='UTF-8'?>\n")
f.write("<kml xmlns='http://earth.google.com/kml/2.1'>\n")
f.write("<Document>\n")
f.write("   <name>" + fname + '.kml' +"</name>\n")
# Write entries for each data point
for row in data:
	if any(row[9] in (None, "") for key in row):
		print "Invalid GPS data!"
	else:
		f.write("   <Placemark>\n")
		f.write("       <name>" + str(row[3]) + "</name>\n")
		f.write("       <description>Utilization " + str(row[7]) + " at " + str(row[0]) + "</description>\n")
		f.write("       <Point>\n")
		f.write("           <coordinates>" + str(row[10]) + "," + str(row[9]) + "," + str(row[11]) + "</coordinates>\n")
		f.write("       </Point>\n")
		f.write("   </Placemark>\n")
# Write the kml format tail.
f.write("</Document>\n")
f.write("</kml>\n")
f.close()
print "File Created"
