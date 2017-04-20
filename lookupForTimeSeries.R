githubWD="~/Desktop/UCB_DS421_NEX_partnerProject"
setwd(githubWD)
lon=read.csv("lon.csv",stringsAsFactors=F)[,1] ## save and load into javascript
lat=read.csv("lat.csv",stringsAsFactors=F)[,1] ## save and load into javascript

grid=expand.grid(lon,lat)

lookUpTable=paste("id",grid[,1],grid[,2],sep="_")
#head(lookUpTable)
#class(lookUpTable)
#length(lookUpTable)

reshapeLookUp=matrix(lookUpTable,nrow=length(lon),ncol=length(lat)) ## save to csv and load into javascript

point=c(0.380,90)
## printed to console 

## rewrite in java script
findGridCell=function(point, lookup,lon,lat){
  
  lookup[which.min(abs(lon-point[1])),which.min(abs(lat-point[2]))]
} ## will need a tag and variable name eventually

findGridCell(point,reshapeLookUp,lon,lat)

point=rbind(c(0.380,90),c(40,100))
apply(point,1,findGridCell,reshapeLookUp,lon,lat)

point=c(18.75,13.875)
findGridCell(point,reshapeLookUp,lon,lat)

point=c(-2.25,16.125)
findGridCell(point,reshapeLookUp,lon,lat)

## generate sequences
## subtract point from this, which one has smallest magnitude
## or have a flag for min up until this point, update
min(lat) ## -89.875
diff(lat)[1] ## 0.25
max(lat) ## 89.875

min(lon) ## 0.125
diff(lon)[1] ## 0.25
max(lon) ## 359.875

## for one tag, can add tag delimiters
toWrite=paste("<img id=\"ts-",grid[,1],"_",grid[,2],"\" class=\"bottom\" src=\"","ts-",grid[,1],"_",grid[,2],
              "trend",".png\" />",sep="")
length(toWrite) ## 1036800
## this is why we can't actually do this
writeLines(toWrite)

toWrite=paste("<img id=\"ts-",grid[,1],"_",grid[,2],"\" class=\"bottom\" src=\"","ts-",grid[,1],"_",grid[,2],
              "sd",".png\" />",sep="")
length(toWrite)
writeLines(toWrite)

