setwd("~/Desktop")

listmyfolder <- read.table("listmyfolder.txt", header=TRUE, quote="\"", stringsAsFactors=FALSE)
listmyfolder2 <- read.table("listmyfolder2.txt", header=TRUE, quote="\"", stringsAsFactors=FALSE)

prFile=listmyfolder[grepl("pr_",listmyfolder[,1]),1]
tasmin=listmyfolder[grepl("tasmin_",listmyfolder[,1]),1]
tasmax=listmyfolder[grepl("tasmax_",listmyfolder[,1]),1]

filesHave=c(prFile,tasmin,tasmax)

prFile2=listmyfolder2[grepl("pr_",listmyfolder2[,1]),1]
tasmin2=listmyfolder2[grepl("tasmin_",listmyfolder2[,1]),1]
tasmax2=listmyfolder2[grepl("tasmax_",listmyfolder2[,1]),1]

filesHave2=c(prFile2,tasmin2,tasmax2)

length(filesHave) ## 2499
length(filesHave2) ##  3014 ## ok did pick some up this next time around

### what am I STILL missing?
setwd("~/Desktop/nasaDataScrapeAfterTimeout")
filesToDownload<-read.csv("filesToDownload.csv",stringsAsFactors=F,header=F)
nrow(filesToDownload) ## 8112 ## still not even halfway :(

stillToDownload=setdiff(filesToDownload[,1],filesHave2)
idx=c()
for(i in 1:length(stillToDownload)){
  idx=c(idx,which(filesToDownload==stillToDownload[i]))
  
}
length(idx) ## 5098 v. 3727  v.  3094 v.  2567 v. 1644

curlStatements=read.csv("curlStatements.csv",stringsAsFactors=F,header=F)

writeLines(paste(curlStatements[idx,1],"v1.0/",filesToDownload[idx,1],sep=""), "curlToDo6.sh", sep = "\n", useBytes = FALSE)

## test first line
#curl -u NEXGDDP:"" -o tasmax_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_1967.nc ftp://ftp.nccs.nasa.gov/BCSD/historical/day/atmos/tasmax/r1i1p1/v1.0/tasmax_day_BCSD_historical_r1i1p1_MIROC-ESM-CHEM_1967.nc
## This works....
## retried it got curl timeout
## retried again seems to be working
## on home internet not UCB

setwd("~/Desktop/nasaDataScrapeAfterTimeout")

leftToDo <- read.table("curlToDo3Split.txt", quote="\"", stringsAsFactors=FALSE)

head(leftToDo)

table(leftToDo[,1])

# GFDL-ESM2M         inmcm4   IPSL-CM5A-LR   IPSL-CM5A-MR      MIROC-ESM MIROC-ESM-CHEM         MIROC5     MPI-ESM-LR 
# 387            301             23            316            483            482            562            539 
# MPI-ESM-MR      MRI-CGCM3      NorESM1-M 
# 658            679            668 

table(leftToDo[,10])
#pr tasmax tasmin 
#1630   1765   1703 

table(leftToDo[,7])
#historical      rcp45      rcp85 
#764       1986       2348 

which(leftToDo[,7]=="historical") ## already ordered

table(leftToDo[which(leftToDo[,7]=="historical"),1])
#MIROC-ESM MIROC-ESM-CHEM         MIROC5     MPI-ESM-LR     MPI-ESM-MR      MRI-CGCM3      NorESM1-M 
#52             45            137             90            154            156            130 
table(leftToDo[which(leftToDo[,7]=="rcp45"),1])
#GFDL-ESM2M         inmcm4   IPSL-CM5A-MR      MIROC-ESM MIROC-ESM-CHEM         MIROC5     MPI-ESM-LR     MPI-ESM-MR 
#121             84            115            230            234            203            177            268 
#MRI-CGCM3      NorESM1-M 
#285            269 
table(leftToDo[which(leftToDo[,7]=="rcp85"),1])
#GFDL-ESM2M         inmcm4   IPSL-CM5A-LR   IPSL-CM5A-MR      MIROC-ESM MIROC-ESM-CHEM         MIROC5     MPI-ESM-LR 
#266            217             23            201            201            203            222            272 
#MPI-ESM-MR      MRI-CGCM3      NorESM1-M 
#236            238            269 

table(leftToDo[which(leftToDo[,10]=="pr"),1])
#GFDL-ESM2M         inmcm4   IPSL-CM5A-LR   IPSL-CM5A-MR      MIROC-ESM MIROC-ESM-CHEM         MIROC5     MPI-ESM-LR 
#85            163             21             92            191            129            144            180 
#MPI-ESM-MR      MRI-CGCM3      NorESM1-M 
#217            201            207 
table(leftToDo[which(leftToDo[,10]=="tasmax"),1])
#GFDL-ESM2M         inmcm4   IPSL-CM5A-LR   IPSL-CM5A-MR      MIROC-ESM MIROC-ESM-CHEM         MIROC5     MPI-ESM-LR 
#132            109              2            114            193            165            211            154 
#MPI-ESM-MR      MRI-CGCM3      NorESM1-M 
#221            246            218 
table(leftToDo[which(leftToDo[,10]=="tasmin"),1])

#GFDL-ESM2M         inmcm4   IPSL-CM5A-MR      MIROC-ESM MIROC-ESM-CHEM         MIROC5     MPI-ESM-LR     MPI-ESM-MR 
#170             29            110             99            188            207            205            220 
#MRI-CGCM3      NorESM1-M 
#232            243 

# no obvious pattern

## do I have a full tag yet?
sum(grepl("MIROC-ESM-CHEM",filesToDownload[idx,1]))

filesToDownload[idx,1][which(grepl("MIROC-ESM-CHEM",filesToDownload[idx,1])==T)]
## have all historical, just mising rcp85
