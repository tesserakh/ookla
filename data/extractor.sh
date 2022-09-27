#!/usr/bin/env bash

## Using qgis_process to clip data using Shapefile boundary

FOVER="boundary/ID.shp"          # overlay shapefile
SERVICE=$(echo fixed mobile)     # list of category/service

for S in $SERVICE; do
  
  # create dir if not exist
  mkdir -p $S

  # file listing
  ZIPFILES=$(ls | grep -e "${S}_tiles.zip")
  
  # do the process for every single zip
  for F in $ZIPFILES; do

    # unzip shapefile
    unzip -o -d $S $F
    
    # get the information
    DATE=$(echo $F | cut -d "_" -f 1)

    # define input/output argument
    FOUT=$(echo "${S}/${S}_${DATE}.shp")
    FIN=$(echo "${S}/gps_${S}_tiles.shp")
    
    # run qgis processing
    echo "Cliping Shapefile from ${F}"
    qgis_process run native:clip -- INPUT=$FIN OVERLAY=$FOVER OUTPUT=$FOUT
  
  done

  # clean up unused extracted file
  for FILE in "${S}/gps_${S}_tiles.*"; do rm $FILE; done
done
