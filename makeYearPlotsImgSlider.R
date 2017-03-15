## run getBreaksMakeLegendsHistoricalOnly.R to get breakpoints for precip and min temp

## try this out for max temp and time

## make legend

## then do for Jenna's tag and for the future climate

##do we have all that data?
## only missing rcp85 for my tag, might have fixed this, double check tomorrow

gitHubDir="~/Desktop/UCB_DS421_NEX_partnerProject"
setwd(gitHubDir)
lon=read.csv("lon.csv",stringsAsFactors=F)
lat=read.csv("lat.csv",stringsAsFactors=F)
lonLatGrid=expand.grid(lon[,1],lat[,1])
quantAvgAllPrHist=quantSDAllPrHist=c()
quantAvgAllMinTempHist=quantSDAllMinTempHist=c()
quantAvgAllMaxTempHist=quantSDAllMaxTempHist=c()

maxTempBreaks=c(238.1236, 252.4237, 260.7205, 268.3477, 274.6672, 280.4095, 285.7682, 290.0989, 292.9525, 299.6218, 311.6947)
maxTempBreaks=maxTempBreaks[-1]
maxTempCol=c(brewer.pal(9,"YlOrRd"),"black")

tagList<-read.csv("tags.csv",stringsAsFactors=F,header=F)
nex_climate_filenames <- read.table("nex_climate_filenames.txt", 
                                    quote="\"", comment.char="") 

filesPertagList=vector("list",nrow(tagList)) ## CHANGED FROM LENGTH TO NROW
for(i in 1:nrow(tagList)){
  filesPertagList[[i]]=nex_climate_filenames[grepl(tagList[i,1],nex_climate_filenames[,1]),1]
} ## get files per tag



which(tagList[,1]=="MIROC-ESM-CHEM") ## 15
require(ncdf4)
require(RSvgDevice)
require(RColorBrewer)
require(maps)
#### 


yourPathToData="/Volumes/Sara_5TB/NEX" ## no slash needed here

#for(i in 1:nrow(tagList)){
i=15
## split by type of data

prFileNames=filesPertagList[[i]][grepl("pr_",filesPertagList[[i]])]
tempMinFileNames=filesPertagList[[i]][grepl("tasmin_",filesPertagList[[i]])]
tempMaxFileNames=filesPertagList[[i]][grepl("tasmax_",filesPertagList[[i]])]

## split by historical, rcp45, rcp85

prFileNames_hist=prFileNames[grepl("historical",prFileNames)]
#prFileNames_rcp45=prFileNames[grepl("rcp45",prFileNames)]
#prFileNames_rcp85=prFileNames[grepl("rcp85",prFileNames)]

tempMinFileNames_hist=tempMinFileNames[grepl("historical",tempMinFileNames)]
#tempMinFileNames_rcp45=tempMinFileNames[grepl("rcp45",tempMinFileNames)]
#tempMinFileNames_rcp85=tempMinFileNames[grepl("rcp85",tempMinFileNames)]

tempMaxFileNames_hist=tempMaxFileNames[grepl("historical",tempMaxFileNames)]
#tempMaxFileNames_rcp45=tempMaxFileNames[grepl("rcp45",tempMaxFileNames)]
#tempMaxFileNames_rcp85=tempMaxFileNames[grepl("rcp85",tempMaxFileNames)]

ptm <- proc.time()
#prHistYr=array(0,c(1440,720,length(prFileNames_hist)))
for(j in 1:length(prFileNames_hist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/pr/",prFileNames_hist[j],sep="")
  
  ncin <- nc_open(ncname)
  
  precipHist <- ncvar_get(ncin,"pr")
  ## need to double check for tmax, tmin, see what they are called
  nc_close(ncin)
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/pr/",sep="")
  imgName=paste(prFileNames_hist[j],"_yearMean",".json",sep="")
  setwd(toSavePath)
  
  oneDay=apply(precipHist,c(1,2),mean,na.rm=T)
  
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/pr/",sep="")
  #imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
  setwd(toSavePath)
  ## make image
  year=substr(prFileNames_hist[j],nchar(as.character(prFileNames_hist[j]))-11,nchar(as.character(prFileNames_hist[j]))-8)
  
  
  if(makePNG){
    imgName=paste(prFileNames_hist[j],"mean",".png",sep="")
    png(file=imgName,width=10,height=8,units="in",res = 300)
  }else{
    imgName=paste(prFileNames_hist[j],"mean",".svg",sep="")
    devSVG(file=imgName,width=10,height=8)
  }
  
  test=image(lon-180, lat, oneDay,breaks=breaksAllPr,col=colAllPr,sub=paste("historical ",tagList[i,1]),main=paste("Precip",year),xlab="lat",ylab="lon")
  map("world",add=T) ## + key
  dev.off()
  
  prHistYr[,,j]=oneDay
  print(paste("precip file",j,sep=" "))
  
}

ptm <- proc.time()
tempMinHistYr=array(0,c(1440,720,length(tempMinFileNames_hist)))
for(j in 1:length(tempMinFileNames_hist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmin/",tempMinFileNames_hist[j],sep="")
  ncin <- nc_open(ncname)
  tempMinHist <- ncvar_get(ncin,"tasmin")
  
  nc_close(ncin)
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
  imgName=paste(tempMinFileNames_hist[j],"yearMean",".json",sep="")
  setwd(toSavePath)
  
  oneDay=apply(tempMinHist,c(1,2),mean,na.rm=T)
 
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
  #imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
  setwd(toSavePath)
  ## make image
  year=substr(tempMinFileNames_hist[j],nchar(as.character(tempMinFileNames_hist[j]))-11,nchar(as.character(tempMinFileNames_hist[j]))-8)
  
  
  if(makePNG){
    imgName=paste(tempMinFileNames_hist[j],"mean",".png",sep="")
    png(file=imgName,width=10,height=8,units="in",res = 300)
  }else{
    imgName=paste(tempMinFileNames_hist[j],"mean",".svg",sep="")
    devSVG(file=imgName,width=10,height=8)
  }
  
  test=image(lon-180, lat, oneDay,breaks=breaksAllTempMin,col=colAllTempMin,sub=paste("historical ",tagList[i,1]),main=paste("Min Temp",year),xlab="lat",ylab="lon")
  map("world",add=T) ## + key
  dev.off()
  
  
  print(paste("min temp file",j,sep=" "))
  
}

ptm <- proc.time()
#tempMaxHistYr=array(0,c(1440,720,length(tempMaxFileNames_hist)))

for(j in 1:length(tempMaxFileNames_hist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmax/",tempMaxFileNames_hist[j],sep="")
  ncin <- nc_open(ncname)
  tempMaxHist <- ncvar_get(ncin,"tasmax")
  ## need to do for tmax, tmin, see what they are called
  nc_close(ncin)
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmax/",sep="")
  imgName=paste(tempMaxFileNames_hist[j],"yearMean",".json",sep="")
  setwd(toSavePath)
  ## make image
  oneDay=apply(tempMaxHist,c(1,2),mean,na.rm=T)
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmax/",sep="")
  #imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
  setwd(toSavePath)
  ## make image
  year=substr(tempMaxFileNames_hist[j],nchar(as.character(tempMaxFileNames_hist[j]))-11,nchar(as.character(tempMaxFileNames_hist[j]))-8)
  
  
  if(makePNG){
    imgName=paste(tempMaxFileNames_hist[j],"mean",".png",sep="")
    png(file=imgName,width=10,height=8,units="in",res = 300)
  }else{
    imgName=paste(tempMaxFileNames_hist[j],"mean",".svg",sep="")
    devSVG(file=imgName,width=10,height=8)
  }
  
  test=image(lon-180, lat, oneDay,breaks=maxTempBreaks,col=maxTempCol,sub=paste("historical ",tagList[i,1]),main=paste("Max Temp",year),xlab="lat",ylab="lon")
  map("world",add=T) ## + key
  dev.off()
  
  print(paste("max temp file",j,sep=" "))
  
}

##### make legends ####

require(RColorBrewer)
require(R2BayesX)
library(RSvgDevice)

## below needed or this test only
# quantAvgAllPrHist=quantSDAllPrHist=quantAvgAllMinTempHist=quantSDAllMinTempHist=quantAvgAllMaxTempHist=quantSDAllMaxTempHist=matrix(NA,ncol=11,nrow=2)
# 
# quantAvgAllPrHist[1,]=quantile(quantPr$avgDiff,seq(0,1,by=.1),na.rm=T)
# quantSDAllPrHist[1,]=quantile(quantPr$sdDiff,seq(0,1,by=.1),na.rm=T)
# 
# quantAvgAllMinTempHist[1,]=quantile(quantMinTemp$avgDiff,seq(0,1,by=.1),na.rm=T)
# quantSDAllMinTempHist[1,]=quantile(quantMinTemp$sdDiff,seq(0,1,by=.1),na.rm=T)
# 
# quantAvgAllMaxTempHist[1,]=quantile(quantMaxTemp$avgDiff,seq(0,1,by=.1),na.rm=T)
# quantSDAllMaxTempHist[1,]=quantile(quantMaxTemp$sdDiff,seq(0,1,by=.1),na.rm=T)

#i=15

#for(i in 1:nrow(tagList)){
toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/pr/",sep="")
setwd(toSavePath)
imgName=paste(tagList[i,1],"_prHistLegendAggAvg.svg",sep="")
#i=1
toPlot=quantAvgAllPrHist[i,]
devSVG(file=imgName,width=12,height=4)
colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
dev.off()
#i=15
imgName=paste(tagList[i,1],"_prHistLegendAggSD.svg",sep="")
#i=1
toPlot=quantSDAllPrHist[i,]
devSVG(file=imgName,width=12,height=4)
colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
dev.off()

# toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/pr/",sep="")
# setwd(toSavePath)
# imgName=paste(tagList[i,1],"_pr45LegendAggAvg.svg",sep="")
# toPlot=quantAvgAllPr45[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()
# imgName=paste(tagList[i,1],"_pr45LegendAggSD.svg",sep="")
# toPlot=quantSDAllPr45[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()
# 
# toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/pr/",sep="")
# setwd(toSavePath)
# imgName=paste(tagList[i,1],"_pr85LegendAggAvg.svg",sep="")
# toPlot=quantAvgAllPr85[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()
# imgName=paste(tagList[i,1],"_pr85LegendAggSD.svg",sep="")
# toPlot=quantSDAllPr85[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()

#i=15
toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
setwd(toSavePath)
imgName=paste(tagList[i,1],"_minTempHistLegendAggAvg.svg",sep="")
#i=1
toPlot=quantAvgAllMinTempHist[i,]
devSVG(file=imgName,width=12,height=4)
colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
dev.off()
#i=15
imgName=paste(tagList[i,1],"_minTempHistLegendAggSD.svg",sep="")
#i=1
toPlot=quantSDAllMinTempHist[i,]
devSVG(file=imgName,width=12,height=4)
colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
dev.off()

# toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmin/",sep="")
# setwd(toSavePath)
# imgName=paste(tagList[i,1],"_minTemp45LegendAggAvg.svg",sep="")
# toPlot=quantAvgAllMinTemp45[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()
# imgName=paste(tagList[i,1],"_minTemp45LegendAggSD.svg",sep="")
# toPlot=quantSDAllMinTemp45[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()
# 
# toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmin/",sep="")
# setwd(toSavePath)
# imgName=paste(tagList[i,1],"_minTemp85LegendAggAvg.svg",sep="")
# toPlot=quantAvgAllMinTemp85[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()
# imgName=paste(tagList[i,1],"_minTemp85LegendAggSD.svg",sep="")
# toPlot=quantSDAllMinTemp85[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()

setwd("/Volumes/Sara_5TB/NEX/rawdata/historical/MIROC-ESM-CHEM/tasmax/")
aggResults=read.csv("aggResults.csv",stringsAsFactors=F)

toPlot=quantile(aggResults$avgDiff,seq(0,1,by=.1),na.rm=T)
#i=15
toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmax/",sep="")
setwd(toSavePath)
imgName=paste(tagList[i,1],"_maxTempHistLegendAggAvg.svg",sep="")
#i=1
toPlot=quantAvgAllMaxTempHist[i,]
devSVG(file=imgName,width=12,height=4)
colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=3,symmetric=F)
text(1:11,1,"test")
dev.off()
#i=15
imgName=paste(tagList[i,1],"_maxTempHistLegendAggSD.svg",sep="")
#i=1
toPlot=quantSDAllMaxTempHist[i,]
devSVG(file=imgName,width=12,height=4)
colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
dev.off()

# toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmax/",sep="")
# setwd(toSavePath)
# imgName=paste(tagList[i,1],"_maxTemp45LegendAggAvg.svg",sep="")
# toPlot=quantAvgAllMaxTemp45[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()
# imgName=paste(tagList[i,1],"_maxTemp85LegendAggSD.svg",sep="")
# toPlot=quantAvgAllMaxTemp45[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()
# 
# toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmax/",sep="")
# setwd(toSavePath)
# imgName=paste(tagList[i,1],"_maxTemp85LegendAggAvg.svg",sep="")
# toPlot=quantAvgAllMaxTemp85[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()
# imgName=paste(tagList[i,1],"_maxTemp85LegendAggSD.svg",sep="")
# toPlot=quantSDAllMaxTemp85[i,]
# devSVG(file=imgName,width=12,height=4)
# colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
# dev.off()
#  print(paste("tag",i,sep=" "))


#}

## legends are cramped with labels, need to fix this
