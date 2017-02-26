## get breaks for images
## see how these look, may need log transform for precip data

## https://www.biostars.org/p/73644/
## if values are more extreme than the break points we set, they are just truncated at the lower/upper color limit

library(ncdf4)
## per tag and type

yourPathToData=""

setwd("~/Desktop/UCB_DS421_NEX_partnerProject/")

tagList<-read.csv("tags.csv",stringsAsFactors=F,header=F) ## get tagList for different models

nex_climate_filenames <- read.table("nex_climate_filenames.txt", 
                                    quote="\"", comment.char="") ## get all file names

filesPertagList=vector("list",length(tagList))
for(i in 1:nrow(tagList)){
  filesPertagList[[i]]=nex_climate_filenames[grepl(tagList[i,1],nex_climate_filenames[,1]),1]
} ## get files per tag



prHistBreak=pr45Break=pr85Break=minTempHistBreak=minTemp45Break=minTemp85Break=
  maxTempHistBreak=maxTemp45Break=maxTemp85Break=matrix(0,nrow=length(tagList),ncol=11)
for(i in 1:nrow(tagList)){
  
  ## split by type of data
  
  prFileNames=filesPertagList[[i]][grepl("pr_",filesPertagList[[i]])]
  tempMinFileNames=filesPertagList[[i]][grepl("tasmin_",filesPertagList[[i]])]
  tempMaxFileNames=filesPertagList[[i]][grepl("tasmax_",filesPertagList[[i]])]
  
  ## split by historical, rcp45, rcp85
  
  prFileNames_hist=prFileNames[grepl("historical",prFileNames)]
  prFileNames_rcp45=prFileNames[grepl("rcp45",prFileNames)]
  prFileNames_rcp85=prFileNames[grepl("rcp85",prFileNames)]
  
  subSampPrHist=seq(1,length(prFileNames_hist),by=5)
  subSampPr45=seq(1,length(prFileNames_rcp45),by=5)
  subSampPr85=seq(1,length(prFileNames_rcp85),by=5)
 
  
  tempMinNames_hist=tempMinFileNames[grepl("historical",tempMinFileNames)]
  tempMinFileNames_rcp45=tempMinFileNames[grepl("rcp45",tempMinFileNames)]
  tempMinFileNames_rcp85=tempMinFileNames[grepl("rcp85",tempMinFileNames)]
  
  subSampMinTempHist=seq(1,length(tempMinNames_hist),by=5)
  subSampMinTemp45=seq(1,length(tempMinFileNames_rcp45),by=5)
  subSampMinTemp85=seq(1,length(tempMinFileNames_rcp85),by=5)
  
  tempMaxFileNames_hist=tempMaxFileNames[grepl("historical",tempMaxFileNames)]
  tempMaxFileNames_rcp45=tempMaxFileNames[grepl("rcp45",tempMaxFileNames)]
  tempMaxFileNames_rcp85=tempMaxFileNames[grepl("rcp85",tempMaxFileNames)]
  
  subSampMaxTempHist=seq(1,length(tempMaxFileNames_hist),by=5)
  subSampMaxTemp45=seq(1,length(tempMaxFileNames_rcp45),by=5)
  subSampMaxTemp85=seq(1,length(tempMaxFileNames_rcp85),by=5)
  
  quants<-c()
  for(k in 1:length(subSampPrHist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/pr/",prFileNames_hist[k],sep="")
  ncin <- nc_open(ncname)
  precipHist <- ncvar_get(ncin,"pr")
  nc_close(ncin)
  
  test=apply(precipHist,c(1,2),mean)
  quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1))))
  }
  prHistBreak[i,]=apply(quants,2,mean)
  
  quants<-c()
  for(k in 1:length(subSampPr45)){
  ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/pr/",prFileNames_rcp45[k],sep="")
  ncin <- nc_open(ncname)
  precip45 <- ncvar_get(ncin,"pr")
  nc_close(ncin)
  
  test=apply(precip45,c(1,2),mean)
  quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1))))
  }
  pr45Break[i,]=apply(quants,2,mean)
  
  quants<-c()
  for(k in 1:length(subSampPr85)){
  ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/pr/",prFileNames_rcp85[k],sep="")
  ncin <- nc_open(ncname)
  precip85 <- ncvar_get(ncin,"pr")
  nc_close(ncin)
  
  test=apply(precip85,c(1,2),mean)
  quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1))))
  }
  pr85Break[i,]=apply(quants,2,mean)
  
  ##
  
  quants<-c()
  for(k in 1:length(subSampMinTempHist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmin/",tempMinFileNames_hist[j],sep="")
  ncin <- nc_open(ncname)
  tempMinHist <- ncvar_get(ncin,"tasmin")
  nc_close(ncin)
  
  test=apply(tempMinHist,c(1,2),mean)
  quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1))))
  }
  minTempHistBreak[i,]=apply(quants,2,mean)
  
  quants<-c()
  for(k in 1:length(subSampMinTemp45)){
  ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp45[j],sep="")
  ncin <- nc_open(ncname)
  tempMin45 <- ncvar_get(ncin,"tasmin")
  nc_close(ncin)
  
  test=apply(tempMin45,c(1,2),mean)
  quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1))))
  }
  minTemp45Break[i,]=apply(quants,2,mean)
  
  quants<-c()
  for(k in 1:length(subSampMinTemp85)){
  ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmin/",tempMinFileNames_rcp85[j],sep="")
  ncin <- nc_open(ncname)
  tempMin85 <- ncvar_get(ncin,"tasmin")
  nc_close(ncin)
  
  test=apply(tempMin85,c(1,2),mean)
  quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1))))
  }
  minTemp85Break[i,]=apply(quants,2,mean)
  ##
  
  quants<-c()
  for(k in 1:length(subSampMaxTempHist)){
  ncname <- paste(yourPathToData,"/rawdata/historical/",tagList[i,1],"/tasmax/",tempMaxFileNames_hist[j],sep="")
  ncin <- nc_open(ncname)
  tempMaxHist <- ncvar_get(ncin,"tasmax")
  nc_close(ncin)
  
  test=apply(tempMaxHist,c(1,2),mean)
  quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1))))
  
  }
  maxTempHistBreak[i,]=apply(quants,2,mean)
  
  
  quants<-c()
  for(k in 1:length(subSampMaxTemp45)){
  ncname <- paste(yourPathToData,"/rawdata/rcp45/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp45[j],sep="")
  ncin <- nc_open(ncname)
  tempMax45 <- ncvar_get(ncin,"tasmax")
  nc_close(ncin)
  
  test=apply(tempMax45,c(1,2),mean)
  quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1))))
  }
  maxTemp45Break[i,]=apply(quants,2,mean)
  
  quants<-c()
  for(k in 1:length(subSampMaxTemp85)){
  ncname <- paste(yourPathToData,"/rawdata/rcp85/",tagList[i,1],"/tasmax/",tempMaxFileNames_rcp85[j],sep="")
  ncin <- nc_open(ncname)
  tempMax85 <- ncvar_get(ncin,"tasmax")
  nc_close(ncin)
  
  test=apply(tempMax85,c(1,2),mean)
  quants<-rbind(quants,unname(quantile(c(test),seq(0,1,by=.1))))
  }
  maxTemp85Break[i,]=apply(quants,2,mean)
}

gitHubWD=""

setwd(gitHubWD)
write.csv(prHistBreak,"prHistBreak.csv",row.names=F)
write.csv(pr45Break,"pr45Break.csv",row.names=F)
write.csv(pr85Break,"pr85Break.csv",row.names=F)

write.csv(minTempHistBreak,"minTempHistBreak.csv",row.names=F)
write.csv(minTemp45Break,"minTemp45Break.csv",row.names=F)
write.csv(minTemp85Break,"minTemp85Break.csv",row.names=F)

write.csv(maxTempHistBreak,"maxTempHistBreak.csv",row.names=F)
write.csv(maxTemp45Break,"maxTemp45Break.csv",row.names=F)
write.csv(maxTemp85Break,"maxTemp85Break.csv",row.names=F)

## make key

require(RColorBrewer)
require(R2BayesX)
library(RSvgDevice)

for(i in 1:nrow(tagList)){
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/pr/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_prHistLegend.svg",sep="")
  toPlot=prHistBreak[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/pr/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_pr45Legend.svg",sep="")
  toPlot=pr45Break[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/pr/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_pr85Legend.svg",sep="")
  toPlot=pr85Break[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmin/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_minTempHistLegend.svg",sep="")
  toPlot=minTempHistBreak[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmin/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_minTemp45Legend.svg",sep="")
  toPlot=minTemp45Break[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmin/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_minTemp85Legend.svg",sep="")
  toPlot=minTemp85Break[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c("black",rev(brewer.pal(9,"Purples"))),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/historical/",tagList[i,1],"/tasmax/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_maxTempHistLegend.svg",sep="")
  toPlot=maxTempHistBreak[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp45/",tagList[i,1],"/tasmax/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_maxTemp45Legend.svg",sep="")
  toPlot=maxTemp45Break[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  toSavePath=paste(yourPathToData,"/images/rcp85/",tagList[i,1],"/tasmax/",sep="")
  setwd(toSavePath)
  imgName=paste(tagList[i,1],"_maxTemp85Legend.svg",sep="")
  toPlot=maxTemp85Break[i,]
  devSVG(file=imgName,width=12,height=4)
  colorlegend(color=c(brewer.pal(9,"YlOrRd"),"black"),breaks=toPlot,at=toPlot,x=toPlot,digits=10,symmetric=F)
  dev.off()
  
  
}

devSVG(file="test.svg",width=12,height=4)
colorlegend(color=c(brewer.pal(9,"Blues"),"black"),breaks=0:10,at=0:10,x=0:10,digits=10,symmetric=F)
dev.off()
colAllPr=brewer.pal(4,"Blues")

