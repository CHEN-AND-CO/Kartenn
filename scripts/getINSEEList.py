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
        if "ref:INSEE" in feature["properties"]["tags"]:
            inseeList.append(feature["properties"]["tags"]["ref:INSEE"])
    
    with open(filePath+".list", 'w') as jsonOutFile:
        json.dump(inseeList, jsonOutFile)
