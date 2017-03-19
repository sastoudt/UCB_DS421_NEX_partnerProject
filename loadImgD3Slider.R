## need to automatically generate sourcing and naming all images

# <div id="cf">
#   <img id="img-1950" class="top" src="berkeley-logo.png" />
#     <img id="img-1951" class="bottom" src="pglsVBayes.png" />
#       <img id="img-1952" class="bottom" src="Rplot001.png" />
#         
#         
#         </div>

setwd("~/Desktop/nasaDataScrapeAfterTimeout")
filesToDownload<-read.csv("filesToDownload.csv",stringsAsFactors=F,header=F)
head(filesToDownload)

oneTag=filesToDownload[which(grepl("MIROC-ESM-CHEM",filesToDownload[,1])),1]

histOneTag=oneTag[which(grepl("historical",oneTag))]

histMaxTempOneTag=histOneTag[which(grepl("tasmax",histOneTag))]

yr1=seq(1950,2006,by=1/365)
yr1=round(yr1*1000)/1000

yr=floor(yr1)
yr=yr[-length(yr)]

#table(yr)

#yr=sort(rep(seq(1950,2005,by=1),365))
day=rep(1:365,56)
toWrite=paste("<img id=\"img-",yr1,"\" class=\"bottom\" src=\"","pr_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_",
              yr,".ncday",day,".png\" />",sep="")
length(toWrite)
toWrite=toWrite[-length(toWrite)]
writeLines(toWrite)

## change class of 1950 to top
## copy and paste into index.html

## but what will the figures be called, png v. svg?

#pr_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_1950.ncday1.png

#### year scale ####

setwd("~/Desktop/nasaDataScrapeAfterTimeout")
filesToDownload<-read.csv("filesToDownload.csv",stringsAsFactors=F,header=F)
head(filesToDownload)

oneTag=filesToDownload[which(grepl("MIROC-ESM-CHEM",filesToDownload[,1])),1]

histOneTag=oneTag[which(grepl("historical",oneTag))]

histMaxTempOneTag=histOneTag[which(grepl("tasmax",histOneTag))]

yr1=seq(1950,2005,by=1)
#yr1=round(yr1*1000)/1000

#yr=floor(yr1)
#yr=yr[-length(yr)]

#table(yr)
#tasmax_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_2005.ncmean.png

#yr=sort(rep(seq(1950,2005,by=1),365))
#day=rep(1:365,56)
toWrite=paste("<img id=\"img-",yr1,"\" class=\"bottom\" src=\"","tasmax_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_",
              yr1,".ncmean",".png\" />",sep="")
length(toWrite)
#toWrite=toWrite[-length(toWrite)]
writeLines(toWrite)

## change class of 1950 to top
## copy and paste into index.html

## but what will the figures be called, png v. svg?

#pr_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_1950.ncday1.png

