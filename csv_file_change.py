import pandas as pd
import csv

# Usage
input_file = 'Delhi metro.csv'
output_file = 'connected_stations.csv'

# First, save the data from the table to a CSV file
metro_data = []
metro = []
metro_stations = []



with open(input_file, "r") as f:
    reader = csv.reader(f)
    for row in reader:
        station = {"id": row[0], "Station Name": row[1], "Distance": row[2], "Metro Line": row[3]}
        metro_data.append(station)
        metro.append(row)

colors = {"Red line": 1, "Yellow line":1, "Blue line":1, "Blue line branch":1, "Green line branch":1, 
"Green line":1, "Rapid Metro":1, "Voilet line":1, "Magenta line":1, "Pink line":1, "Aqua line":1, "Gray line":1, "Orange line":1}

data = {}

for i in range(len(metro)):
    if i == 0:
        continue

    if metro[i][1] not in data:  # Ensure the key exists
        data[metro[i][1]] = []

    if metro[i][2] == 0:
        if i + 1 < len(metro) and metro[i][3] == metro[i+1][3]:
            data[metro[i][1]].append((metro[i+1][1], float(metro[i+1][2]) - float(metro[i][2])))
    else:
        if i - 1 >= 0 and metro[i][3] == metro[i-1][3]:
            data[metro[i][1]].append((metro[i-1][1], float(metro[i][2]) - float(metro[i-1][2])))
        if i + 1 < len(metro) and metro[i][3] == metro[i+1][3]:
            data[metro[i][1]].append((metro[i+1][1], float(metro[i+1][2]) - float(metro[i][2])))    



with open(output_file, mode='w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(["Station", "Connected Station", "Distance"])

    for station, connections in data.items():
        for connected_station, distance in connections:
            writer.writerow([station, connected_station, distance])

print(f"Data successfully written to {output_file}")