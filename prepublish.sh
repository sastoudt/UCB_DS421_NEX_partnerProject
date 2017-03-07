#!/bin/bash

# EPSG:3310 California Albers
PROJECTION='d3.geoAlbers().parallels([34, 40.5]).rotate([120, 0])'

# The state FIPS code.
STATE=06

# The ACS 5-Year Estimate vintage.
YEAR=2014

# The display size.
WIDTH=960
HEIGHT=1100

# Download the census block group boundaries.
# Extract the shapefile (.shp) and dBASE (.dbf).
if [ ! -f cb_${YEAR}_${STATE}_bg_500k.shp ]; then
  curl -o cb_${YEAR}_${STATE}_bg_500k.zip \
    "http://www2.census.gov/geo/tiger/GENZ${YEAR}/shp/cb_${YEAR}_${STATE}_bg_500k.zip"
  unzip -o \
    cb_${YEAR}_${STATE}_bg_500k.zip \
    cb_${YEAR}_${STATE}_bg_500k.shp \
    cb_${YEAR}_${STATE}_bg_500k.dbf
fi

# Download the list of counties.
if [ ! -f cb_${YEAR}_${STATE}_counties.json ]; then
  curl -o cb_${YEAR}_${STATE}_counties.json \
    "http://api.census.gov/data/${YEAR}/acs5?get=NAME&for=county:*&in=state:${STATE}&key=${CENSUS_KEY}"
fi

# Download the census block group population estimates for each county.
if [ ! -f cb_${YEAR}_${STATE}_bg_B01003.ndjson ]; then
  for COUNTY in $(ndjson-cat cb_${YEAR}_${STATE}_counties.json \
      | ndjson-split \
      | tail -n +2 \
      | ndjson-map 'd[2]' \
      | cut -c 2-4); do
    echo ${COUNTY}
    if [ ! -f cb_${YEAR}_${STATE}_${COUNTY}_bg_B01003.json ]; then
      curl -o cb_${YEAR}_${STATE}_${COUNTY}_bg_B01003.json \
        "http://api.census.gov/data/${YEAR}/acs5?get=B01003_001E&for=block+group:*&in=state:${STATE}+county:${COUNTY}&key=${CENSUS_KEY}"
    fi
    ndjson-cat cb_${YEAR}_${STATE}_${COUNTY}_bg_B01003.json \
      | ndjson-split \
      | tail -n +2 \
      >> cb_${YEAR}_${STATE}_bg_B01003.ndjson
  done
fi

# 1. Convert to GeoJSON.
# 2. Project.
# 3. Join with the census data.
# 4. Compute the population density.
# 5. Simplify.
# 6. Compute the county borders.
geo2topo -n \
  blockgroups=<(ndjson-join 'd.id' \
    <(shp2json cb_${YEAR}_${STATE}_bg_500k.shp \
      | geoproject "${PROJECTION}.fitExtent([[10, 10], [${WIDTH} - 10, ${HEIGHT} - 10]], d)" \
      | ndjson-split 'd.features' \
      | ndjson-map 'd.id = d.properties.GEOID.slice(2), d') \
    <(cat cb_${YEAR}_${STATE}_bg_B01003.ndjson \
    | ndjson-map '{id: d[2] + d[3] + d[4], B01003: +d[0]}') \
    | ndjson-map -r d3=d3-array 'd[0].properties = {density: d3.bisect([1, 10, 50, 200, 500, 1000, 2000, 4000], (d[1].B01003 / d[0].properties.ALAND || 0) * 2589975.2356)}, d[0]') \
  | topomerge -k 'd.id.slice(0, 3)' counties=blockgroups \
  | topomerge --mesh -f 'a !== b' counties=counties \
  | topomerge -k 'd.properties.density' blockgroups=blockgroups \
  | toposimplify -p 1 -f \
  > topo.json

# Convert to SVG (while dropping the last line).
cat \
  <(topo2geo -n \
    < topo.json blockgroups=- \
    | ndjson-map -r d3=d3-scale-chromatic '(d.properties.title = d.id, d.properties.fill = d3.schemeOrRd[9][d.id], d)') \
  <(topo2geo -n \
    < topo.json counties=- \
    | ndjson-map '(d.properties.stroke = "black", d.properties.strokeOpacity = 0.3, d)') \
  | geo2svg --stroke=none -n -p 1 -w ${WIDTH} -h ${HEIGHT} \
  | sed '$d' \
  > topo.svg

# Insert the legend.
tail -n +4 \
  < legend.svg \
  >> topo.svg

rm topo.json