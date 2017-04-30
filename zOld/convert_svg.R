#need to download exe file from http://phantomjs.org/download.html, put it somewhere handy, find path to "phantomjs" in the downloaded "bin" directory
library(convertGraph)
convertGraph(svg, "/Volumes/Seagate_Expansion_5TB_jtb/NASA/climate/images/historical/ACCESS1-0/pr/pr_day_BCSD_historical_r1i1p1_ACCESS1-0_1950.ncday1.png", size = 1.0, path = "/Applications/phantomjs-2.1.1-macosx/bin/phantomjs")
