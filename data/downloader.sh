#!/usr/bin/env bash

FORMAT=shapefiles                  # shapefiles|parquet
YEAR=$(echo 2019 2020 2021 2022)   # 2019,2020,2021,2022
QUAR=$(echo 1 2 3 4)               # 1,2,3,4
TYPE=$(echo fixed mobile)

for T in $TYPE; do
  for Y in $YEAR; do
    for Q in $QUAR; do
      
      # first month of quarters where the data being published
      M=$(echo $(printf "%02d" $(expr $(expr $Q - 1) \* 3 + 1)))
      
      # name of file zip to be checked
      FNAME=$(echo "${Y}-${M}-01_performance_${T}_tiles.zip")
      
      # check if file zip have downloaded
      if [ ! -f $FNAME ]; then
        
        # download from aws s3 using aws-cli
        aws s3 cp s3://ookla-open-data/${FORMAT}/performance/type=${T}/year=${Y}/quarter=${Q}/ ./ \
          --recursive \
          --no-sign-request
      else
        
        # skip download if the data already exist
        echo "${FNAME} is already exist!"
      fi
    done
  done
done
