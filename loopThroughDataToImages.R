yourPathToData=""

setwd("~/Desktop/UCB_DS421_NEX_partnerProject")

tags<-read.csv("tags.csv",stringsAsFactors=F,header=F) ## get tags for different models

nex_climate_filenames <- read.table("~/Desktop/UCB_DS421_NEX_partnerProject/nex_climate_filenames.txt", 
                                    quote="\"", comment.char="") ## get all file names

filesPerTags=vector("list",length(tags))
for(i in 1:length(tags)){
  filesPerTags[[i]]=nex_climate_filenames[grepl(tags[i,1],nex_climate_filenames[,1]),1]
} ## get files per tag


#lon <- ncvar_get(ncin,"lon") ## should only have to do for one file, same across files
#lat <- ncvar_get(ncin,"lat") ## should only have to do for one file, same across files


## since looping over tags, can easily run the code for only our half
for(i in 1:length(tagList)){

## split by type of data
 
prFileNames=filesPerTags[[i]][grepl("pr_",filesPerTags[[i]])]
tempMinFileNames=filesPerTags[[i]][grepl("tasmin_",filesPerTags[[i]])]
tempMaxFileNames=filesPerTags[[i]][grepl("tasmax_",filesPerTags[[i]])]

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
    imgName=paste(prFileNames_hist[j],"day",k,".fileType",sep="")
    ## make image
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
    imgName=paste(prFileNames_rcp45[j],"day",k,".fileType",sep="")
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
    imgName=paste(prFileNames_rcp85[j],"day",k,".fileType",sep="")
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
    imgName=paste(tempMinFileNames_hist[j],"day",k,".fileType",sep="")
    
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
    imgName=paste(tempMinFileNames_rcp45[j],"day",k,".fileType",sep="")
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
    imgName=paste(tempMinFileNames_rcp85[j],"day",k,".fileType",sep="")
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
    imgName=paste(tempMaxFileNames_hist[j],"day",k,".fileType",sep="")
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
    imgName=paste(tempMaxFileNames_rcp45[j],"day",k,".fileType",sep="")
    
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
    imgName=paste(tempMaxFileNames_rcp85[j],"day",k,".fileType",sep="")
  }
}


}

