## Code for Making Slider Images of Historical Data for One Climate Model

Run getBreakPoints.R:

This will give the break points for heat maps for maximum temperature, minimum temperature, and precipitation for one climate model tag. These break points are rough estimates as we subsample the files per tag-variable combination, take the quantiles at 10% intervals, and average over these. Upon inspection, this process give us reasonable breaks.

Run getHistoricalImagesForSlider.R 

If you are using getBreakPoints.R there are lines to uncomment in getHistoricalImagesForSlider.R to transfer the break points over to this analysis.

This code will generate an image per year of the average and standard deviation of each variable and save them to the appropriate directory.

Run loadImgD3Slider.R

This code will automatically generate some of the Javascript code needed for the image slider in D3. This code will print to the console, and then you copy and paste these chunks into the appropriate area in the D3 code (see the d3visualizations README for more details).



