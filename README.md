# GRASS GIS Scripts — Raster and Vector Conversion (r.to.vect / v.to.rast)

GRASS GIS shell scripts by Polina Lemenkova demonstrating conversion between the raster and vector data models. Terrain rasters (elevation, slope, aspect) are used as sample data.

## Contents
- **Vector to raster (v.to.rast):** rasterise vector area features by category.
- **Raster to vector (r.to.vect):** random point sampling of rasters (r.random) exported as vector points, and conversion of rasters to smoothed vector areas.
- **Statistics:** univariate statistics of sampled vector points (v.univar) compared with the full raster (r.univar).
- **Export and processing:** export of vector points (3D POINTZ) and areas to ESRI Shapefile (v.out.ogr), attribute-based feature extraction (v.extract), vector overlay (v.overlay) and styling/display (v.colors, d.vect).

## Usage
Each block is self-contained. Adapt the input raster and vector names and region to your own data.

## Citation
If you use or adapt these scripts, please credit the author, Polina Lemenkova (ORCID: 0000-0002-5759-1089).
