####### two summaries per tag #####

require(ncdf4)
require(RSvgDevice)
require(RColorBrewer)
require(maps)
require(MASS)

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

lonLatGrid=expand.grid(lon,lat)
quantAvgAllPrHist=quantSDAllPrHist=c()
quantAvgAllMinTempHist=quantSDAllMinTempHist=c()
quantAvgAllMaxTempHist=quantSDAllMaxTempHist=c()

quantAvgAllPr45=quantSDAllPr45=c()
quantAvgAllMinTemp45=quantSDAllMinTemp45=c()
quantAvgAllMaxTemp45=quantSDAllMaxTemp45=c()

quantAvgAllPr85=quantSDAllPr85=c()
quantAvgAllMinTemp85=quantSDAllMinTemp85=c()
quantAvgAllMaxTemp85=quantSDAllMaxTemp85=c()
i=15

  ## split by type of data
  
  prFileNames=filesPertagList[[i]][grepl("pr_",filesPertagList[[i]])]
  tempMinFileNames=filesPertagList[[i]][grepl("tasmin_",filesPertagList[[i]])]
  tempMaxFileNames=filesPertagList[[i]][grepl("tasmax_",filesPertagList[[i]])]
  
  ## split by rcp45, rcp85
  
  prFileNames_rcp45=prFileNames[grepl("rcp45",prFileNames)]
  prFileNames_rcp85=prFileNames[grepl("rcp85",prFileNames)]
  
  tempMinFileNames_rcp45=tempMinFileNames[grepl("rcp45",tempMinFileNames)]
  tempMinFileNames_rcp85=tempMinFileNames[grepl("rcp85",tempMinFileNames)]
  
  tempMaxFileNames_rcp45=tempMaxFileNames[grepl("rcp45",tempMaxFileNames)]
  tempMaxFileNames_rcp85=tempMaxFileNames[grepl("rcp85",tempMaxFileNames)]
  
  x=seq(2006,2100,by=1)
  
  robustLM=function(y,x){
    test=rlm(y~x)
    return(unname(coefficients(test)[2]))
  }
  
  
  pr45Yr=array(0,c(1440,720,length(prFileNames_rcp45)))
  for(j in 1:length(prFileNames_rcp45)){
    ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/pr/",prFileNames_rcp45[j],sep="")
    ncin <- nc_open(ncname)
    precip45 <- ncvar_get(ncin,"pr")
    nc_close(ncin)
    
    
    oneDay=apply(precip45,c(1,2),mean,na.rm=T)
    
    pr45Yr[,,j]=oneDay
    
  }
  ## is this what I want?
  apply(pr45Yr,3,robustLM,x)
  apply(pr45Yr,3,sd)
  
  
  
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
    print(j)
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
  col=c("black",rev(brewer.pal(9,"Purples")))
  testCol=col[as.numeric(avgDiffCol)]
  testCol[is.na(testCol)]="green"
  
  testCol2=col[as.numeric(sdDiffCol)]
  testCol2[is.na(testCol2)]="green"
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=as.character(testCol)
  lonLatGridPlusValue$sdDiffCol=as.character(testCol2)
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
  ptm <- proc.time()
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
    print(j)
  }
  proc.time() - ptm ## 2741.494 ## 45 minutes
  diffAcrossYears=apply(tempMaxHistYr,c(1,2),diff)
  avgDiff=apply(diffAcrossYears,c(2,3),mean,na.rm=T) ##mean of differences between successive years
  sdDiff=apply(diffAcrossYears,c(2,3),sd,na.rm=T)   ## sd of differences between successive years
  quantAvg=quantile(c(avgDiff),seq(0,1,by=.1),na.rm=T)
  #0%          10%          20%          30%          40%          50%          60%          70%          80% 
  #-0.068202411 -0.006062361  0.002386491  0.007871585  0.011943221  0.016031125  0.020668690  0.026385084  0.034669317 
  #90%         100% 
  #  0.051657164  0.133763378 
  quantSD=quantile(c(sdDiff),seq(0,1,by=.1),na.rm=T)
  # 0%       10%       20%       30%       40%       50%       60%       70%       80%       90%      100% 
  #0.1761529 0.4663317 0.5432861 0.6078010 0.6763409 0.7639354 0.8753163 0.9821325 1.1092197 1.2822268 2.1060257 
  
  quantAvgAllMaxTempHist=rbind(quantAvgAllMaxTempHist,quantAvg)
  quantSDAllMaxTempHist=rbind(quantSDAllMaxTempHist,quantSD)
  
  avgDiffCol=cut(c(avgDiff),quantAvg)
  sdDiffCol=cut(c(sdDiff),quantSD)
  col=c(brewer.pal(9,"YlOrRd"),"black")
  testCol=col[as.numeric(avgDiffCol)]
  testCol[is.na(testCol)]="purple"
  
  testCol2=col[as.numeric(sdDiffCol)]
  testCol2[is.na(testCol2)]="purple"
  
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  lonLatGridPlusValue$avgDiffCol=as.character(testCol)
  lonLatGridPlusValue$sdDiffCol=as.character(testCol2)
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
