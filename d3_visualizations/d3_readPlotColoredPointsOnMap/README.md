## Read Colored Points on Map

This will not work in Google Chrome.

This is a mockup of a map where changing the dropdown choice changes the legend and the data displayed. See mockup.pdf for an example.

The D3 code that you would need to make this fully operational is contained in this folder, the correct images just aren't for space and computational time reasons.

The data displayed is created using code in the oneTagCode_rcpStaticImg folder. Point locations and colors are prespecified, and the dropdown just specifies which one to display on the map. 

When you click, a time series for that location pops up. For now, if you click anywhere, a fake time series will pop up. However, the code to find the grid cell of the clicked point and load that time series image is contained in the indexDropdown.html file for future use.