library(RColorBrewer)
library(maps)
library(ncdf4)
library(RSvgDevice)

## yourPathDoData should be up to rawdata and end with a backslash
yourPathToData="/Volumes/Seagate_Expansion_5TB_jtb/NASA/climate"

## set to gitHub working directory to read in some files to get set up
setwd("~/Documents/berkeley/ds421/nasa/UCB_DS421_NEX_partnerProject/")

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


## still need uniform color breaks


## just take January 1 from 3 different files do quantile
#pr_day_BCSD_historical_r1i1p1_ACCESS1-0_1950
#tasmax_day_BCSD_historical_r1i1p1_ACCESS1-0_1967.nc
#tasmin_day_BCSD_historical_r1i1p1_GFDL-ESM2M_1950.nc

## in reality need to open and loop through all the data to get appropriate cutpoints, but just as proof of concept
## will probably need a transform to show variation, etc.
## non trivial choices, but I'll work on some ideas on how best to make the cuts to minimize how much data
## we go through before hand


#breaksAllPr=c(1.211651e-07, 3.037936e-06, 8.454731e-06, 1.965769e-05, 4.818611e-05 ) ## quantile(c(oneDay),seq(0,1,by=.1))[6:10]
#breaksAllMinTemp=c(213.6561, 264.8782, 274.5075, 288.1346, 303.0206 ) ## quantile(c(oneDay),seq(0,1,by=.25),na.rm=T)[1:5]
#breaksAllMaxTemp=c(218.4304,267.1825, 277.3592, 289.0492, 320.6029) ## quantile(c(oneDay),seq(0,1,by=.25))[1:5]

## need one more break than color

#colAllPr=brewer.pal(4,"Blues")
#colAllMinTemp=rev(brewer.pal(4,"Purples")) ## deeper purple means colder
#colAllMaxTemp=brewer.pal(4,"YlOrRd")

colAllPr=c(brewer.pal(9,"Blues"),"black")
colAllMinTemp=c("black",rev(brewer.pal(9,"Purples")))
colAllMaxTemp=c(brewer.pal(9,"YlOrRd"),"black")
## might want more than 4 breakpoints, just a proof of concept here

## might need to further break down by historical, rcp45, rcp85

### comment out for now until we actually have these
## github directory, where you saved the breaks from running getBreaksMakeLegendsHistoricalOnly.R
setwd("~/Documents/berkeley/ds421/nasa/UCB_DS421_NEX_partnerProject/")
prHistBreak=read.csv("prHistBreak.csv",stringsAsFactors=F)
#pr45Break=read.csv.csv("pr45Break.csv",stringsAsFactors=F)
#pr85Break=read.csv("pr85Break.csv",stringsAsFactors=F)

minTempHistBreak=read.csv("minTempHistBreak.csv",stringsAsFactors=F)
#minTemp45Break=read.csv("minTemp45Break.csv",stringsAsFactors=F)
#minTemp85Break=read.csv("minTemp85Break.csv",stringsAsFactors=F)

maxTempHistBreak=read.csv("maxTempHistBreak.csv",stringsAsFactors=F)
breaksAllMaxTemp=c(238.1236, 252.4237, 260.7205, 268.3477, 274.6672, 280.4095, 285.7682, 290.0989, 292.9525, 299.6218, 311.6947)
#maxTemp45Break=read.csv("maxTemp45Break.csv",stringsAsFactors=F)
#maxTemp85Break=read.csv("maxTemp85Break.csv",stringsAsFactors=F)

makePNG=T ## false means it will make an SVG

# if(makePNG){
#   imgName=paste(prFileNames_hist[j],"day",k,".png",sep="")
#   png(file=imgName,width=10,height=8,units="in",res = 300)
# }else{
#   imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
#   devSVG(file=imgName,width=10,height=8)
# }

## set up quantile keep track
quantilePrHist=quantilePr45=quantilePr85=quantileMinTempHist=
  quantileMinTemp45=quantileMinTemp85=quantileMaxTempHist=quantileMaxTemp45=quantileMaxTemp85=c()

quantilePrHistTemporary=quantilePr45Temporary=quantilePr85Temporary=quantileMinTempHistTemporary=
  quantileMinTemp45Temporary=quantileMinTemp85Temporary=quantileMaxTempHistTemporary=quantileMaxTemp45Temporary=
  quantileMaxTemp85Temporary=c()

## since looping over tagList, can easily run the code for only our half
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
  
  tempMinNames_hist=tempMinFileNames[grepl("historical",tempMinFileNames)]
  #tempMinFileNames_rcp45=tempMinFileNames[grepl("rcp45",tempMinFileNames)]
  #tempMinFileNames_rcp85=tempMinFileNames[grepl("rcp85",tempMinFileNames)]

  tempMaxFileNames_hist=tempMaxFileNames[grepl("historical",tempMaxFileNames)]
  #tempMaxFileNames_rcp45=tempMaxFileNames[grepl("rcp45",tempMaxFileNames)]
  #tempMaxFileNames_rcp85=tempMaxFileNames[grepl("rcp85",tempMaxFileNames)]

  
  
  for(j in 1:length(prFileNames_hist)){
    ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/pr/",prFileNames_hist[j],sep="")
    
    ncin <- nc_open(ncname)
    
    precipHist <- ncvar_get(ncin,"pr")
    ## need to double check for tmax, tmin, see what they are called
    nc_close(ncin)
    for(k in 1:(dim(precipHist)[3])){
      oneDay=precipHist[,,k]
      quantilePrHistTemporary=rbind(quantilePrHistTemporary,quantile(c(oneDay),seq(0,1,by=.1),na.rm=T))
      ## make and save image
      toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/pr/",sep="")
      #imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
      setwd(toSavePath)
      ## make image
      year=substr(prFileNames_hist[j],nchar(as.character(prFileNames_hist[j]))-11,nchar(as.character(prFileNames_hist[j]))-8)
      #breaksAllPr=prHistBreak[i,]
      if(makePNG){
        imgName=paste(prFileNames_hist[j],"day",k,".png",sep="")
        png(file=imgName,width=10,height=8,units="in",res = 300)
      }else{
        imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
        devSVG(file=imgName,width=10,height=8)
      }
      
      test=image(lon-180, lat, oneDay,breaks=breaksAllPr,col=colAllPr,sub=paste("historical ",tagList[i,1]),main=paste("Precip",year," Day ",k),xlab="lat",ylab="lon")
      map("world",add=T) ## + key
      dev.off()
      print(paste("precip day",k,sep=" "))
      
    }
    print(paste("precip file",j,sep=" "))
    
  }
  
  # for(j in 1:length(prFileNames_rcp45)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/pr/",prFileNames_rcp45[j],sep="")
  #   
  #   ncin <- nc_open(ncname)
  #   
  #   precip45 <- ncvar_get(ncin,"pr")
  #   ## need to do for tmax, tmin, see what they are called
  #   nc_close(ncin)
  #   
  #   for(k in 1:(dim(precip45)[3])){
  #     oneDay=precip45[,,k]
  #     quantilePr45Temporary=rbind(quantilePr45Temporary,quantile(c(oneDay),seq(0,1,by=.1),na.rm=T))
  #     
  #     ## make and save image
  #     toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/pr/",sep="")
  #     #imgName=paste(prFileNames_rcp45[j],"day",k,".svg",sep="")
  #     setwd(toSavePath)
  #     ## make image
  #     year=substr(prFileNames_rcp45[j],nchar(as.character(prFileNames_rcp45[j]))-11,nchar(as.character(prFileNames_rcp45[j]))-8)
  #     #breaksAllPr=pr45Break[i,]
  #     if(makePNG){
  #       imgName=paste(prFileNames_hist[j],"day",k,".png",sep="")
  #       png(file=imgName,width=10,height=8,units="in",res = 300)
  #     }else{
  #       imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
  #       devSVG(file=imgName,width=10,height=8)
  #     }
  #     test=image(lon-180, lat, oneDay,breaks=breaksAllPr,col=colAllPr,sub=paste("rcp45 ",tagList[i,1]),main=paste("Precip",year," Day ",k),xlab="lat",ylab="lon")
  #     map("world",add=T) ##   + key
  #     dev.off()
  #   }
  #   
  # }
  # 
  # for(j in 1:length(prFileNames_rcp85)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/pr/",prFileNames_rcp85[j],sep="")
  #   ncin <- nc_open(ncname)
  #   precip85 <- ncvar_get(ncin,"pr")
  #   nc_close(ncin)
  #   
  #   for(k in 1:(dim(precip85)[3])){
  #     oneDay=precip85[,,k]
  #     quantilePr85Temporary=rbind(quantilePr85Temporary,quantile(c(oneDay),seq(0,1,by=.1),na.rm=T))
  #     
  #     ## make and save image
  #     toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/pr/",sep="")
  #     #imgName=paste(prFileNames_rcp85[j],"day",k,".svg",sep="")
  #     setwd(toSavePath)
  #     ## make image
  #     year=substr(prFileNames_rcp85[j],nchar(as.character(prFileNames_rcp85[j]))-11,nchar(as.character(prFileNames_rcp85[j]))-8)
  #     #breaksAllPr=pr85Break[i,]
  #     if(makePNG){
  #       imgName=paste(prFileNames_hist[j],"day",k,".png",sep="")
  #       png(file=imgName,width=10,height=8,units="in",res = 300)
  #     }else{
  #       imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
  #       devSVG(file=imgName,width=10,height=8)
  #     }
  #     
  #     test=image(lon-180, lat, oneDay,breaks=breaksAllPr,col=colAllPr,sub=paste("rcp85 ",tagList[i,1]),main=paste("Precip",year," Day ",k),xlab="lat",ylab="lon")
  #     map("world",add=T) ##   + key
  #     dev.off()
  #     
  #   }
  # }
  
  for(j in 1:length(tempMinFileNames_hist)){
    ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmin/",tempMinFileNames_hist[j],sep="")
    ncin <- nc_open(ncname)
    tempMinHist <- ncvar_get(ncin,"tasmin")
    ## need to do for tmax, tmin, see what they are called
    nc_close(ncin)
    
    for(k in 1:(dim(tempMinHist)[3])){
      oneDay=tempMinHist[,,k]
      quantileMinTempHistTemporary=rbind(quantileMinTempHistTemporary,quantile(c(oneDay),seq(0,1,by=.1),na.rm=T))
      
      ## make and save image
      toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
      #imgName=paste(tempMinFileNames_hist[j],"day",k,".svg",sep="")
      setwd(toSavePath)
      ## make image
      year=substr(tempMinFileNames_hist[j],nchar(as.character(tempMinFileNames_hist[j]))-11,nchar(as.character(tempMinFileNames_hist[j]))-8)
      #breaksAllMinTemp=minTempHistBreak[i,]
      if(makePNG){
        imgName=paste(prFileNames_hist[j],"day",k,".png",sep="")
        png(file=imgName,width=10,height=8,units="in",res = 300)
      }else{
        imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
        devSVG(file=imgName,width=10,height=8)
      }
      
      test=image(lon-180, lat, oneDay,breaks=breaksAllMinTemp,col=colAllMinTemp,sub=paste("historical ",tagList[i,1]),main=paste("Min Temp",year," Day ",k),xlab="lat",ylab="lon")
      map("world",add=T) ##   + key
      dev.off()
      print(paste("min temp day",k,sep=" "))
      
    }
    print(paste("min temp file",j,sep=" "))
    
  }
  
  # for(j in 1:length(tempMinFileNames_rcp45)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp45[j],sep="")
  #   ncin <- nc_open(ncname)
  #   tempMin45 <- ncvar_get(ncin,"tasmin")
  #   ## need to do for tmax, tmin, see what they are called
  #   nc_close(ncin)
  #   
  #   for(k in 1:(dim(tempMin45)[3])){
  #     oneDay=tempMin45[,,k]
  #     quantileMinTemp45Temporary=rbind(quantileMinTemp45Temporary,quantile(c(oneDay),seq(0,1,by=.1),na.rm=T))
  #     
  #     ## make and save image
  #     toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmin/",sep="")
  #     #imgName=paste(tempMinFileNames_rcp45[j],"day",k,".svg",sep="")
  #     setwd(toSavePath)
  #     ## make image
  #     year=substr(tempMinFileNames_rcp45[j],nchar(as.character(tempMinFileNames_rcp45[j]))-11,nchar(as.character(tempMinFileNames_rcp45[j]))-8)
  #     #breaksAllMinTemp=minTemp45Break[i,]
  #     if(makePNG){
  #       imgName=paste(prFileNames_hist[j],"day",k,".png",sep="")
  #       png(file=imgName,width=10,height=8,units="in",res = 300)
  #     }else{
  #       imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
  #       devSVG(file=imgName,width=10,height=8)
  #     }
  #     
  #     test=image(lon-180, lat, oneDay,breaks=breaksAllMinTemp,col=colAllMinTemp,sub=paste("rcp45 ",tagList[i,1]),main=paste("Min Temp",year," Day ",k),xlab="lat",ylab="lon")
  #     map("world",add=T) ##   + key
  #     dev.off()
  #   }
  # }
  # 
  # for(j in 1:length(tempMinFileNames_rcp85)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp85[j],sep="")
  #   ncin <- nc_open(ncname)
  #   tempMin85 <- ncvar_get(ncin,"tasmin")
  #   nc_close(ncin)
  #   
  #   for(k in 1:(dim(tempMin85)[3])){
  #     oneDay=tempMin85[,,k]
  #     quantileMinTemp85Temporary=rbind(quantileMinTemp85Temporary,quantile(c(oneDay),seq(0,1,by=.1),na.rm=T))
  #     
  #     ## make and save image
  #     toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmin/",sep="")
  #     #imgName=paste(tempMinFileNames_rcp85[j],"day",k,".svg",sep="")
  #     setwd(toSavePath)
  #     ## make image
  #     year=substr(tempMinFileNames_rcp85[j],nchar(as.character(tempMinFileNames_rcp85[j]))-11,nchar(as.character(tempMinFileNames_rcp85[j]))-8)
  #     #breaksAllMinTemp=minTemp85Break[i,]
  #     if(makePNG){
  #       imgName=paste(prFileNames_hist[j],"day",k,".png",sep="")
  #       png(file=imgName,width=10,height=8,units="in",res = 300)
  #     }else{
  #       imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
  #       devSVG(file=imgName,width=10,height=8)
  #     }
  #     
  #     test=image(lon-180, lat, oneDay,breaks=breaksAllMinTemp,col=colAllMinTemp,sub=paste("rcp85 ",tagList[i,1]),main=paste("Min Temp",year," Day ",k),xlab="lat",ylab="lon")
  #     map("world",add=T) ##   + key
  #     dev.off()
  #   }
  # }
  ptm <- proc.time()
  for(j in 1:length(tempMaxFileNames_hist)){
    ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmax/",tempMaxFileNames_hist[j],sep="")
    ncin <- nc_open(ncname)
    tempMaxHist <- ncvar_get(ncin,"tasmax")
    ## need to do for tmax, tmin, see what they are called
    nc_close(ncin)
    for(k in 1:(dim(tempMaxHist)[3])){
      oneDay=tempMaxHist[,,k]
      quantileMaxTempHistTemporary=rbind(quantileMaxTempHistTemporary,quantile(c(oneDay),seq(0,1,by=.1),na.rm=T))
      
      ## make and save image
      toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmax/",sep="")
      #imgName=paste(tempMaxFileNames_hist[j],"day",k,".svg",sep="")
      setwd(toSavePath)
      ## make image
      year=substr(tempMaxFileNames_hist[j],nchar(as.character(tempMaxFileNames_hist[j]))-11,nchar(as.character(tempMaxFileNames_hist[j]))-8)
      #breaksAllMaxTemp=maxTempHistBreak[i,]
      if(makePNG){
        imgName=paste(prFileNames_hist[j],"day",k,".png",sep="")
        png(file=imgName,width=10,height=8,units="in",res = 300)
      }else{
        imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
        devSVG(file=imgName,width=10,height=8)
      }
      
      test=image(lon-180, lat, oneDay,breaks=breaksAllMaxTemp,col=colAllMaxTemp,sub=paste("historical ",tagList[i,1]),main=paste("Max Temp",year," Day ",k),xlab="lat",ylab="lon")
      map("world",add=T) ##   + key
      dev.off()
      print(paste("max temp day",k,sep=" "))
      
    }
    print(paste("max temp file",j,sep=" "))
    
  }
  proc.time() - ptm
  # 
  # for(j in 1:length(tempMaxFileNames_rcp45)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp45[j],sep="")
  #   ncin <- nc_open(ncname)
  #   tempMax45 <- ncvar_get(ncin,"tasmax")
  #   ## need to do for tmax, tmin, see what they are called
  #   nc_close(ncin)
  #   for(k in 1:(dim(tempMax45)[3])){
  #     oneDay=tempMax45[,,k]
  #     quantileMaxTemp45Temporary=rbind(quantileMaxTemp45Temporary,quantile(c(oneDay),seq(0,1,by=.1),na.rm=T))
  #     
  #     ## make and save image
  #     toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmax/",sep="")
  #     #imgName=paste(tempMaxFileNames_rcp45[j],"day",k,".svg",sep="")
  #     setwd(toSavePath)
  #     ## make image
  #     year=substr(tempMaxFileNames_rcp45[j],nchar(as.character(tempMaxFileNames_rcp45[j]))-11,nchar(as.character(tempMaxFileNames_rcp45[j]))-8)
  #     #breaksAllMaxTemp=maxTemp45Break[i,]
  #     if(makePNG){
  #       imgName=paste(prFileNames_hist[j],"day",k,".png",sep="")
  #       png(file=imgName,width=10,height=8,units="in",res = 300)
  #     }else{
  #       imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
  #       devSVG(file=imgName,width=10,height=8)
  #     }
  #     
  #     test=image(lon-180, lat, oneDay,breaks=breaksAllMaxTemp,col=colAllMaxTemp,sub=paste("rcp45 ",tagList[i,1]),main=paste("Max Temp",year," Day ",k),xlab="lat",ylab="lon")
  #     map("world",add=T) ##   + key
  #     dev.off()
  #     
  #   }
  # }
  # 
  # for(j in 1:length(tempMaxFileNames_rcp85)){
  #   ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp85[j],sep="")
  #   ncin <- nc_open(ncname)
  #   tempMax85 <- ncvar_get(ncin,"tasmax")
  #   ## need to do for tmax, tmin, see what they are called
  #   nc_close(ncin)
  #   for(k in 1:(dim(tempMax85)[3])){
  #     oneDay=tempMax85[,,k]
  #     quantileMaxTemp85Temporary=rbind(quantileMaxTemp85Temporary,quantile(c(oneDay),seq(0,1,by=.1),na.rm=T))
  #     
  #     ## make and save image
  #     toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmax/",sep="")
  #     #imgName=paste(tempMaxFileNames_rcp85[j],"day",k,".svg",sep="")
  #     setwd(toSavePath)
  #     ## make image
  #     year=substr(tempMaxFileNames_rcp85[j],nchar(as.character(tempMaxFileNames_rcp85[j]))-11,nchar(as.character(tempMaxFileNames_rcp85[j]))-8)
  #     #breaksAllMaxTemp=maxTemp85Break[i,]
  #     if(makePNG){
  #       imgName=paste(prFileNames_hist[j],"day",k,".png",sep="")
  #       png(file=imgName,width=10,height=8,units="in",res = 300)
  #     }else{
  #       imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
  #       devSVG(file=imgName,width=10,height=8)
  #     }
  #     
  #     test=image(lon-180, lat, oneDay,breaks=breaksAllMaxTemp,col=colAllMaxTemp,sub=paste("rcp85 ",tagList[i,1]),main=paste("Max Temp",year," Day ",k),xlab="lat",ylab="lon")
  #     map("world",add=T) ##   + key
  #     dev.off()
  #   }
  # }
  # 
  ## aggregate temporary quantiles
  
  minOfMins=min(quantilePrHistTemporary[,1])
  mid=apply(quantilePrHistTemporary[,2:10],2,mean)
  maxOfMaxs=max(quantilePrHistTemporary[,11])
  quantilePrHist=rbind(quantilePrHist,c(minOfMins,mid,maxOfMaxs))
  
  # minOfMins=min(quantilePr45Temporary[,1])
  # mid=apply(quantilePr45Temporary[,2:10],2,mean)
  # maxOfMaxs=max(quantilePr45Temporary[,11])
  # quantilePr45=rbind(quantilePr45,c(minOfMins,mid,maxOfMaxs))
  # 
  # minOfMins=min(quantilePr85Temporary[,1])
  # mid=apply(quantilePr85Temporary[,2:10],2,mean)
  # maxOfMaxs=max(quantilePr85Temporary[,11])
  # quantilePr85=rbind(quantilePr85,c(minOfMins,mid,maxOfMaxs))
  
  minOfMins=min(quantileMinTempHistTemporary[,1])
  mid=apply(quantileMinTempHistTemporary[,2:10],2,mean)
  maxOfMaxs=max(quantileMinTempHistTemporary[,11])
  quantileMinTempHist=rbind(quantileMinTempHist,c(minOfMins,mid,maxOfMaxs))
  
  # minOfMins=min(quantileMinTemp45Temporary[,1])
  # mid=apply(quantileMinTemp45Temporary[,2:10],2,mean)
  # maxOfMaxs=max(quantileMinTemp45Temporary[,11])
  # quantileMinTemp45=rbind(quantileMinTemp45,c(minOfMins,mid,maxOfMaxs))
  # 
  # minOfMins=min(quantileMinTemp85Temporary[,1])
  # mid=apply(quantileMinTemp85Temporary[,2:10],2,mean)
  # maxOfMaxs=max(quantileMinTemp85Temporary[,11])
  # quantileMinTemp85=rbind(quantileMinTemp85,c(minOfMins,mid,maxOfMaxs))
  
  minOfMins=min(quantileMaxTempHistTemporary[,1])
  mid=apply(quantileMaxTempHistTemporary[,2:10],2,mean)
  maxOfMaxs=max(quantileMaxTempHistTemporary[,11])
  quantileMaxTempHist=rbind(quantileMaxTempHist,c(minOfMins,mid,maxOfMaxs))
  
  # minOfMins=min(quantileMaxTemp45Temporary[,1])
  # mid=apply(quantileMaxTemp45Temporary[,2:10],2,mean)
  # maxOfMaxs=max(quantileMaxTemp45Temporary[,11])
  # quantileMaxTemp45=rbind(quantileMaxTemp45,c(minOfMins,mid,maxOfMaxs))
  # 
  # minOfMins=min(quantileMaxTemp85Temporary[,1])
  # mid=apply(quantileMaxTemp85Temporary[,2:10],2,mean)
  # maxOfMaxs=max(quantileMaxTemp85Temporary[,11])
  # quantileMaxTemp85=rbind(quantileMaxTemp85,c(minOfMins,mid,maxOfMaxs))
  print(paste("tag",i,sep=" "))
  
}

## save quantiles in GitHub folder for future reference
gitHubWD=""

setwd(gitHubWD)

write.csv(quantilePrHist,"quantileFromAllDataPrHist.csv",row.names=F)
#write.csv(quantilePr45,"quantileFromAllDataPr45.csv",row.names=F)
#write.csv(quantilePr85,"quantileFromAllDataPr85.csv",row.names=F)

write.csv(quantileMinTempHist,"quantileFromAllDataMinTempHist.csv",row.names=F)
#write.csv(quantileMinTemp45,"quantileFromAllDataMinTemp45.csv",row.names=F)
#write.csv(quantileMinTemp85,"quantileFromAllDataMinTemp85.csv",row.names=F)

write.csv(quantileMaxTempHist,"quantileFromAllDataMaxTempHist.csv",row.names=F)
#write.csv(quantileMaxTemp45,"quantileFromAllDataMaxTemp45.csv",row.names=F)
#write.csv(quantileMaxTemp85,"quantileFromAllDataMaxTemp85.csv",row.names=F)

