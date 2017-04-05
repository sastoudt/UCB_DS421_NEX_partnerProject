githubWD="~/Desktop/UCB_DS421_NEX_partnerProject"
setwd(githubWD)
lon=read.csv("lon.csv",stringsAsFactors=F)[,1]
lat=read.csv("lat.csv",stringsAsFactors=F)[,1]

grid=expand.grid(lon,lat)

lookUpTable=paste("id",grid[,1],grid[,2],sep="_")
#head(lookUpTable)
#class(lookUpTable)
#length(lookUpTable)

reshapeLookUp=matrix(lookUpTable,nrow=length(lon),ncol=length(lat))

point=c(0.380,90)
## printed to console 

findGridCell=function(point, lookup,lon,lat){
  
  lookup[which.min(abs(lon-point[1])),which.min(abs(lat-point[2]))]
} ## will need a tag and variable name eventually

findGridCell(point,reshapeLookUp,lon,lat)

point=rbind(c(0.380,90),c(40,100))
apply(point,1,findGridCell,reshapeLookUp,lon,lat)
