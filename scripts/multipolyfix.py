#! /usr/bin/env python3
# coding: utf-8

import json
from sys import argv

if(len(argv) < 2):
    print("Error : You need to provide file path !")
    exit()

filePath = argv[1]
print("File path is \""+filePath+"\"")

with open(filePath, 'r') as jsonFile:
    data = json.load(jsonFile)

    merged = dict()
    for feature in data["features"]:
        geom = feature["geometry"]

        if(feature["id"] in merged):
            mergedGeom = merged[feature["id"]]["geometry"]

            if(mergedGeom["type"] == "Polygon"):
                mergedGeom["type"] = "MultiPolygon"
                mergedGeom["coordinates"] = [mergedGeom["coordinates"]]
            
            mergedGeom["coordinates"].append(geom["coordinates"])

            merged[feature["id"]]["geometry"] = mergedGeom
        else:
            merged[feature["id"]] = feature

    data["features"] = []
    for feature in merged.values():
        del feature["id"]
        data["features"].append(feature)

    data["crs"] = {"type" : "name", "properties" : {"name" : "EPSG:3857"}}

    with open("fix."+filePath, 'w') as jsonOutFile:
        json.dump(data, jsonOutFile)
