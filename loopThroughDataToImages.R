require(RColorBrewer)
require(maps)
require(ncdf4)
require(RSvgDevice)

yourPathToData="/Volumes/Seagate_Expansion_5TB_jtb/NASA/climate/rawdata/"

setwd("~/Documents/berkeley/ds421/nasa/UCB_DS421_NEX_partnerProject/")

tagList<-read.csv("tagList.csv",stringsAsFactors=F,header=F) ## get tagList for different models

nex_climate_filenames <- read.table("nex_climate_filenames.txt", 
                                    quote="\"", comment.char="") ## get all file names

filesPertagList=vector("list",length(tagList))
for(i in 1:length(tagList)){
  filesPertagList[[i]]=nex_climate_filenames[grepl(tagList[i,1],nex_climate_filenames[,1]),1]
} ## get files per tag


#lon <- ncvar_get(ncin,"lon") ## should only have to do for one file, same across files
#lat <- ncvar_get(ncin,"lat") ## should only have to do for one file, same across files


## since looping over tagList, can easily run the code for only our half
for(i in 1:length(tagList)){

## split by type of data
 
prFileNames=filesPertagList[[i]][grepl("pr_",filesPertagList[[i]])]
tempMinFileNames=filesPertagList[[i]][grepl("tasmin_",filesPertagList[[i]])]
tempMaxFileNames=filesPertagList[[i]][grepl("tasmax_",filesPertagList[[i]])]

## split by historical, rcp45, rcp85

prFileNames_hist=prFileNames[grepl("historical",prFileNames)]
prFileNames_rcp45=prFileNames[grepl("rcp45",prFileNames)]
prFileNames_rcp85=prFileNames[grepl("rcp85",prFileNames)]

tempMinNames_hist=tempMinFileNames[grepl("historical",tempMinFileNames)]
tempMinFileNames_rcp45=tempMinFileNames[grepl("rcp45",tempMinFileNames)]
tempMinFileNames_rcp85=tempMinFileNames[grepl("rcp85",tempMinFileNames)]

tempMaxFileNames_hist=tempMaxFileNames[grepl("historical",tempMaxFileNames)]
tempMaxFileNames_rcp45=tempMaxFileNames[grepl("rcp45",tempMaxFileNames)]
tempMaxFileNames_rcp85=tempMaxFileNames[grepl("rcp85",tempMaxFileNames)]

## still need uniform color breaks
## breaks=breaksAll
## col=colAll
## lat 
## lon
for(j in 1:length(prFileNames_hist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i],"/pr/",prFileNames_hist[j],sep="")
  
  ncin <- nc_open(ncname)
  
  precipHist <- ncvar_get(ncin,"pr")
  ## need to double check for tmax, tmin, see what they are called
  nc_close(ncin)
  for(k in 1:(dim(precipHist)[3])){
    oneDay=precipHist[,,k]
    ## make and save image
    toSavePath=paste(yourPathToData,"/images/historical",tagList[i],"/pr/",prFileNames_hist[j],sep="")
    imgName=paste(prFileNames_hist[j],"day",k,".svg",sep="")
    setwd(toSavePath)
    ## make image
    year=substr(prFileNames_hist[j],nchar(as.character(prFileNames_hist[j]))-11,nchar(as.character(prFileNames_hist[j]))-8)
    devSVG(file=imgName,width=10,height=8)
    test=image(lon-180, lat, oneDay,breaks=breaksAll,col=colAll,sub=paste("historical ",tagList[i]),main=paste("Precip",year," Day ",k),xlab="lat",ylab="lon")
    map("world",add=T) ## + key
    dev.off()
  }
}

for(j in 1:length(prFileNames_rcp45)){
  ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i],"/pr/",prFileNames_rcp45[j],sep="")
 
  ncin <- nc_open(ncname)
 
  precip45 <- ncvar_get(ncin,"pr")
  ## need to do for tmax, tmin, see what they are called
  nc_close(ncin)
  
  for(k in 1:(dim(precip45)[3])){
    oneDay=precip45[,,k]
    ## make and save image
    toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i],"/pr/",prFileNames_rcp45[j],sep="")
    imgName=paste(prFileNames_rcp45[j],"day",k,".svg",sep="")
    setwd(toSavePath)
    ## make image
    year=substr(prFileNames_rcp45[j],nchar(as.character(prFileNames_rcp45[j]))-11,nchar(as.character(prFileNames_rcp45[j]))-8)
    devSVG(file=imgName,width=10,height=8)
    test=image(lon-180, lat, oneDay,breaks=breaksAll,col=colAll,sub=paste("rcp45 ",tagList[i]),main=paste("Precip",year," Day ",k),xlab="lat",ylab="lon")
    map("world",add=T) ##   + key
    dev.off()
  }
  
}

for(j in 1:length(prFileNames_rcp85)){
  ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i],"/pr/",prFileNames_rcp85[j],sep="")
  ncin <- nc_open(ncname)
  precip85 <- ncvar_get(ncin,"pr")
  nc_close(ncin)
  
  for(k in 1:(dim(precip85)[3])){
    oneDay=precip85[,,k]
    ## make and save image
    toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i],"/pr/",prFileNames_rcp85[j],sep="")
    imgName=paste(prFileNames_rcp85[j],"day",k,".svg",sep="")
    setwd(toSavePath)
    ## make image
    year=substr(prFileNames_rcp85[j],nchar(as.character(prFileNames_rcp85[j]))-11,nchar(as.character(prFileNames_rcp85[j]))-8)
    devSVG(file=imgName,width=10,height=8)
    test=image(lon-180, lat, oneDay,breaks=breaksAll,col=colAll,sub=paste("rcp85 ",tagList[i]),main=paste("Precip",year," Day ",k),xlab="lat",ylab="lon")
    map("world",add=T) ##   + key
    dev.off()
    
  }
}

for(j in 1:length(tempMinFileNames_hist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i],"/tasmin/",tempMinFileNames_hist[j],sep="")
  ncin <- nc_open(ncname)
  tempMinHist <- ncvar_get(ncin,"tasmin")
  ## need to do for tmax, tmin, see what they are called
  nc_close(ncin)
  
  for(k in 1:(dim(tempMinHist)[3])){
    oneDay=tempMinHist[,,k]
    ## make and save image
    toSavePath=paste(yourPathToData,"/images/historical/",tagList[i],"/tasmin/",tempMinFileNames_hist[j],sep="")
    imgName=paste(tempMinFileNames_hist[j],"day",k,".svg",sep="")
    setwd(toSavePath)
    ## make image
    year=substr(tempMinFileNames_hist[j],nchar(as.character(tempMinFileNames_hist[j]))-11,nchar(as.character(tempMinFileNames_hist[j]))-8)
    devSVG(file=imgName,width=10,height=8)
    test=image(lon-180, lat, oneDay,breaks=breaksAll,col=colAll,sub=paste("historical ",tagList[i]),main=paste("Min Temp",year," Day ",k),xlab="lat",ylab="lon")
    map("world",add=T) ##   + key
    dev.off()
    
  }
}

for(j in 1:length(tempMinFileNames_rcp45)){
  ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i],"/tasmin/",tempMinFileNames_rcp45[j],sep="")
  ncin <- nc_open(ncname)
  tempMin45 <- ncvar_get(ncin,"tasmin")
  ## need to do for tmax, tmin, see what they are called
  nc_close(ncin)
  
  for(k in 1:(dim(tempMin45)[3])){
    oneDay=tempMin45[,,k]
    ## make and save image
    toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i],"/tasmin/",tempMinFileNames_rcp45[j],sep="")
    imgName=paste(tempMinFileNames_rcp45[j],"day",k,".svg",sep="")
    setwd(toSavePath)
    ## make image
    year=substr(tempMinFileNames_rcp45[j],nchar(as.character(tempMinFileNames_rcp45[j]))-11,nchar(as.character(tempMinFileNames_rcp45[j]))-8)
    devSVG(file=imgName,width=10,height=8)
    test=image(lon-180, lat, oneDay,breaks=breaksAll,col=colAll,sub=paste("rcp45 ",tagList[i]),main=paste("Min Temp",year," Day ",k),xlab="lat",ylab="lon")
    map("world",add=T) ##   + key
    dev.off()
  }
}

for(j in 1:length(tempMinFileNames_rcp85)){
  ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i],"/tasmin/",tempMinFileNames_rcp85[j],sep="")
  ncin <- nc_open(ncname)
  tempMin85 <- ncvar_get(ncin,"tasmin")
  nc_close(ncin)
  
  for(k in 1:(dim(tempMin85)[3])){
    oneDay=tempMin85[,,k]
    ## make and save image
    toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i],"/tasmin/",tempMinFileNames_rcp85[j],sep="")
    imgName=paste(tempMinFileNames_rcp85[j],"day",k,".svg",sep="")
    setwd(toSavePath)
    ## make image
    year=substr(tempMinFileNames_rcp85[j],nchar(as.character(tempMinFileNames_rcp85[j]))-11,nchar(as.character(tempMinFileNames_rcp85[j]))-8)
    devSVG(file=imgName,width=10,height=8)
    test=image(lon-180, lat, oneDay,breaks=breaksAll,col=colAll,sub=paste("rcp85 ",tagList[i]),main=paste("Min Temp",year," Day ",k),xlab="lat",ylab="lon")
    map("world",add=T) ##   + key
    dev.off()
  }
}

for(j in 1:length(tempMaxFileNames_hist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i],"/tasmax/",tempMaxFileNames_hist[j],sep="")
  ncin <- nc_open(ncname)
  tempMaxHist <- ncvar_get(ncin,"tasmax")
  ## need to do for tmax, tmin, see what they are called
  nc_close(ncin)
  for(k in 1:(dim(tempMaxHist)[3])){
    oneDay=tempMaxHist[,,k]
    ## make and save image
    toSavePath=paste(yourPathToData,"/images/historical/",tagList[i],"/tasmax/",tempMaxFileNames_hist[j],sep="")
    imgName=paste(tempMaxFileNames_hist[j],"day",k,".svg",sep="")
    setwd(toSavePath)
    ## make image
    year=substr(tempMaxFileNames_hist[j],nchar(as.character(tempMaxFileNames_hist[j]))-11,nchar(as.character(tempMaxFileNames_hist[j]))-8)
    devSVG(file=imgName,width=10,height=8)
    test=image(lon-180, lat, oneDay,breaks=breaksAll,col=colAll,sub=paste("historical ",tagList[i]),main=paste("Max Temp",year," Day ",k),xlab="lat",ylab="lon")
    map("world",add=T) ##   + key
    dev.off()
  }
}

for(j in 1:length(tempMaxFileNames_rcp45)){
  ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i],"/tasmax/",tempMaxFileNames_rcp45[j],sep="")
  ncin <- nc_open(ncname)
  tempMax45 <- ncvar_get(ncin,"tasmax")
  ## need to do for tmax, tmin, see what they are called
  nc_close(ncin)
  for(k in 1:(dim(tempMax45)[3])){
    oneDay=tempMax45[,,k]
    ## make and save image
    toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i],"/tasmax/",tempMaxFileNames_rcp45[j],sep="")
    imgName=paste(tempMaxFileNames_rcp45[j],"day",k,".svg",sep="")
    setwd(toSavePath)
    ## make image
    year=substr(tempMaxFileNames_rcp45[j],nchar(as.character(tempMaxFileNames_rcp45[j]))-11,nchar(as.character(tempMaxFileNames_rcp45[j]))-8)
    devSVG(file=imgName,width=10,height=8)
    test=image(lon-180, lat, oneDay,breaks=breaksAll,col=colAll,sub=paste("rcp45 ",tagList[i]),main=paste("Max Temp",year," Day ",k),xlab="lat",ylab="lon")
    map("world",add=T) ##   + key
    dev.off()
    
  }
}

for(j in 1:length(tempMaxFileNames_rcp85)){
  ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i],"/tasmax/",tempMaxFileNames_rcp85[j],sep="")
  ncin <- nc_open(ncname)
  tempMax85 <- ncvar_get(ncin,"tasmax")
  ## need to do for tmax, tmin, see what they are called
  nc_close(ncin)
  for(k in 1:(dim(tempMax85)[3])){
    oneDay=tempMax85[,,k]
    ## make and save image
    toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i],"/tasmax/",tempMaxFileNames_rcp85[j],sep="")
    imgName=paste(tempMaxFileNames_rcp85[j],"day",k,".svg",sep="")
    setwd(toSavePath)
    ## make image
    year=substr(tempMaxFileNames_rcp85[j],nchar(as.character(tempMaxFileNames_rcp85[j]))-11,nchar(as.character(tempMaxFileNames_rcp85[j]))-8)
    devSVG(file=imgName,width=10,height=8)
    test=image(lon-180, lat, oneDay,breaks=breaksAll,col=colAll,sub=paste("rcp85 ",tagList[i]),main=paste("Max Temp",year," Day ",k),xlab="lat",ylab="lon")
    map("world",add=T) ##   + key
    dev.off()
  }
}


}

