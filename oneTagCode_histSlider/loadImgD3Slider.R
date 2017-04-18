##### Mean #####
wd=""
setwd(wd)

filesToDownload<-read.csv("filesToDownload.csv",stringsAsFactors=F,header=F)

oneTag=filesToDownload[which(grepl("MIROC-ESM-CHEM",filesToDownload[,1])),1]

histOneTag=oneTag[which(grepl("historical",oneTag))]
histMaxTempOneTag=histOneTag[which(grepl("tasmax",histOneTag))]

yr1=seq(1950,2005,by=1)

toWrite=paste("<img id=\"img-maxTempMean",yr1,"\" class=\"bottom\" src=\"","tasmax_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_",
              yr1,".ncmean",".png\" />",sep="")
length(toWrite)
writeLines(toWrite)

## change class of 1950 to top (default to show first in app)
## copy and paste into index.html

histMinTempOneTag=histOneTag[which(grepl("tasmin",histOneTag))]

yr1=seq(1950,2005,by=1)

toWrite=paste("<img id=\"img-minTempMean",yr1,"\" class=\"bottom\" src=\"","tasmin_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_",
              yr1,".ncmean",".png\" />",sep="")
length(toWrite)
writeLines(toWrite)


## copy and paste into index.html

histPrTempOneTag=histOneTag[which(grepl("pr",histOneTag))]

yr1=seq(1950,2005,by=1)

toWrite=paste("<img id=\"img-prMean",yr1,"\" class=\"bottom\" src=\"","pr_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_",
              yr1,".ncmean",".png\" />",sep="")
length(toWrite)
writeLines(toWrite)


## copy and paste into index.html


###### SD #####
wd=""
setwd(wd)

filesToDownload<-read.csv("filesToDownload.csv",stringsAsFactors=F,header=F)

oneTag=filesToDownload[which(grepl("MIROC-ESM-CHEM",filesToDownload[,1])),1]

histOneTag=oneTag[which(grepl("historical",oneTag))]
histMaxTempOneTag=histOneTag[which(grepl("tasmax",histOneTag))]

yr1=seq(1950,2005,by=1)

toWrite=paste("<img id=\"img-maxTempSD",yr1,"\" class=\"bottom\" src=\"","tasmax_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_",
              yr1,".ncsd",".png\" />",sep="")
length(toWrite)
writeLines(toWrite)


## copy and paste into index.html

histMinTempOneTag=histOneTag[which(grepl("tasmin",histOneTag))]

yr1=seq(1950,2005,by=1)

toWrite=paste("<img id=\"img-minTempSD",yr1,"\" class=\"bottom\" src=\"","tasmin_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_",
              yr1,".ncsd",".png\" />",sep="")
length(toWrite)
writeLines(toWrite)

## copy and paste into index.html

histPrTempOneTag=histOneTag[which(grepl("pr",histOneTag))]

yr1=seq(1950,2005,by=1)

toWrite=paste("<img id=\"img-prSD",yr1,"\" class=\"bottom\" src=\"","pr_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_",
              yr1,".ncsd",".png\" />",sep="")
length(toWrite)
writeLines(toWrite)

## copy and paste into index.html



