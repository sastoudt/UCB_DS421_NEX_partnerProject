## Code for Making Snapshot Images of Future Projected Data and Accessing Local Time Series

Run getTrend.R:

This will get the yearly mean at each location for each variable of one climate model and calculate the robust OLS slope of each series. It will also create the files needed to display this information in d3/visualizations/d3_readPlotColoredPointsOnMap.

This takes about an hour for one variable/climate model pair on a personal laptop.

Run lookupForTimeSeries.R:

This will give the grid cell for a given point. This code also yields some of the code needed for the D3 version of this process.

Run allTagOneLocationGetSeries.R:

This will get the time series for the grid cell for a specified point of a particular variable for all of climate models. This will take many hours.


