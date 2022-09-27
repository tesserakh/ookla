# Internet Speed Data from Speedtest by Ookla

## Overview

This directory contain scripts for managing open data from Ookla:

- `downloader.sh`: download all available data in Shapefile (SHP) from Q1 2019 until 2022
- `extractor.sh`: clip the area using [polygon boundary](boundary) (Indonesia region)
- `cleaner.sh`: delete downloaded ZIP files when they are not in use anymore (after clipped)

Also the data result from preparation process:

- `nationwide_trend_quarterly`: national weighed average

## Requirement

- Install AWS CLI v2 <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>
- Install QGIS <https://www.qgis.org/en/site/forusers/download.html>

You can also install QGIS from Anconda <https://anaconda.org/conda-forge/qgis>

```
conda create --name qgis3
conda activate qgis3
conda install -c conda-forge qgis
```

When QGIS is available you can check if the `qgis_process` is working:

```
qgis_process help
```

**Using GDAL**

You can also use `ogr2ogr` ([GDAL](https://gdal.org/programs/ogr2ogr.html)) instead of QGIS native C++ for boundary clipping. If you are using GDAL, replace this part of code from `extractor.sh` and modify with your own `ogr2ogr` code:

```
qgis_process run native:clip -- INPUT=$FIN OVERLAY=$FOVER OUTPUT=$FOUT
```

For example, this code will do the same as the `native:clip` process (clip the data using a Shapefile overlay):

```
ogr2ogr -clipsrc $FOVER $FOUT $FIN
```

Where, the `$FOVER`, `$FOUT`, and `$FIN` are overlay.shp, output.shp, and input.shp.

