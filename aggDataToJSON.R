## aggregated data to JSON for manipulation in D3

## lat
## lon

## value
setwd("~/Desktop/d3Practice")
library(ncdf4)
## whole globe for a year
ncname <- "pr_day_BCSD_historical_r1i1p1_ACCESS1-0_1950"  
ncfname <- paste(ncname,".nc", sep="")
ncin <- nc_open(ncfname)
lon <- ncvar_get(ncin,"lon")
lat <- ncvar_get(ncin,"lat")
time<-ncvar_get(ncin,"time")
precip <- ncvar_get(ncin,"pr")
nc_close(ncin)

dim(precip)
length(lon)
length(lat)
## lon x lat

test=matrix(c(1,2,3,4,5,6),nrow=3,ncol=2)

c(test)

lonLatGrid=expand.grid(lon,lat)
dim(lonLatGrid) ## 1036800       2

head(lonLatGrid) ## same lat for different lon so exactly the format of c()

catPrecip=c(precip[,,1]) ## aggregate to one level
length(catPrecip) ##  

lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,catPrecip))
dim(lonLatGridPlusValue)

names(lonLatGridPlusValue)=c("lon","lat","pr")
lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
lonLatGridPlusValue$pr=as.numeric(as.character(lonLatGridPlusValue$pr))

miniSubCSV=lonLatGridPlusValue[1000:1100,]
## add random colors to test out d3 code
require(RColorBrewer)
colToUse=brewer.pal(5, "YlOrRd")
miniSubCSV$col=colToUse[sample(1:5,101,replace=T)]
write.csv(miniSubCSV,"testMini.csv",row.names=F)

## Not showing up
require(maps)
map("world")
points(miniSubCSV$lon, miniSubCSV$lat)
points(miniSubCSV$lon-180, miniSubCSV$lat)

## try different subset
miniSubCSV=lonLatGridPlusValue[50000:51000,]
map("world")
#points(miniSubCSV$lon, miniSubCSV$lat)
points(miniSubCSV$lon-180, miniSubCSV$lat)
miniSubCSV$col=colToUse[sample(1:5,1001,replace=T)]
write.csv(miniSubCSV,"testMini2.csv",row.names=F)
## still unclear whether we want to subtract 180, will be able to tell better when we have real colors

## slow to load in D3 but it does
lonLatGridPlusValue$col=colToUse[sample(1:5,nrow(lonLatGridPlusValue),replace=T)]
write.csv(lonLatGridPlusValue,"whole.csv",row.names=F)

library(jsonlite)
#x <- toJSON(lonLatGridPlusValue)
#head(cat(x))

write_json(lonLatGridPlusValue,"test.json")
#write_json(x,"test.json")

miniSub=lonLatGridPlusValue[1000:1100,]
write_json(miniSub,"testMini.json")


##http://bl.ocks.org/Jverma/887877fc5c2c2d99be10 
## this example works

##https://bl.ocks.org/mbostock/raw/4090846/world-50m.json
##https://bl.ocks.org/mbostock/3757119
##http://stackoverflow.com/questions/20987535/plotting-points-on-a-map-with-d3

## put one point on map
## http://bl.ocks.org/phil-pedruco/7745589
## works

### To ask Proxima

## read data and plot points
## how to colorcode the points by a z variable

## globe in D3 version 4?

## try to get image slider working



###### Aggregation  ####

## take mean per year for everything, save as json
## definitely want subset
## further aggregation across years?

library(jsonlite)
library(ncdf4)
#require(ncdf4)
require(RSvgDevice)
require(RColorBrewer)
require(maps)

## path before rawdata, no ending backslash
yourPathToData=""
wdGit="~/Desktop/UCB_DS421_NEX_partnerProject"
setwd(wdGit)

tagList<-read.csv("tags.csv",stringsAsFactors=F,header=F) ## get tagList for different models

nex_climate_filenames <- read.table("nex_climate_filenames.txt", 
                                    quote="\"", comment.char="") ## get all file names

filesPertagList=vector("list",nrow(tagList))
for(i in 1:nrow(tagList)){
  filesPertagList[[i]]=nex_climate_filenames[grepl(tagList[i,1],nex_climate_filenames[,1]),1]
} ## get files per tag


#lon <- ncvar_get(ncin,"lon") ## should only have to do for one file, same across files
#lat <- ncvar_get(ncin,"lat") ## should only have to do for one file, same across files
## pick any file, grab these, and write to csv

lon=read.csv("lon.csv",stringsAsFactors=F)[,1]
lat=read.csv("lat.csv",stringsAsFactors=F)[,1]

## since looping over tagList, can easily run the code for only our half
for(i in 1:nrow(tagList)){
  
  ## split by type of data
  
  prFileNames=filesPertagList[[i]][grepl("pr_",filesPertagList[[i]])]
  tempMinFileNames=filesPertagList[[i]][grepl("tasmin_",filesPertagList[[i]])]
  tempMaxFileNames=filesPertagList[[i]][grepl("tasmax_",filesPertagList[[i]])]
  
  ## split by historical, rcp45, rcp85
  
  prFileNames_hist=prFileNames[grepl("historical",prFileNames)]
  prFileNames_rcp45=prFileNames[grepl("rcp45",prFileNames)]
  prFileNames_rcp85=prFileNames[grepl("rcp85",prFileNames)]
  
  tempMinFileNames_hist=tempMinFileNames[grepl("historical",tempMinFileNames)]
  tempMinFileNames_rcp45=tempMinFileNames[grepl("rcp45",tempMinFileNames)]
  tempMinFileNames_rcp85=tempMinFileNames[grepl("rcp85",tempMinFileNames)]
  
  tempMaxFileNames_hist=tempMaxFileNames[grepl("historical",tempMaxFileNames)]
  tempMaxFileNames_rcp45=tempMaxFileNames[grepl("rcp45",tempMaxFileNames)]
  tempMaxFileNames_rcp85=tempMaxFileNames[grepl("rcp85",tempMaxFileNames)]
  


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
    
    lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(oneDay)))
    names(lonLatGridPlusValue)=c("lon","lat","pr")
    lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
    lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
    lonLatGridPlusValue$pr=as.numeric(as.character(lonLatGridPlusValue$pr))
    write_json(lonLatGridPlusValue,imgName)

}

for(j in 1:length(prFileNames_rcp45)){
  ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/pr/",prFileNames_rcp45[j],sep="")
  ncin <- nc_open(ncname)
  precip45 <- ncvar_get(ncin,"pr")
  nc_close(ncin)

    toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/pr/",sep="")
    imgName=paste(prFileNames_rcp45[j],"_yearMean",".json",sep="")
    setwd(toSavePath)

    oneDay=apply(precip45,c(1,2),mean,na.rm=T)
    
    lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(oneDay)))
    names(lonLatGridPlusValue)=c("lon","lat","pr")
    lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
    lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
    lonLatGridPlusValue$pr=as.numeric(as.character(lonLatGridPlusValue$pr))
    write_json(lonLatGridPlusValue,imgName)
    
  }
  


for(j in 1:length(prFileNames_rcp85)){
  ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/pr/",prFileNames_rcp85[j],sep="")
  ncin <- nc_open(ncname)
  precip85 <- ncvar_get(ncin,"pr")
  nc_close(ncin)
  
  
    toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/pr/",sep="")
    imgName=paste(prFileNames_rcp85[j],"_yearMean",".json",sep="")
    setwd(toSavePath)
    ## make image
    oneDay=apply(precip85,c(1,2),mean,na.rm=T)
    
    lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(oneDay)))
    names(lonLatGridPlusValue)=c("lon","lat","pr")
    lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
    lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
    lonLatGridPlusValue$pr=as.numeric(as.character(lonLatGridPlusValue$pr))
    write_json(lonLatGridPlusValue,imgName)
    
  }


for(j in 1:length(tempMinFileNames_hist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmin/",tempMinFileNames_hist[j],sep="")
  ncin <- nc_open(ncname)
  tempMinHist <- ncvar_get(ncin,"tasmin")

  nc_close(ncin)

    toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
    imgName=paste(tempMinFileNames_hist[j],"yearMean",".json",sep="")
    setwd(toSavePath)

    oneDay=apply(tempMinHist,c(1,2),mean,na.rm=T)
    
    lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(oneDay)))
    names(lonLatGridPlusValue)=c("lon","lat","tasmin")
    lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
    lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
    lonLatGridPlusValue$tasmin=as.numeric(as.character(lonLatGridPlusValue$tasmin))
    write_json(lonLatGridPlusValue,imgName)
    
  }


for(j in 1:length(tempMinFileNames_rcp45)){
  ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp45[j],sep="")
  ncin <- nc_open(ncname)
  tempMin45 <- ncvar_get(ncin,"tasmin")
  ## need to do for tmax, tmin, see what they are called
  nc_close(ncin)
  
  
    toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmin/",sep="")
    imgName=paste(tempMinFileNames_rcp45[j],"yearMean",".json",sep="")
    setwd(toSavePath)
    oneDay=apply(tempMin45,c(1,2),mean,na.rm=T)
    
    lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(oneDay)))
    names(lonLatGridPlusValue)=c("lon","lat","tasmin")
    lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
    lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
    lonLatGridPlusValue$tasmin=as.numeric(as.character(lonLatGridPlusValue$tasmin))
    write_json(lonLatGridPlusValue,imgName)
  }


for(j in 1:length(tempMinFileNames_rcp85)){
  ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp85[j],sep="")
  ncin <- nc_open(ncname)
  tempMin85 <- ncvar_get(ncin,"tasmin")
  nc_close(ncin)
  
  
    toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmin/",sep="")
    imgName=paste(tempMinFileNames_rcp85[j],"yearMean",".json",sep="")
    setwd(toSavePath)
    oneDay=apply(tempMin85,c(1,2),mean,na.rm=T)
    
    lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(oneDay)))
    names(lonLatGridPlusValue)=c("lon","lat","tasmin")
    lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
    lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
    lonLatGridPlusValue$tasmin=as.numeric(as.character(lonLatGridPlusValue$tasmin))
    write_json(lonLatGridPlusValue,imgName)
  }


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
    
    lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(oneDay)))
    names(lonLatGridPlusValue)=c("lon","lat","tasmax")
    lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
    lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
    lonLatGridPlusValue$tasmax=as.numeric(as.character(lonLatGridPlusValue$tasmax))
    write_json(lonLatGridPlusValue,imgName)
  }


for(j in 1:length(tempMaxFileNames_rcp45)){
  ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp45[j],sep="")
  ncin <- nc_open(ncname)
  tempMax45 <- ncvar_get(ncin,"tasmax")
  ## need to do for tmax, tmin, see what they are called
  nc_close(ncin)
  
    toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmax/",sep="")
    imgName=paste(tempMaxFileNames_rcp45[j],"yearMean",".json",sep="")
    setwd(toSavePath)
    oneDay=apply(tempMax45,c(1,2),mean,na.rm=T)
    
    lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(oneDay)))
    names(lonLatGridPlusValue)=c("lon","lat","tasmax")
    lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
    lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
    lonLatGridPlusValue$tasmax=as.numeric(as.character(lonLatGridPlusValue$tasmax))
    write_json(lonLatGridPlusValue,imgName)
    
  }


for(j in 1:length(tempMaxFileNames_rcp85)){
  ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp85[j],sep="")
  ncin <- nc_open(ncname)
  tempMax85 <- ncvar_get(ncin,"tasmax")
  ## need to do for tmax, tmin, see what they are called
  nc_close(ncin)
  
    toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmax/",sep="")
    imgName=paste(tempMaxFileNames_rcp85[j],"yearMean",".json",sep="")
    setwd(toSavePath)
    oneDay=apply(tempMax85,c(1,2),mean,na.rm=T)
    
    lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(oneDay)))
    names(lonLatGridPlusValue)=c("lon","lat","tasmax")
    lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
    lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
    lonLatGridPlusValue$tasmax=as.numeric(as.character(lonLatGridPlusValue$tasmax))
    write_json(lonLatGridPlusValue,imgName)
}


}
## actually want to save as a csv now

test=array(rnorm(2*2*3,0,1),c(2,2,3))

apply(apply(test,c(1,2),diff),c(1,2),mean) ##mean of differences between successive years
apply(apply(test,c(1,2),diff),c(1,2),sd)   ## sd of differences between successive years


####### two summaries per tag #####

require(ncdf4)
require(RSvgDevice)
require(RColorBrewer)
require(maps)

## path before rawdata, no ending backslash
yourPathToData=""
wdGit="~/Desktop/UCB_DS421_NEX_partnerProject"
setwd(wdGit)

tagList<-read.csv("tags.csv",stringsAsFactors=F,header=F) ## get tagList for different models

nex_climate_filenames <- read.table("nex_climate_filenames.txt", 
                                    quote="\"", comment.char="") ## get all file names

filesPertagList=vector("list",nrow(tagList))
for(i in 1:nrow(tagList)){
  filesPertagList[[i]]=nex_climate_filenames[grepl(tagList[i,1],nex_climate_filenames[,1]),1]
} ## get files per tag


lon=read.csv("lon.csv",stringsAsFactors=F)[,1]
lat=read.csv("lat.csv",stringsAsFactors=F)[,1]

lonLatGrid=expand.grid(lon[,1],lat[,1])
quantAvgAllPrHist=quantSDAllPrHist=c()
quantAvgAllMinTempHist=quantSDAllMinTempHist=c()
quantAvgAllMaxTempHist=quantSDAllMaxTempHist=c()

quantAvgAllPr45=quantSDAllPr45=c()
quantAvgAllMinTemp45=quantSDAllMinTemp45=c()
quantAvgAllMaxTemp45=quantSDAllMaxTemp45=c()

quantAvgAllPr85=quantSDAllPr85=c()
quantAvgAllMinTemp85=quantSDAllMinTemp85=c()
quantAvgAllMaxTemp85=quantSDAllMaxTemp85=c()

for(i in 1:nrow(tagList)){
  
  ## split by type of data
  
  prFileNames=filesPertagList[[i]][grepl("pr_",filesPertagList[[i]])]
  tempMinFileNames=filesPertagList[[i]][grepl("tasmin_",filesPertagList[[i]])]
  tempMaxFileNames=filesPertagList[[i]][grepl("tasmax_",filesPertagList[[i]])]
  
  ## split by historical, rcp45, rcp85
  
  prFileNames_hist=prFileNames[grepl("historical",prFileNames)]
  prFileNames_rcp45=prFileNames[grepl("rcp45",prFileNames)]
  prFileNames_rcp85=prFileNames[grepl("rcp85",prFileNames)]
  
  tempMinFileNames_hist=tempMinFileNames[grepl("historical",tempMinFileNames)]
  tempMinFileNames_rcp45=tempMinFileNames[grepl("rcp45",tempMinFileNames)]
  tempMinFileNames_rcp85=tempMinFileNames[grepl("rcp85",tempMinFileNames)]
  
  tempMaxFileNames_hist=tempMaxFileNames[grepl("historical",tempMaxFileNames)]
  tempMaxFileNames_rcp45=tempMaxFileNames[grepl("rcp45",tempMaxFileNames)]
  tempMaxFileNames_rcp85=tempMaxFileNames[grepl("rcp85",tempMaxFileNames)]
  
  
  prHistYr=array(0,c(1440,720,length(prFileNames_hist)))
  for(j in 1:length(prFileNames_hist)){
    ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/pr/",prFileNames_hist[j],sep="")
    
    ncin <- nc_open(ncname)
    
    precipHist <- ncvar_get(ncin,"pr")
    ## need to double check for tmax, tmin, see what they are called
    nc_close(ncin)
    
    #toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/pr/",sep="")
    #imgName=paste(prFileNames_hist[j],"_yearMean",".json",sep="")
    #setwd(toSavePath)
    
    oneDay=apply(precipHist,c(1,2),mean,na.rm=T)
    
    prHistYr[,,j]=oneDay
    
  }
  diffAcrossYears=apply(prHistYr,c(1,2),diff)
  avgDiff=apply(diffAcrossYears,c(2,3),mean,na.rm=T) ##mean of differences between successive years
  sdDiff=apply(diffAcrossYears,c(2,3),sd,na.rm=T)   ## sd of differences between successive years
  
  quantAvg=quantile(c(avgDiff),seq(0,1,by=.1),na.rm=T)
  quantSD=quantile(c(sdDiff),seq(0,1,by=.1),na.rm=T)
  
  quantAvgAllPrHist=rbind(quantAvgAllPrHist,quantAvg)
  quantSDAllPrHist=rbind(quantSDAllPrHist,quantSD)
  
  avgDiffCol=cut(c(avgDiff),quantAvg)
  sdDiffCol=cut(c(sdDiff),quantSD)
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=avgDiffCol
  lonLatGridPlusValue$sdDiffCol=sdDiffCol
  nameSave=paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/pr/","aggResults.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)

  pr45Yr=array(0,c(1440,720,length(prFileNames_rcp45)))
  for(j in 1:length(prFileNames_rcp45)){
    ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/pr/",prFileNames_rcp45[j],sep="")
    ncin <- nc_open(ncname)
    precip45 <- ncvar_get(ncin,"pr")
    nc_close(ncin)
    
    #toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/pr/",sep="")
    #imgName=paste(prFileNames_rcp45[j],"_yearMean",".json",sep="")
    #setwd(toSavePath)
    
    oneDay=apply(precip45,c(1,2),mean,na.rm=T)
    
    pr45Yr[,,j]=oneDay
    
  }
  diffAcrossYears=apply(pr45Yr,c(1,2),diff)
  avgDiff=apply(diffAcrossYears,c(2,3),mean,na.rm=T) ##mean of differences between successive years
  sdDiff=apply(diffAcrossYears,c(2,3),sd,na.rm=T)   ## sd of differences between successive years
  
  quantAvg=quantile(c(avgDiff),seq(0,1,by=.1),na.rm=T)
  quantSD=quantile(c(sdDiff),seq(0,1,by=.1),na.rm=T)
  
  quantAvgAllPr45=rbind(quantAvgAllPr45,quantAvg)
  quantSDAllPr45=rbind(quantSDAllPr45,quantSD)
  
  avgDiffCol=cut(c(avgDiff),quantAvg)
  sdDiffCol=cut(c(sdDiff),quantSD)
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=avgDiffCol
  lonLatGridPlusValue$sdDiffCol=sdDiffCol
  nameSave=paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/pr/","aggResults.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
  pr85Yr=array(0,c(1440,720,length(prFileNames_rcp85)))
  for(j in 1:length(prFileNames_rcp85)){
    ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/pr/",prFileNames_rcp85[j],sep="")
    ncin <- nc_open(ncname)
    precip85 <- ncvar_get(ncin,"pr")
    nc_close(ncin)
    
    
    #toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/pr/",sep="")
    #imgName=paste(prFileNames_rcp85[j],"_yearMean",".json",sep="")
    #setwd(toSavePath)
    ## make image
    oneDay=apply(precip85,c(1,2),mean,na.rm=T)
    
    pr85Yr[,,j]=oneDay
    
  }
  diffAcrossYears=apply(pr85Yr,c(1,2),diff)
  avgDiff=apply(diffAcrossYears,c(2,3),mean,na.rm=T) ##mean of differences between successive years
  sdDiff=apply(diffAcrossYears,c(2,3),sd,na.rm=T)   ## sd of differences between successive years
  
  quantAvg=quantile(c(avgDiff),seq(0,1,by=.1),na.rm=T)
  quantSD=quantile(c(sdDiff),seq(0,1,by=.1),na.rm=T)
  
  quantAvgAllPr85=rbind(quantAvgAllPr85,quantAvg)
  quantSDAllPr85=rbind(quantSDAllPr85,quantSD)
  
  avgDiffCol=cut(c(avgDiff),quantAvg)
  sdDiffCol=cut(c(sdDiff),quantSD)
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=avgDiffCol
  lonLatGridPlusValue$sdDiffCol=sdDiffCol
  nameSave=paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/pr/","aggResults.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
  tempMinHistYr=array(0,c(1440,720,length(tempMinFileNames_hist)))
  for(j in 1:length(tempMinFileNames_hist)){
    ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmin/",tempMinFileNames_hist[j],sep="")
    ncin <- nc_open(ncname)
    tempMinHist <- ncvar_get(ncin,"tasmin")
    
    nc_close(ncin)
    
    #toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
    #imgName=paste(tempMinFileNames_hist[j],"yearMean",".json",sep="")
    #setwd(toSavePath)
    
    oneDay=apply(tempMinHist,c(1,2),mean,na.rm=T)
    
    tempMinHistYr[,,j]=oneDay
    
  }
  diffAcrossYears=apply(tempMinHistYr,c(1,2),diff)
  avgDiff=apply(diffAcrossYears,c(2,3),mean,na.rm=T) ##mean of differences between successive years
  sdDiff=apply(diffAcrossYears,c(2,3),sd,na.rm=T)   ## sd of differences between successive years
  quantAvg=quantile(c(avgDiff),seq(0,1,by=.1),na.rm=T)
  quantSD=quantile(c(sdDiff),seq(0,1,by=.1),na.rm=T)
  
  quantAvgAllMinTempHist=rbind(quantAvgAllMinTempHist,quantAvg)
  quantSDAllMinTempHist=rbind(quantSDAllMinTempHist,quantSD)
  
  avgDiffCol=cut(c(avgDiff),quantAvg)
  sdDiffCol=cut(c(sdDiff),quantSD)
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=avgDiffCol
  lonLatGridPlusValue$sdDiffCol=sdDiffCol
  nameSave=paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmin/","aggResults.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
  tempMin45Yr=array(0,c(1440,720,length(tempMinFileNames_rcp45)))
  for(j in 1:length(tempMinFileNames_rcp45)){
    ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp45[j],sep="")
    ncin <- nc_open(ncname)
    tempMin45 <- ncvar_get(ncin,"tasmin")
    ## need to do for tmax, tmin, see what they are called
    nc_close(ncin)
    
    
    #toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmin/",sep="")
    #imgName=paste(tempMinFileNames_rcp45[j],"yearMean",".json",sep="")
    #setwd(toSavePath)
    oneDay=apply(tempMin45,c(1,2),mean,na.rm=T)
    
    tempMin45Yr[,,j]=oneDay
    
  }
  diffAcrossYears=apply(tempMin45Yr,c(1,2),diff)
  avgDiff=apply(diffAcrossYears,c(2,3),mean,na.rm=T) ##mean of differences between successive years
  sdDiff=apply(diffAcrossYears,c(2,3),sd,na.rm=T)   ## sd of differences between successive years
  quantAvg=quantile(c(avgDiff),seq(0,1,by=.1),na.rm=T)
  quantSD=quantile(c(sdDiff),seq(0,1,by=.1),na.rm=T)
  
  quantAvgAllMinTemp45=rbind(quantAvgAllMinTemp45,quantAvg)
  quantSDAllMinTemp45=rbind(quantSDAllMinTemp45,quantSD)
  
  avgDiffCol=cut(c(avgDiff),quantAvg)
  sdDiffCol=cut(c(sdDiff),quantSD)
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=avgDiffCol
  lonLatGridPlusValue$sdDiffCol=sdDiffCol
  nameSave=paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmin/","aggResults.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
  tempMin85Yr=array(0,c(1440,720,length(tempMinFileNames_rcp85)))
  
  for(j in 1:length(tempMinFileNames_rcp85)){
    ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp85[j],sep="")
    ncin <- nc_open(ncname)
    tempMin85 <- ncvar_get(ncin,"tasmin")
    nc_close(ncin)
    
    
    #toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmin/",sep="")
    #imgName=paste(tempMinFileNames_rcp85[j],"yearMean",".json",sep="")
    #setwd(toSavePath)
    oneDay=apply(tempMin85,c(1,2),mean,na.rm=T)
    
    tempMin85Yr[,,j]=oneDay
    
  }
  diffAcrossYears=apply(tempMin85Yr,c(1,2),diff)
  avgDiff=apply(diffAcrossYears,c(2,3),mean,na.rm=T) ##mean of differences between successive years
  sdDiff=apply(diffAcrossYears,c(2,3),sd,na.rm=T)   ## sd of differences between successive years
  quantAvg=quantile(c(avgDiff),seq(0,1,by=.1),na.rm=T)
  quantSD=quantile(c(sdDiff),seq(0,1,by=.1),na.rm=T)
  
  quantAvgAllMinTemp85=rbind(quantAvgAllMinTemp85,quantAvg)
  quantSDAllMinTemp85=rbind(quantSDAllMinTemp85,quantSD)
  
  avgDiffCol=cut(c(avgDiff),quantAvg)
  sdDiffCol=cut(c(sdDiff),quantSD)
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=avgDiffCol
  lonLatGridPlusValue$sdDiffCol=sdDiffCol
  nameSave=paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmin/","aggResults.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
  tempMaxHistYr=array(0,c(1440,720,length(tempMaxFileNames_hist)))
  
  for(j in 1:length(tempMaxFileNames_hist)){
    ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmax/",tempMaxFileNames_hist[j],sep="")
    ncin <- nc_open(ncname)
    tempMaxHist <- ncvar_get(ncin,"tasmax")
    ## need to do for tmax, tmin, see what they are called
    nc_close(ncin)
    
    #toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmax/",sep="")
    #imgName=paste(tempMaxFileNames_hist[j],"yearMean",".json",sep="")
    #setwd(toSavePath)
    ## make image
    oneDay=apply(tempMaxHist,c(1,2),mean,na.rm=T)
    
    tempMaxHistYr[,,j]=oneDay
    
  }
  diffAcrossYears=apply(tempMaxHistYr,c(1,2),diff)
  avgDiff=apply(diffAcrossYears,c(2,3),mean,na.rm=T) ##mean of differences between successive years
  sdDiff=apply(diffAcrossYears,c(2,3),sd,na.rm=T)   ## sd of differences between successive years
  quantAvg=quantile(c(avgDiff),seq(0,1,by=.1),na.rm=T)
  quantSD=quantile(c(sdDiff),seq(0,1,by=.1),na.rm=T)
  
  quantAvgAllMaxTempHist=rbind(quantAvgAllMaxTempHist,quantAvg)
  quantSDAllMaxTempHist=rbind(quantSDAllMaxTempHist,quantSD)
  
  avgDiffCol=cut(c(avgDiff),quantAvg)
  sdDiffCol=cut(c(sdDiff),quantSD)
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=avgDiffCol
  lonLatGridPlusValue$sdDiffCol=sdDiffCol
  nameSave=paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmax/","aggResults.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
  
  tempMax45Yr=array(0,c(1440,720,length(tempMaxFileNames_rcp45)))
  
  for(j in 1:length(tempMaxFileNames_rcp45)){
    ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp45[j],sep="")
    ncin <- nc_open(ncname)
    tempMax45 <- ncvar_get(ncin,"tasmax")
    ## need to do for tmax, tmin, see what they are called
    nc_close(ncin)
    
    #toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmax/",sep="")
    #imgName=paste(tempMaxFileNames_rcp45[j],"yearMean",".json",sep="")
    #setwd(toSavePath)
    oneDay=apply(tempMax45,c(1,2),mean,na.rm=T)
    tempMax45Yr[,,j]=oneDay
    
  }
  diffAcrossYears=apply(tempMax45Yr,c(1,2),diff)
  avgDiff=apply(diffAcrossYears,c(2,3),mean,na.rm=T) ##mean of differences between successive years
  sdDiff=apply(diffAcrossYears,c(2,3),sd,na.rm=T)   ## sd of differences between successive years
  
  quantAvg=quantile(c(avgDiff),seq(0,1,by=.1),na.rm=T)
  quantSD=quantile(c(sdDiff),seq(0,1,by=.1),na.rm=T)
  
  quantAvgAllMaxTemp45=rbind(quantAvgAllMaxTemp45,quantAvg)
  quantSDAllMaxTemp45=rbind(quantSDAllMaxTemp45,quantSD)
  
  avgDiffCol=cut(c(avgDiff),quantAvg)
  sdDiffCol=cut(c(sdDiff),quantSD)
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=avgDiffCol
  lonLatGridPlusValue$sdDiffCol=sdDiffCol
  nameSave=paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmax/","aggResults.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
  tempMax85Yr=array(0,c(1440,720,length(tempMaxFileNames_rcp85)))
  
  for(j in 1:length(tempMaxFileNames_rcp85)){
    ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp85[j],sep="")
    ncin <- nc_open(ncname)
    tempMax85 <- ncvar_get(ncin,"tasmax")
    ## need to do for tmax, tmin, see what they are called
    nc_close(ncin)
    
    #toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmax/",sep="")
    #imgName=paste(tempMaxFileNames_rcp85[j],"yearMean",".json",sep="")
    #setwd(toSavePath)
    oneDay=apply(tempMax85,c(1,2),mean,na.rm=T)
    
    tempMax85Yr[,,j]=oneDay
    
  }
  diffAcrossYears=apply(tempMax85Yr,c(1,2),diff)
  avgDiff=apply(diffAcrossYears,c(2,3),mean,na.rm=T) ##mean of differences between successive years
  sdDiff=apply(diffAcrossYears,c(2,3),sd,na.rm=T)   ## sd of differences between successive years
  
  quantAvg=quantile(c(avgDiff),seq(0,1,by=.1),na.rm=T)
  quantSD=quantile(c(sdDiff),seq(0,1,by=.1),na.rm=T)
  
  
  quantAvgAllMaxTemp85=rbind(quantAvgAllMaxTemp85,quantAvg)
  quantSDAllMaxTemp85=rbind(quantSDAllMaxTemp85,quantSD)
  
  avgDiffCol=cut(c(avgDiff),quantAvg)
  sdDiffCol=cut(c(sdDiff),quantSD)
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=avgDiffCol
  lonLatGridPlusValue$sdDiffCol=sdDiffCol
  nameSave=paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmax/","aggResults.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
  
}

gitHubDir=""
setwd(gitHubDir)

write.csv(quantAvgAllPrHist,"quantilesPrHistAggAvg.csv",row.names=F)
write.csv(quantAvgAllPr45,"quantilesPr45AggAvg.csv",row.names=F)
write.csv(quantAvgAllPr85,"quantilesPr85AggAvg.csv",row.names=F)

write.csv(quantSDAllPrHist,"quantilesPrHistAggSD.csv",row.names=F)
write.csv(quantSDAllPr45,"quantilesPrHistAggSD.csv",row.names=F)
write.csv(quantSDAllPr85,"quantilesPrHistAggSD.csv",row.names=F)


write.csv(quantAvgAllMinTempHist,"quantilesMinTempHistAggAvg.csv",row.names=F)
write.csv(quantAvgAllMinTemp45,"quantilesMinTemp45AggAvg.csv",row.names=F)
write.csv(quantAvgAllMinTemp85,"quantilesMinTemp85AggAvg.csv",row.names=F)

write.csv(quantSDAllMinTempHist,"quantilesMinTempHistAggSD.csv",row.names=F)
write.csv(quantSDAllMinTemp45,"quantilesMinTempHistAggSD.csv",row.names=F)
write.csv(quantSDAllMinTemp85,"quantilesMinTempHistAggSD.csv",row.names=F)


write.csv(quantAvgAllMaxTempHist,"quantilesMaxTempHistAggAvg.csv",row.names=F)
write.csv(quantAvgAllMaxTemp45,"quantilesMaxTemp45AggAvg.csv",row.names=F)
write.csv(quantAvgAllMaxTemp85,"quantilesMaxTemp85AggAvg.csv",row.names=F)

write.csv(quantSDAllMaxTempHist,"quantilesMaxTempHistAggSD.csv",row.names=F)
write.csv(quantSDAllMaxTemp45,"quantilesMaxTempHistAggSD.csv",row.names=F)
write.csv(quantSDAllMaxTemp85,"quantilesMaxTempHistAggSD.csv",row.names=F)

##### make legends ####

require(RColorBrewer)
require(R2BayesX)
library(RSvgDevice)

for(i in 1:nrow(tagList)){
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/pr/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_prHistLegendAggAvg.svg",sep="")
  toPlot=quantAvgAllPrHist[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  imgName=paste(tagList[i,1],"_prHistLegendAggSD.svg",sep="")
  toPlot=quantSDAllPrHist[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/pr/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_pr45LegendAggAvg.svg",sep="")
  toPlot=quantAvgAllPr45[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  imgName=paste(tagList[i,1],"_pr45LegendAggSD.svg",sep="")
  toPlot=quantSDAllPr45[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/pr/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_pr85LegendAggAvg.svg",sep="")
  toPlot=quantAvgAllPr85[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  imgName=paste(tagList[i,1],"_pr85LegendAggSD.svg",sep="")
  toPlot=quantSDAllPr85[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_minTempHistLegendAggAvg.svg",sep="")
  toPlot=quantAvgAllMinTempHist[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  imgName=paste(tagList[i,1],"_minTempHistLegendAggSD.svg",sep="")
  toPlot=quantSDAllMinTempHist[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmin/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_minTemp45LegendAggAvg.svg",sep="")
  toPlot=quantAvgAllMinTemp45[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  imgName=paste(tagList[i,1],"_minTemp45LegendAggSD.svg",sep="")
  toPlot=quantSDAllMinTemp45[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmin/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_minTemp85LegendAggAvg.svg",sep="")
  toPlot=quantAvgAllMinTemp85[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  imgName=paste(tagList[i,1],"_minTemp85LegendAggSD.svg",sep="")
  toPlot=quantSDAllMinTemp85[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmax/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_maxTempHistLegendAggAvg.svg",sep="")
  toPlot=quantAvgAllMaxTempHist[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  imgName=paste(tagList[i,1],"_maxTempHistLegendAggSD.svg",sep="")
  toPlot=quantSDAllMaxTempHist[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmax/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_maxTemp45LegendAggAvg.svg",sep="")
  toPlot=quantAvgAllMaxTemp45[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  imgName=paste(tagList[i,1],"_maxTemp85LegendAggSD.svg",sep="")
  toPlot=quantAvgAllMaxTemp45[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmax/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_maxTemp85LegendAggAvg.svg",sep="")
  toPlot=quantAvgAllMaxTemp85[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  imgName=paste(tagList[i,1],"_maxTemp85LegendAggSD.svg",sep="")
  toPlot=quantSDAllMaxTemp85[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  
}

