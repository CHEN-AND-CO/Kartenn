# Kartenn
Deploy Kartenn Back and Front

## Usage

### Générer un geojson
``` ./generateGeoJSON <db> <user> <outputFile>```
Il sortira 4 Fichiers : 
- Le GeoJSON brut, le plus lourd (meilleure qualitée)
- Le GeoJSON Simplifié
- Le GeoJSON Simplifié avec les polygones d'une même ville rassemblés dans un multipolygône
- Le GeoJSON Simplifié avec les polygones d'une même ville rassemblés dans un multipolygône et la projection en EPSG:4326