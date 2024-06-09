#!/bin/sh

# create new location from raster map (file must contain projection metadata):
# grass -c myraster.tif /home/user/grassdata/mynewlocation
grass
#cd /Users/polinalemenkova/grassdata
#grass -c LC09_L2SP_179073_20220419_20230421_02_T1_SR_B1.tif /Users/polinalemenkova/grassdata/ValVenegia

# ----IMPORT AND PREPROCESSING-------------------------->

g.list rast
# import raster
r.import input=/Users/polinalemenkova/grassdata/ValVenegia/Aspect_VV.TIF output=Aspect_VV extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/ValVenegia/Elevation_VV.TIF output=Elevation_VV extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/ValVenegia/Slope_VV.TIF output=Slope_VV extent=region resolution=region
g.list rast
# import vector
v.in.ogr input=/Users/polinalemenkova/grassdata/ValVenegia/ValVenegia.shp output=ValVenegia -o
g.list vect
# Convert vector to raster
v.to.rast input=ValVenegia output=ValVenegia_border use=cat type=area

#
# --------------- CHECK CATEGORIES ------------------->
g.list rast
r.info Slope_VV
r.describe Slope_VV
r.info Aspect_VV
r.describe Aspect_VV
r.info Elevation_VV
r.describe Elevation_VV
#
# --------------- R2V for Elevation_VV ------------------->
g.region raster=Elevation_VV -p
# random sampling of points (note that r.random also writes vector points)
r.random -s Elevation_VV raster_output=Elevation_VV_points n=1000
r.to.vect input=Elevation_VV_points output=Elevation_VV_points type=point
# univariate statistics of sample points
v.univar Elevation_VV_points column=value type=point
# compare to univariate statistics on original full raster map
r.univar Elevation_VV
#
# --------------- R2V for Elevation_VV ------------------->
g.region raster=Elevation_VV -p
# random sampling of points (note that r.random also writes vector points)
r.random -s Elevation_VV raster_output=Elevation_VV_points n=170
r.to.vect input=Elevation_VV_points output=Elevation_VV_points type=point
# univariate statistics of sample points
v.univar Elevation_VV_points column=value type=point
# compare to univariate statistics on original full raster map
r.univar Elevation_VV

g.list rast
# Aspect_VV
# Elevation_VV
# Elevation_VV_points
# Slope_VV
#
# --------------- R2V for Slope_VV ------------------->
g.region raster=Slope_VV -p
# random sampling of points (note that r.random also writes vector points)
r.random -s Slope_VV raster_output=Slope_VV_points n=1000
r.to.vect input=Slope_VV_points output=Slope_VV_points type=point
# univariate statistics of sample points
v.univar Slope_VV_points column=value type=point
# compare to univariate statistics on original full raster map
r.univar Slope_VV
#
g.list rast
# Aspect_VV
# Elevation_VV
# Elevation_VV_points
# Slope_VV
g.list vect
# Elevation_VV_points
#
# --------------- R2V for Aspect_VV ------------------->
g.region raster=Aspect_VV -p
# random sampling of points (note that r.random also writes vector points)
r.random -s Aspect_VV raster_output=Aspect_VV_points n=1000
r.to.vect input=Aspect_VV_points output=Aspect_VV_points type=point
# univariate statistics of sample points
v.univar Aspect_VV_points column=value type=point
# compare to univariate statistics on original full raster map
r.univar Slope_VV
#
g.list rast
# Aspect_VV
# Elevation_VV
# Elevation_VV_points
# Slope_VV
g.list vect
# Elevation_VV_points

# # --------------- Check generated vectors ------------------->
g.list vect
# GRASS GIS now created 3 new vector files with our points in ValVenegia:
# Aspect_VV_points
# Elevation_VV_points
# Slope_VV_points

# --------------- Export point files to SHP ESRI format ------------------->
# Export 3D points (XYZ) from GRASS GIS vector map to Shapefile format
v.out.ogr Aspect_VV_points type=point format=ESRI_Shapefile output=Aspect_VV_points.shp lco="SHPT=POINTZ"
v.out.ogr Slope_VV_points type=point format=ESRI_Shapefile output=Slope_VV_points.shp lco="SHPT=POINTZ"
v.out.ogr Elevation_VV_points type=point format=ESRI_Shapefile output=Elevation_VV_points.shp lco="SHPT=POINTZ"


# --------------- R2V for Elevation_VV_area ------------------->
g.region raster=Elevation_VV -p
# we smooth corners of area features
r.to.vect -s input=Elevation_VV output=Elevation_VV_area type=area
v.colors Elevation_VV_area color=random
# Mapping
g.region raster=Elevation_VV -p
d.mon wx0
d.vect Elevation_VV_area
# Now export areas from GRASS vector map to Shapefile format, converting islands (holes) to filled polygons:
v.out.ogr -c input=Elevation_VV_area type=area format=ESRI_Shapefile output=Elevation_VV_area.shp
#
# --------------- R2V for Slope_VV_area ------------------->
g.region raster=Slope_VV_area -p
# we smooth corners of area features
r.to.vect -s input=Slope_VV output=Slope_VV_area type=area
v.colors Slope_VV_area color=random
# Mapping
g.region vector=Slope_VV_area -p
d.mon wx0
d.vect Slope_VV_area
# Now export areas from GRASS vector map to Shapefile format, converting islands (holes) to filled polygons:
v.out.ogr -c input=Slope_VV_area type=area format=ESRI_Shapefile output=Slope_VV_area.shp

v.out.ogr Aspect_VV_points type=point format=ESRI_Shapefile output=Aspect_VV_points.shp lco="SHPT=POINTZ"

#
v.extract input=Elevation_VV_area output=Elevation_VV_01 where="cat = 2220"
v.extract input=Slope_VV_area output=Slope_VV_01 where="cat = 20"
v.overlay ainput=Elevation_VV_area binput=Slope_VV_area operator=and output=point_1
v.colors point_1 color=random
# Mapping
g.region raster=Elevation_VV -p
d.mon wx0
d.vect point_1
