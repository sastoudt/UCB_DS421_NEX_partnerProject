## get breaks for images

library(ncdf4)
## per tag and type

yourPathToData=""
wd=""
setwd(wd)

tagList<-read.csv("tags.csv",stringsAsFactors=F,header=F) ## get tagList for different models

nex_climate_filenames <- read.table("nex_climate_filenames.txt", 
                                    quote="\"", comment.char="") ## get all file names

filesPertagList=vector("list",nrow(tagList))
for(i in 1:nrow(tagList)){
  filesPertagList[[i]]=nex_climate_filenames[grepl(tagList[i,1],nex_climate_filenames[,1]),1]
} ## get files per tag



prHistBreak=minTempHistBreak=maxTempHistBreak=matrix(0,nrow=1,ncol=11)
i=15
  
  ## split by type of data
  
  prFileNames=filesPertagList[[i]][grepl("pr_",filesPertagList[[i]])]
  tempMinFileNames=filesPertagList[[i]][grepl("tasmin_",filesPertagList[[i]])]
  tempMaxFileNames=filesPertagList[[i]][grepl("tasmax_",filesPertagList[[i]])]
  
  ## split by historical, rcp45, rcp85
  
  prFileNames_hist=prFileNames[grepl("historical",prFileNames)]

  
  subSampPrHist=seq(1,length(prFileNames_hist),by=5)
  
  
  
  tempMinNames_hist=tempMinFileNames[grepl("historical",tempMinFileNames)]
 
  
  subSampMinTempHist=seq(1,length(tempMinNames_hist),by=5)
  
  tempMaxFileNames_hist=tempMaxFileNames[grepl("historical",tempMaxFileNames)]
  
  
  subSampMaxTempHist=seq(1,length(tempMaxFileNames_hist),by=5)
 
  
  quants<-c()
  for(k in 1:length(subSampPrHist)){
    ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/pr/",prFileNames_hist[subSampPrHist[k]],sep="")
    ncin <- nc_open(ncname)
    precipHist <- ncvar_get(ncin,"pr")
    nc_close(ncin)
    
    test=apply(precipHist,c(1,2),mean,na.rm=T)
    quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1),na.rm=T)))
    print(k)
  }
  prHistBreak=apply(quants,2,mean,na.rm=T)
 
  
  
  quants<-c()
  for(k in 1:length(subSampMinTempHist)){
    ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmin/",tempMinFileNames_hist[subSampMinTempHist[k]],sep="")
    ncin <- nc_open(ncname)
    tempMinHist <- ncvar_get(ncin,"tasmin")
    nc_close(ncin)
    
    test=apply(tempMinHist,c(1,2),mean,na.rm=T)
    quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1),na.rm=T)))
  }
  minTempHistBreak=apply(quants,2,mean,na.rm=T)
 
  quants<-c()
  for(k in 1:length(subSampMaxTempHist)){
    ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmax/",tempMaxFileNames_hist[subSampMaxTempHist[k]],sep="")
    ncin <- nc_open(ncname)
    tempMaxHist <- ncvar_get(ncin,"tasmax")
    nc_close(ncin)
    
    test=apply(tempMaxHist,c(1,2),mean,na.rm=T)
    quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1),na.rm=T)))
    
  }
  maxTempHistBreak=apply(quants,2,mean,na.rm=T)
  
## use these breaks for image slider plots


## make key in image slider plot code

