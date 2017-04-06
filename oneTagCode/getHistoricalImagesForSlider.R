## one tag historical image plots

##### SETUP ####

require(RColorBrewer)

makePNG=T
gitHubDir="~/Desktop/UCB_DS421_NEX_partnerProject"
setwd(gitHubDir)
lon=read.csv("lon.csv",stringsAsFactors=F)
lat=read.csv("lat.csv",stringsAsFactors=F)
lonLatGrid=expand.grid(lon[,1],lat[,1])

## run getBreaksMakeLegendsHistoricalOnly.R to get breakpoints 

maxTempBreaks=c(238.1236, 252.4237, 260.7205, 268.3477, 274.6672, 280.4095, 285.7682, 290.0989, 292.9525, 299.6218, 311.6947)
maxTempBreaks=c(-1,maxTempBreaks)
maxTempCol=c(brewer.pal(9,"YlOrRd"),"black")
maxTempCol=c("purple",maxTempCol)

breaksAllPr=c(0.000000e+00, 1.014111e-06, 4.324644e-06, 7.796617e-06, 1.160405e-05, 1.542219e-05, 1.931398e-05, 2.379187e-05, 2.972974e-05,
              4.001693e-05 ,2.485461e-04)
breaksAllPr=c(-2,breaksAllPr)
colAllPr=c(brewer.pal(9,"Blues"),"black")
colAllPr=c("red",colAllPr)

breaksAllTempMin=c(229.2667, 247.5466, 255.0066, 264.1902, 270.6052, 276.3952, 282.5225,
                   287.3514, 290.8524, 293.0666, 302.5298)
breaksAllTempMin=c(-1,breaksAllTempMin)
colAllTempMin=c("black",rev(brewer.pal(9,"Purples")))
colAllTempMin=c("green",colAllTempMin)

tagList<-read.csv("tags.csv",stringsAsFactors=F,header=F)
nex_climate_filenames <- read.table("nex_climate_filenames.txt", 
                                    quote="\"", comment.char="") 

filesPertagList=vector("list",nrow(tagList)) 
for(i in 1:nrow(tagList)){
  filesPertagList[[i]]=nex_climate_filenames[grepl(tagList[i,1],nex_climate_filenames[,1]),1]
}



which(tagList[,1]=="MIROC-ESM-CHEM") ## 15
require(ncdf4)
require(RSvgDevice)

require(maps)
 


yourPathToData="/Volumes/Sara_5TB/NEX" ## no slash needed here


i=15
## split by type of data

prFileNames=filesPertagList[[i]][grepl("pr_",filesPertagList[[i]])]
tempMinFileNames=filesPertagList[[i]][grepl("tasmin_",filesPertagList[[i]])]
tempMaxFileNames=filesPertagList[[i]][grepl("tasmax_",filesPertagList[[i]])]

## split by historical

prFileNames_hist=prFileNames[grepl("historical",prFileNames)]

tempMinFileNames_hist=tempMinFileNames[grepl("historical",tempMinFileNames)]


tempMaxFileNames_hist=tempMaxFileNames[grepl("historical",tempMaxFileNames)]

#### PRECIP ####
ptm <- proc.time()
for(j in 1:length(prFileNames_hist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/pr/",prFileNames_hist[j],sep="")
  
  ncin <- nc_open(ncname)
  
  precipHist <- ncvar_get(ncin,"pr")

  nc_close(ncin)
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/pr/",sep="")
  imgName=paste(prFileNames_hist[j],"_yearMean",".json",sep="")
  setwd(toSavePath)
  
  oneDay=apply(precipHist,c(1,2),mean,na.rm=T)
  oneDay[is.na(oneDay)]=-1
  oneDay[is.nan(oneDay)]=-1

  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/pr/",sep="")
  setwd(toSavePath)
  year=  substr(tempMaxFileNames_hist[j],nchar(as.character(tempMaxFileNames_hist[j]))-6,nchar(as.character(tempMaxFileNames_hist[j]))-3)
  
  
  if(makePNG){
    imgName=paste(prFileNames_hist[j],"mean",".png",sep="")
    png(file=imgName,width=10,height=8,units="in",res = 300)
  }else{
    imgName=paste(prFileNames_hist[j],"mean",".svg",sep="")
    devSVG(file=imgName,width=10,height=8)
  }
  
  test=image(lon[,1]-180, lat[,1], oneDay,breaks=breaksAllPr,col=colAllPr,sub=paste("historical ",tagList[i,1]),main=paste("Precip",year),xlab="lat",ylab="lon")
  map("world",add=T) ## + key
  dev.off()

  print(paste("precip file",j,sep=" "))
  
}

#### MIN TEMP ####
ptm <- proc.time()
for(j in 1:length(tempMinFileNames_hist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmin/",tempMinFileNames_hist[j],sep="")
  ncin <- nc_open(ncname)
  tempMinHist <- ncvar_get(ncin,"tasmin")
  
  nc_close(ncin)
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
  imgName=paste(tempMinFileNames_hist[j],"yearMean",".json",sep="")
  setwd(toSavePath)
  
  oneDay=apply(tempMinHist,c(1,2),mean,na.rm=T)
  oneDay=apply(tempMaxHist,c(1,2),mean,na.rm=T)
  oneDay[is.na(oneDay)]=0
  oneDay[is.nan(oneDay)]=0
  
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
  setwd(toSavePath)
  year=  substr(tempMaxFileNames_hist[j],nchar(as.character(tempMaxFileNames_hist[j]))-6,nchar(as.character(tempMaxFileNames_hist[j]))-3)
  
  
  if(makePNG){
    imgName=paste(tempMinFileNames_hist[j],"mean",".png",sep="")
    png(file=imgName,width=10,height=8,units="in",res = 300)
  }else{
    imgName=paste(tempMinFileNames_hist[j],"mean",".svg",sep="")
    devSVG(file=imgName,width=10,height=8)
  }
 
  test=image(lon[,1]-180, lat[,1], oneDay,breaks=breaksAllTempMin,col=colAllTempMin,sub=paste("historical ",tagList[i,1]),main=paste("Min Temp",year),xlab="lat",ylab="lon")
  map("world",add=T) ## + key
  dev.off()
  
  
  print(paste("min temp file",j,sep=" "))
  
}

##### MAX TEMP ####
ptm <- proc.time()

for(j in 1:length(tempMaxFileNames_hist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmax/",tempMaxFileNames_hist[j],sep="")
  ncin <- nc_open(ncname)
  tempMaxHist <- ncvar_get(ncin,"tasmax")
  nc_close(ncin)
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmax/",sep="")
  imgName=paste(tempMaxFileNames_hist[j],"yearMean",".json",sep="")
  setwd(toSavePath)
  oneDay=apply(tempMaxHist,c(1,2),mean,na.rm=T)
  oneDay[is.na(oneDay)]=0
  oneDay[is.nan(oneDay)]=0
 
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmax/",sep="")
  setwd(toSavePath)
  year=  substr(tempMaxFileNames_hist[j],nchar(as.character(tempMaxFileNames_hist[j]))-6,nchar(as.character(tempMaxFileNames_hist[j]))-3)
  

  if(makePNG){
    imgName=paste(tempMaxFileNames_hist[j],"mean",".png",sep="")
    png(file=imgName,width=10,height=8,units="in",res = 300)
  }else{
    imgName=paste(tempMaxFileNames_hist[j],"mean",".svg",sep="")
    devSVG(file=imgName,width=10,height=8)
  }
  
  
  test=image(lon[,1]-180, lat[,1], oneDay,breaks=maxTempBreaks,col=maxTempCol,sub=paste("historical ",tagList[i,1]),main=paste("Max Temp",year),xlab="lat",ylab="lon")
  map("world",add=T) ## + key
  dev.off()
  
  print(paste("max temp file",j,sep=" "))
  
}
proc.time() - ptm 

### make legends ###
toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmax/",sep="")
setwd(toSavePath)
imgName=paste(tagList[i,1],"_maxTempHistLegendAvg.svg",sep="")
toPlot=maxTempBreaks[-1]
devSVG(file=imgName,width=12,height=4)
colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=3,symmetric=F)
dev.off()

toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
setwd(toSavePath)
imgName=paste(tagList[i,1],"_minTempHistLegendAvg.svg",sep="")
toPlot=breaksAllTempMin[-1]
devSVG(file=imgName,width=12,height=4)
colorlegend(color=colAllTempMin[-1],breaks=toPlot,at=toPlot,x=toPlot,digits=3,symmetric=F)
dev.off()

toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/pr/",sep="")
setwd(toSavePath)
imgName=paste(tagList[i,1],"_prHistLegendAvg.svg",sep="")
toPlot=breaksAllPr[-1]
devSVG(file=imgName,width=12,height=4)
colorlegend(color=colAllPr[-1],breaks=toPlot,at=toPlot,x=toPlot,digits=3,symmetric=F)
dev.off()

