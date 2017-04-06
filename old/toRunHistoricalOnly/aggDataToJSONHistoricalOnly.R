####### two summaries per tag #####

## set GitHub directory to read in some files
gitHubDir="~/Desktop/UCB_DS421_NEX_partnerProject"
setwd(gitHubDir)
lon=read.csv("lon.csv",stringsAsFactors=F)
lat=read.csv("lat.csv",stringsAsFactors=F)
lonLatGrid=expand.grid(lon[,1],lat[,1])
quantAvgAllPrHist=quantSDAllPrHist=c()
quantAvgAllMinTempHist=quantSDAllMinTempHist=c()
quantAvgAllMaxTempHist=quantSDAllMaxTempHist=c()

# quantAvgAllPr45=quantSDAllPr45=c()
# quantAvgAllMinTemp45=quantSDAllMinTemp45=c()
# quantAvgAllMaxTemp45=quantSDAllMaxTemp45=c()
# 
# quantAvgAllPr85=quantSDAllPr85=c()
# quantAvgAllMinTemp85=quantSDAllMinTemp85=c()
# quantAvgAllMaxTemp85=quantSDAllMaxTemp85=c()

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
  prHistYr=array(0,c(1440,720,length(prFileNames_hist)))
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
    
    prHistYr[,,j]=oneDay
    print(paste("precip file",j,sep=" "))
    
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
  proc.time() - ptm ## errored out after loop though 2044.132 (35 minutes ish)
  
  # pr45Yr=array(0,c(1440,720,length(prFileNames_rcp45)))
  # for(j in 1:length(prFileNames_rcp45)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/pr/",prFileNames_rcp45[j],sep="")
  #   ncin <- nc_open(ncname)
  #   precip45 <- ncvar_get(ncin,"pr")
  #   nc_close(ncin)
  #   
  #   toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/pr/",sep="")
  #   imgName=paste(prFileNames_rcp45[j],"_yearMean",".json",sep="")
  #   setwd(toSavePath)
  #   
  #   oneDay=apply(precip45,c(1,2),mean,na.rm=T)
  #   
  #   pr45Yr[,,j]=oneDay
  #   
  # }
  # diffAcrossYears=apply(pr45Yr,c(1,2),diff)
  # avgDiff=apply(diffAcrossYears,c(1,2),mean) ##mean of differences between successive years
  # sdDiff=apply(diffAcrossYears,c(1,2),sd)   ## sd of differences between successive years
  # 
  # quantAvg=quantile(c(avgDiff),seq(0,1,by=.1))
  # quantSD=quantile(c(sdDiff),seq(0,1,by=.1))
  # 
  # quantAvgAllPr45=rbind(quantAvgAllPr45,quantAvg)
  # quantSDAllPr45=rbind(quantSDAllPr45,quantSD)
  # 
  # avgDiffCol=cut(c(avgDiff),quantAvg)
  # sdDiffCol=cut(c(sdDiff),quantSD)
  # 
  # 
  # lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  # names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  # lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  # lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  # lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  # lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  # lonLatGridPlusValue$avgDiffCol=avgDiffCol
  # lonLatGridPlusValue$sdDiffCol=sdDiffCol
  # nameSave=paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/pr/","aggResults.csv",sep="")
  # write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  # 
  # pr85Yr=array(0,c(1440,720,length(prFileNames_rcp85)))
  # for(j in 1:length(prFileNames_rcp85)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/pr/",prFileNames_rcp85[j],sep="")
  #   ncin <- nc_open(ncname)
  #   precip85 <- ncvar_get(ncin,"pr")
  #   nc_close(ncin)
  #   
  #   
  #   toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/pr/",sep="")
  #   imgName=paste(prFileNames_rcp85[j],"_yearMean",".json",sep="")
  #   setwd(toSavePath)
  #   ## make image
  #   oneDay=apply(precip85,c(1,2),mean,na.rm=T)
  #   
  #   pr85Yr[,,j]=oneDay
  #   
  # }
  # diffAcrossYears=apply(pr85Yr,c(1,2),diff)
  # avgDiff=apply(diffAcrossYears,c(1,2),mean) ##mean of differences between successive years
  # sdDiff=apply(diffAcrossYears,c(1,2),sd)   ## sd of differences between successive years
  # 
  # quantAvg=quantile(c(avgDiff),seq(0,1,by=.1))
  # quantSD=quantile(c(sdDiff),seq(0,1,by=.1))
  # 
  # quantAvgAllPr85=rbind(quantAvgAllPr85,quantAvg)
  # quantSDAllPr85=rbind(quantSDAllPr85,quantSD)
  # 
  # avgDiffCol=cut(c(avgDiff),quantAvg)
  # sdDiffCol=cut(c(sdDiff),quantSD)
  # 
  # 
  # lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  # names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  # lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  # lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  # lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  # lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  # lonLatGridPlusValue$avgDiffCol=avgDiffCol
  # lonLatGridPlusValue$sdDiffCol=sdDiffCol
  # nameSave=paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/pr/","aggResults.csv",sep="")
  # write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  # 
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
    
    tempMinHistYr[,,j]=oneDay
    print(paste("min temp file",j,sep=" "))
    
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
  proc.time() - ptm
  # tempMin45Yr=array(0,c(1440,720,length(tempMinFileNames_rcp45)))
  # for(j in 1:length(tempMinFileNames_rcp45)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp45[j],sep="")
  #   ncin <- nc_open(ncname)
  #   tempMin45 <- ncvar_get(ncin,"tasmin")
  #   ## need to do for tmax, tmin, see what they are called
  #   nc_close(ncin)
  #   
  #   
  #   toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmin/",sep="")
  #   imgName=paste(tempMinFileNames_rcp45[j],"yearMean",".json",sep="")
  #   setwd(toSavePath)
  #   oneDay=apply(tempMin45,c(1,2),mean,na.rm=T)
  #   
  #   tempMin45Yr[,,j]=oneDay
  #   
  # }
  # diffAcrossYears=apply(tempMin45Yr,c(1,2),diff)
  # avgDiff=apply(diffAcrossYears,c(1,2),mean) ##mean of differences between successive years
  # sdDiff=apply(diffAcrossYears,c(1,2),sd)   ## sd of differences between successive years
  # 
  # quantAvgAllMinTemp45=rbind(quantAvgAllMinTemp45,quantAvg)
  # quantSDAllMinTemp45=rbind(quantSDAllMinTemp45,quantSD)
  # 
  # avgDiffCol=cut(c(avgDiff),quantAvg)
  # sdDiffCol=cut(c(sdDiff),quantSD)
  # 
  # 
  # lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  # names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  # lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  # lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  # lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  # lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  # lonLatGridPlusValue$avgDiffCol=avgDiffCol
  # lonLatGridPlusValue$sdDiffCol=sdDiffCol
  # nameSave=paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmin/","aggResults.csv",sep="")
  # write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  # 
  # tempMin85Yr=array(0,c(1440,720,length(tempMinFileNames_rcp85)))
  # 
  # for(j in 1:length(tempMinFileNames_rcp85)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp85[j],sep="")
  #   ncin <- nc_open(ncname)
  #   tempMin85 <- ncvar_get(ncin,"tasmin")
  #   nc_close(ncin)
  #   
  #   
  #   toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmin/",sep="")
  #   imgName=paste(tempMinFileNames_rcp85[j],"yearMean",".json",sep="")
  #   setwd(toSavePath)
  #   oneDay=apply(tempMin85,c(1,2),mean,na.rm=T)
  #   
  #   tempMin85Yr[,,j]=oneDay
  #   
  # }
  # diffAcrossYears=apply(tempMin85Yr,c(1,2),diff)
  # avgDiff=apply(diffAcrossYears,c(1,2),mean) ##mean of differences between successive years
  # sdDiff=apply(diffAcrossYears,c(1,2),sd)   ## sd of differences between successive years
  # 
  # quantAvgAllMinTemp85=rbind(quantAvgAllMinTemp85,quantAvg)
  # quantSDAllMinTemp85=rbind(quantSDAllMinTemp85,quantSD)
  # 
  # avgDiffCol=cut(c(avgDiff),quantAvg)
  # sdDiffCol=cut(c(sdDiff),quantSD)
  # 
  # 
  # lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  # names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  # lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  # lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  # lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  # lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  # lonLatGridPlusValue$avgDiffCol=avgDiffCol
  # lonLatGridPlusValue$sdDiffCol=sdDiffCol
  # nameSave=paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmin/","aggResults.csv",sep="")
  # write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  # 
  
  ##START HERE, WRITE OVER
  ptm <- proc.time()
  tempMaxHistYr=array(0,c(1440,720,length(tempMaxFileNames_hist)))
  
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
    
    tempMaxHistYr[,,j]=oneDay
    print(paste("max temp file",j,sep=" "))
    
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
  proc.time() - ptm ##  2332.333 almost 40 minutes
  
  quantPr=read.csv(paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/pr/","aggResults.csv",sep=""))
  quantMinTemp=read.csv(paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmin/","aggResults.csv",sep=""))
  quantMaxTemp=read.csv(paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmax/","aggResults.csv",sep=""))
  
  
  # tempMax45HistYr=array(0,c(1440,720,length(tempMaxFileNames_rcp45)))
  # 
  # for(j in 1:length(tempMaxFileNames_rcp45)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp45[j],sep="")
  #   ncin <- nc_open(ncname)
  #   tempMax45 <- ncvar_get(ncin,"tasmax")
  #   ## need to do for tmax, tmin, see what they are called
  #   nc_close(ncin)
  #   
  #   toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmax/",sep="")
  #   imgName=paste(tempMaxFileNames_rcp45[j],"yearMean",".json",sep="")
  #   setwd(toSavePath)
  #   oneDay=apply(tempMax45,c(1,2),mean,na.rm=T)
  #   tempMax45Yr[,,j]=oneDay
  #   
  # }
  # diffAcrossYears=apply(tempMax45Yr,c(1,2),diff)
  # avgDiff=apply(diffAcrossYears,c(1,2),mean) ##mean of differences between successive years
  # sdDiff=apply(diffAcrossYears,c(1,2),sd)   ## sd of differences between successive years
  # quantAvgAllMaxTemp45=rbind(quantAvgAllMaxTemp45,quantAvg)
  # quantSDAllMaxTemp45=rbind(quantSDAllMaxTemp45,quantSD)
  # 
  # avgDiffCol=cut(c(avgDiff),quantAvg)
  # sdDiffCol=cut(c(sdDiff),quantSD)
  # 
  # 
  # lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  # names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  # lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  # lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  # lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  # lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  # lonLatGridPlusValue$avgDiffCol=avgDiffCol
  # lonLatGridPlusValue$sdDiffCol=sdDiffCol
  # nameSave=paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmax/","aggResults.csv",sep="")
  # write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  # 
  # tempMax85HistYr=array(0,c(1440,720,length(tempMaxFileNames_rcp85)))
  # 
  # for(j in 1:length(tempMaxFileNames_rcp85)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp85[j],sep="")
  #   ncin <- nc_open(ncname)
  #   tempMax85 <- ncvar_get(ncin,"tasmax")
  #   ## need to do for tmax, tmin, see what they are called
  #   nc_close(ncin)
  #   
  #   toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmax/",sep="")
  #   imgName=paste(tempMaxFileNames_rcp85[j],"yearMean",".json",sep="")
  #   setwd(toSavePath)
  #   oneDay=apply(tempMax85,c(1,2),mean,na.rm=T)
  #   
  #   tempMax85Yr[,,j]=oneDay
  #   
  # }
  # diffAcrossYears=apply(tempMax85Yr,c(1,2),diff)
  # avgDiff=apply(diffAcrossYears,c(1,2),mean) ##mean of differences between successive years
  # sdDiff=apply(diffAcrossYears,c(1,2),sd)   ## sd of differences between successive years
  # quantAvgAllMaxTemp85=rbind(quantAvgAllMaxTemp85,quantAvg)
  # quantSDAllMaxTemp85=rbind(quantSDAllMaxTemp85,quantSD)
  # 
  # avgDiffCol=cut(c(avgDiff),quantAvg)
  # sdDiffCol=cut(c(sdDiff),quantSD)
  # 
  # 
  # lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(avgDiff),c(sdDiff)))
  # names(lonLatGridPlusValue)=c("lon","lat","avgDiff","sdDiff")
  # lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  # lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  # lonLatGridPlusValue$avgDiff=as.numeric(as.character(lonLatGridPlusValue$avgDiff))
  # lonLatGridPlusValue$sdDiff=as.numeric(as.character(lonLatGridPlusValue$sdDiff))
  # lonLatGridPlusValue$avgDiffCol=avgDiffCol
  # lonLatGridPlusValue$sdDiffCol=sdDiffCol
  # nameSave=paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmax/","aggResults.csv",sep="")
  # write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  # 
  #
#  print(paste("tag",i,sep=" "))
  
#}

## save quantiles for aggregation to GitHub folder
gitHubDir=""
setwd(gitHubDir)

write.csv(quantAvgAllPrHist,"quantilesPrHistAggAvg.csv",row.names=F)
#write.csv(quantAvgAllPr45,"quantilesPr45AggAvg.csv",row.names=F)
#write.csv(quantAvgAllPr85,"quantilesPr85AggAvg.csv",row.names=F)

write.csv(quantSDAllPrHist,"quantilesPrHistAggSD.csv",row.names=F)
#write.csv(quantSDAllPr45,"quantilesPrHistAggSD.csv",row.names=F)
#write.csv(quantSDAllPr85,"quantilesPrHistAggSD.csv",row.names=F)


write.csv(quantAvgAllMinTempHist,"quantilesMinTempHistAggAvg.csv",row.names=F)
#write.csv(quantAvgAllMinTemp45,"quantilesMinTemp45AggAvg.csv",row.names=F)
#write.csv(quantAvgAllMinTemp85,"quantilesMinTemp85AggAvg.csv",row.names=F)

write.csv(quantSDAllMinTempHist,"quantilesMinTempHistAggSD.csv",row.names=F)
#write.csv(quantSDAllMinTemp45,"quantilesMinTempHistAggSD.csv",row.names=F)
#write.csv(quantSDAllMinTemp85,"quantilesMinTempHistAggSD.csv",row.names=F)


write.csv(quantAvgAllMaxTempHist,"quantilesMaxTempHistAggAvg.csv",row.names=F)
#write.csv(quantAvgAllMaxTemp45,"quantilesMaxTemp45AggAvg.csv",row.names=F)
#write.csv(quantAvgAllMaxTemp85,"quantilesMaxTemp85AggAvg.csv",row.names=F)

write.csv(quantSDAllMaxTempHist,"quantilesMaxTempHistAggSD.csv",row.names=F)
#write.csv(quantSDAllMaxTemp45,"quantilesMaxTempHistAggSD.csv",row.names=F)
#write.csv(quantSDAllMaxTemp85,"quantilesMaxTempHistAggSD.csv",row.names=F)

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
