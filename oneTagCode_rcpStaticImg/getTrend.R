####### two summaries per tag #####

require(ncdf4)
require(RSvgDevice)
require(RColorBrewer)
require(maps)
require(MASS)

## path before rawdata, no ending backslash
yourPathToData="/Volumes/Sara_5TB/NEX"
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
    test=rlm(y~x,maxit=50)
    return(unname(coefficients(test)[2]))
  }
  ## needs to be in formula form or doesn't do intercept
  
  
  pr45Yr=array(0,c(1440,720,length(prFileNames_rcp45)))
  for(j in 1:length(prFileNames_rcp45)){
    ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/pr/",prFileNames_rcp45[j],sep="")
    ncin <- nc_open(ncname)
    precip45 <- ncvar_get(ncin,"pr")
    nc_close(ncin)
    
    
    oneDay=apply(precip45,c(1,2),mean,na.rm=T)
    
    pr45Yr[,,j]=oneDay
    print(j)
  }
  
  ## for each location, do it
  ## 1440 x 720 robust regressions
  coeffMat=matrix(NA,nrow=nrow(pr45Yr),ncol=ncol(pr45Yr))
  for(i in 1:nrow(pr45Yr)){
    for(j in 1:ncol(pr45Yr)){
     
      test=try(robustLM(pr45Yr[i,j,],x),silent=T)
      coeffMat[i,j]=ifelse(class(test)=="try-error",NA, test)
    }
    print(i)
  } ## takes a decent amount of time
  #In rlm.default(x, y, weights, method = method, wt.method = wt.method,  ... :
  #                     'rlm' failed to converge in 50 steps
  #save(coeffMat,file="coeffMatpr45Yr.RData")
  #hist(c(coeffMat))
  sdSnap=apply(pr45Yr,c(1,2),sd,na.rm=T) ## now gives appropriate dimension
  
  quantTrendPr45=quantile(c(coeffMat),seq(0,1,by=.1),na.rm=T)
  # 0%           10%           20%           30%           40%           50%           60%           70% 
  #   -6.371520e-07 -1.578887e-08 -2.291595e-09  8.980725e-10  5.151895e-09  1.057727e-08  1.685303e-08  2.384621e-08 
  # 80%           90%          100% 
  # 3.308791e-08  5.192528e-08  5.790400e-07 
  quantSDPr45=quantile(c(sdSnap),seq(0,1,by=.1),na.rm=T)
  # 0%          10%          20%          30%          40%          50%          60%          70%          80% 
  # 0.000000e+00 4.276545e-07 1.012098e-06 1.467588e-06 1.847629e-06 2.197525e-06 2.580519e-06 3.082164e-06 3.893791e-06 
  # 90%         100% 
  #   5.313486e-06 4.629693e-05 
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(coeffMat),c(sdSnap)))
  names(lonLatGridPlusValue)=c("lon","lat","robustSlope","SD")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$robustSlope=as.numeric(as.character(lonLatGridPlusValue$robustSlope))
  lonLatGridPlusValue$SD=as.numeric(as.character(lonLatGridPlusValue$SD))

  nameSave=paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/pr/","aggResultsProj.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
  pr85Yr=array(0,c(1440,720,length(prFileNames_rcp85)))
  for(j in 1:length(prFileNames_rcp85)){
    ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/pr/",prFileNames_rcp85[j],sep="")
    ncin <- nc_open(ncname)
    precip85 <- ncvar_get(ncin,"pr")
    nc_close(ncin)
    
    
    oneDay=apply(precip85,c(1,2),mean,na.rm=T)
    
    pr85Yr[,,j]=oneDay
    print(j)
  }
  
  ## for each location, do it
  ## 1440 x 720 robust regressions
  coeffMat=matrix(NA,nrow=nrow(pr85Yr),ncol=ncol(pr85Yr))
  for(i in 1:nrow(pr85Yr)){
    for(j in 1:ncol(pr85Yr)){
      
      test=try(robustLM(pr85Yr[i,j,],x),silent=T)
      coeffMat[i,j]=ifelse(class(test)=="try-error",NA, test)
    }
    print(i)
  } 
  sdSnap=apply(pr85Yr,c(1,2),sd,na.rm=T) ## now gives appropriate dimension
  
  quantTrendPr85=quantile(c(coeffMat),seq(0,1,by=.1),na.rm=T)
  quantSDPr85=quantile(c(sdSnap),seq(0,1,by=.1),na.rm=T)
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(coeffMat),c(sdSnap)))
  names(lonLatGridPlusValue)=c("lon","lat","robustSlope","SD")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$robustSlope=as.numeric(as.character(lonLatGridPlusValue$robustSlope))
  lonLatGridPlusValue$SD=as.numeric(as.character(lonLatGridPlusValue$SD))
  
  nameSave=paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/pr/","aggResultsProj.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)

  
  tempMin45Yr=array(0,c(1440,720,length(tempMinFileNames_rcp45)))
  for(j in 1:length(tempMinFileNames_rcp45)){
    ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp45[j],sep="")
    ncin <- nc_open(ncname)
    tempMin45 <- ncvar_get(ncin,"tasmin")
    nc_close(ncin)
    
    
    oneDay=apply(tempMin45,c(1,2),mean,na.rm=T)
    
    tempMin45Yr[,,j]=oneDay
    
  }
  coeffMat=matrix(NA,nrow=nrow(tempMin45Yr),ncol=ncol(tempMin45Yr))
  for(i in 1:nrow(tempMin45Yr)){
    for(j in 1:ncol(tempMin45Yr)){
     
      test=try(robustLM(tempMin45Yr[i,j,],x),silent=T)
      coeffMat[i,j]=ifelse(class(test)=="try-error",NA, test)
    }
    print(i)
  } 
  sdSnap=apply(tempMin45Yr,c(1,2),sd,na.rm=T) ## now gives appropriate dimension
  
  quantTrendMinTemp45=quantile(c(coeffMat),seq(0,1,by=.1),na.rm=T)
  quantSDMinTemp45=quantile(c(sdSnap),seq(0,1,by=.1),na.rm=T)
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(coeffMat),c(sdSnap)))
  names(lonLatGridPlusValue)=c("lon","lat","robustSlope","SD")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$robustSlope=as.numeric(as.character(lonLatGridPlusValue$robustSlope))
  lonLatGridPlusValue$SD=as.numeric(as.character(lonLatGridPlusValue$SD))
  
  nameSave=paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmin/","aggResultsProj.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
  tempMin85Yr=array(0,c(1440,720,length(tempMinFileNames_rcp85)))
  
  for(j in 1:length(tempMinFileNames_rcp85)){
    ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp85[j],sep="")
    ncin <- nc_open(ncname)
    tempMin85 <- ncvar_get(ncin,"tasmin")
    nc_close(ncin)
    
    oneDay=apply(tempMin85,c(1,2),mean,na.rm=T)
    
    tempMin85Yr[,,j]=oneDay
    
  }
  coeffMat=matrix(NA,nrow=nrow(tempMin85Yr),ncol=ncol(tempMin85Yr))
  for(i in 1:nrow(tempMin85Yr)){
    for(j in 1:ncol(tempMin85Yr)){
     
      test=try(robustLM(tempMin85Yr[i,j,],x),silent=T)
      coeffMat[i,j]=ifelse(class(test)=="try-error",NA, test)
    }
    print(i)
  } 
  sdSnap=apply(tempMin85Yr,c(1,2),sd,na.rm=T) ## now gives appropriate dimension
  
  quantTrendMinTemp85=quantile(c(coeffMat),seq(0,1,by=.1),na.rm=T)
  quantSDMinTemp85=quantile(c(sdSnap),seq(0,1,by=.1),na.rm=T)
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(coeffMat),c(sdSnap)))
  names(lonLatGridPlusValue)=c("lon","lat","robustSlope","SD")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$robustSlope=as.numeric(as.character(lonLatGridPlusValue$robustSlope))
  lonLatGridPlusValue$SD=as.numeric(as.character(lonLatGridPlusValue$SD))
  
  nameSave=paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmin/","aggResultsProj.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)
  
   tempMax45Yr=array(0,c(1440,720,length(tempMaxFileNames_rcp45)))
  
  for(j in 1:length(tempMaxFileNames_rcp45)){
    ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp45[j],sep="")
    ncin <- nc_open(ncname)
    tempMax45 <- ncvar_get(ncin,"tasmax")
    nc_close(ncin)
    
    oneDay=apply(tempMax45,c(1,2),mean,na.rm=T)
    tempMax45Yr[,,j]=oneDay
    
  }
   coeffMat=matrix(NA,nrow=nrow(tempMax45Yr),ncol=ncol(tempMax45Yr))
   for(i in 1:nrow(tempMax45Yr)){
     for(j in 1:ncol(tempMax45Yr)){
      
       test=try(robustLM(tempMax45Yr[i,j,],x),silent=T)
       coeffMat[i,j]=ifelse(class(test)=="try-error",NA, test)
     }
     print(i)
   } 
   sdSnap=apply(tempMax45Yr,c(1,2),sd,na.rm=T) ## now gives appropriate dimension
   
   quantTrendMaxTemp45=quantile(c(coeffMat),seq(0,1,by=.1),na.rm=T)
   quantSDMaxTemp45=quantile(c(sdSnap),seq(0,1,by=.1),na.rm=T)
   
   lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(coeffMat),c(sdSnap)))
   names(lonLatGridPlusValue)=c("lon","lat","robustSlope","SD")
   lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
   lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
   lonLatGridPlusValue$robustSlope=as.numeric(as.character(lonLatGridPlusValue$robustSlope))
   lonLatGridPlusValue$SD=as.numeric(as.character(lonLatGridPlusValue$SD))
   
   nameSave=paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmax/","aggResultsProj.csv",sep="")
   write.csv(lonLatGridPlusValue,nameSave,row.names=F)
   
   
  tempMax85Yr=array(0,c(1440,720,length(tempMaxFileNames_rcp85)))
  
  for(j in 1:length(tempMaxFileNames_rcp85)){
    ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp85[j],sep="")
    ncin <- nc_open(ncname)
    tempMax85 <- ncvar_get(ncin,"tasmax")
    nc_close(ncin)
    

    oneDay=apply(tempMax85,c(1,2),mean,na.rm=T)
    
    tempMax85Yr[,,j]=oneDay
    
  }
  coeffMat=matrix(NA,nrow=nrow(tempMax45Yr),ncol=ncol(tempMax45Yr))
  for(i in 1:nrow(tempMax85Yr)){
    for(j in 1:ncol(tempMax85Yr)){
      
      test=try(robustLM(tempMax85Yr[i,j,],x),silent=T)
      coeffMat[i,j]=ifelse(class(test)=="try-error",NA, test)
    }
    print(i)
  } 
  sdSnap=apply(tempMax85Yr,c(1,2),sd,na.rm=T) ## now gives appropriate dimension
  
  quantTrendMaxTemp85=quantile(c(coeffMat),seq(0,1,by=.1),na.rm=T)
  quantSDMaxTemp85=quantile(c(sdSnap),seq(0,1,by=.1),na.rm=T)
  
  lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,c(coeffMat),c(sdSnap)))
  names(lonLatGridPlusValue)=c("lon","lat","robustSlope","SD")
  lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
  lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
  lonLatGridPlusValue$robustSlope=as.numeric(as.character(lonLatGridPlusValue$robustSlope))
  lonLatGridPlusValue$SD=as.numeric(as.character(lonLatGridPlusValue$SD))
  
  nameSave=paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmax/","aggResultsProj.csv",sep="")
  write.csv(lonLatGridPlusValue,nameSave,row.names=F)


gitHubDir=""
setwd(gitHubDir)

write.csv(rbind(quantTrendPr45,quantTrendPr85,quantTrendMinTemp45,quantTrendMinTemp85,
                quantTrendMaxTemp45,quantTrendMaxTemp85),"quantilesProjectTrend.csv",row.names=F)
write.csv(rbind(quantSDPr45,quantSDPr85,quantSDMinTemp45,quantSDMinTemp85,
                quantSDMaxTemp45,quantSDMaxTemp85),"quantilesProjectSD.csv",row.names=F)


