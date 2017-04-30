## get all future time series for one location

yourPathToData=""

wd=""
setwd(wd)

tags<-read.csv("tags.csv")
tags=as.character(tags[,1])


### find location of interest ###
gitWD=""
setwd(gitWD)

lon=read.csv("lon.csv",stringsAsFactors=F)[,1] 
lat=read.csv("lat.csv",stringsAsFactors=F)[,1]
grid=expand.grid(lon,lat)

lookUpTable=paste("id",grid[,1],grid[,2],sep="_")

reshapeLookUp=matrix(lookUpTable,nrow=length(lon),ncol=length(lat))
point=c(-9.5,38.78)



findGridCell=function(point, lookup,lon,lat){
  
  lookup[which.min(abs(lon-point[1])),which.min(abs(lat-point[2]))]
} 

findGridCell(point,reshapeLookUp,lon,lat)

lonInterest=which(lon==0.125) 
latInterest=which(lat==38.875)


####
nex_climate_filenames <- read.table("nex_climate_filenames.txt", 
                                    quote="\"", comment.char="") 
filesPertagList=vector("list",length(tags))
for(i in 1:length(tags)){
  filesPertagList[[i]]=nex_climate_filenames[grepl(tags[i],nex_climate_filenames[,1]),1]
} ## get files per tag

seriesMatrix<-c()
for(i in 1:length(tags)){
  
  
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
  
  
  series<-c()
  ## do for max temp rcp45 but can change to focus on a different variable/scenario pair
  for(j in 1:length(tempMaxFileNames_rcp45)){
    ncname <- paste(yourPathToData,"/rawdata/rcp45/",tags[i],"/tasmax/",as.character(tempMaxFileNames_rcp45[j]),sep="")
    ncin <- nc_open(ncname)
    tasmax<- ncvar_get(ncin,"tasmax")
    nc_close(ncin)

    aggYear=apply(tasmax,c(1,2),mean,na.rm=T)

    series<-c(series,aggYear[lonInterest,latInterest])
    print(j)
  }
  print(i)
  seriesMatrix=rbind(seriesMatrix,series)
}



