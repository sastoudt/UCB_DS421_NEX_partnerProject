## remove 2 from filesToDownload and curlStatements for Sara

## Run this in terminal
##ls -R /path/to/NEX/data >"listmyfolder.txt"

listmyfolder <- read.table("listmyfolder.txt", header=TRUE, quote="\"", stringsAsFactors=FALSE)

## filesToDownload is made by splitting the curl statements to get the files
filesToDownload<-read.csv("filesToDownload2.csv",stringsAsFactors=F,header=F)

prFile=listmyfolder[grepl("pr_",listmyfolder[,1]),1]
tasmin=listmyfolder[grepl("tasmin_",listmyfolder[,1]),1]
tasmax=listmyfolder[grepl("tasmax_",listmyfolder[,1]),1]

filesHave=c(prFile,tasmin,tasmax)

stillToDownload=setdiff(filesToDownload[,1],filesHave)
idx=c()
for(i in 1:length(stillToDownload)){
idx=c(idx,which(filesToDownload==stillToDownload[i]))
  
}


curlStatements=read.csv("curlStatements2.csv",stringsAsFactors=F,header=F)

##add file name to all 


writeLines(paste(curlStatements[idx,1],"v1.0/",filesToDownload[idx,1],sep=""), "curlToDo2.sh", sep = "\n", useBytes = FALSE)

## workflow
# Open NEX_climate_download_partial_A.sh
# 
# Copy the first column into a new excel file
# 
# Delete all the mkdir rows
# 
# Save as partACommands.csv
# 
# Now find replace “v1.0/” with *
#   
#   Text to Columns on *
#   
#   copy first column into a new excel file
# save as curlStatements.csv
# 
# copy second column into a new excel file
# save as filesToDownload.csv
# 
# Now run filesLeftToDownload.R
# 
# Open curlToDo2.sh
# 
# find/replace /path/to/your/preferred/location/ with the right path
# 
# bash curlToDo2.sh
