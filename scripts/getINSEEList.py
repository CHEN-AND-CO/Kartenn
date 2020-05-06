import json
from sys import argv

if(len(argv) < 2):
    print("Error : You need to provide file path !")
    exit()

filePath = argv[1]
print("File path is \""+filePath+"\"")

with open(filePath, 'r') as jsonFile:
    data = json.load(jsonFile)

    inseeList = []
    for feature in data["features"]:
        print(feature["properties"]["tags"]["ref:INSEE"])
        inseeList.append(feature["properties"]["tags"]["ref:INSEE"])
    
    with open("fix."+filePath, 'w') as jsonOutFile:
        json.dump(inseeList, jsonOutFile)