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

yr=seq(1950,2005,by=1)
writeLines(paste("<img id=\"img-",yr,"\" class=\"bottom\" src=\"",yr,".png\" />",sep=""))

## change class of 1950 to top
## copy and paste into index.html

## but what will the figures be called, png v. svg?
