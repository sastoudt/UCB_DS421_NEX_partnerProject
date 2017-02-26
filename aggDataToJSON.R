## aggregated data to JSON for manipulation in D3

## lat
## lon

## value
setwd("~/Desktop/d3Practice")
library(ncdf4)
## whole globe for a year
ncname <- "pr_day_BCSD_historical_r1i1p1_ACCESS1-0_1950"  
ncfname <- paste(ncname,".nc", sep="")
ncin <- nc_open(ncfname)
lon <- ncvar_get(ncin,"lon")
lat <- ncvar_get(ncin,"lat")
time<-ncvar_get(ncin,"time")
precip <- ncvar_get(ncin,"pr")
nc_close(ncin)

dim(precip)
length(lon)
length(lat)
## lon x lat

test=matrix(c(1,2,3,4,5,6),nrow=3,ncol=2)

c(test)

lonLatGrid=expand.grid(lon,lat)
dim(lonLatGrid) ## 1036800       2

head(lonLatGrid) ## same lat for different lon so exactly the format of c()

catPrecip=c(precip[,,1]) ## aggregate to one level
length(catPrecip) ##  

lonLatGridPlusValue=as.data.frame(cbind(lonLatGrid,catPrecip))
dim(lonLatGridPlusValue)

names(lonLatGridPlusValue)=c("lon","lat","pr")
lonLatGridPlusValue$lon=as.numeric(as.character(lonLatGridPlusValue$lon))
lonLatGridPlusValue$lat=as.numeric(as.character(lonLatGridPlusValue$lat))
lonLatGridPlusValue$pr=as.numeric(as.character(lonLatGridPlusValue$pr))


library(jsonlite)
#x <- toJSON(lonLatGridPlusValue)
#head(cat(x))

write_json(lonLatGridPlusValue,"test.json")
#write_json(x,"test.json")

