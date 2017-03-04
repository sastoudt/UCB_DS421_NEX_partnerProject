## Run this in terminal
##ls -R /Volumes/Seagate_Expansion_5TB_jtb/NASA/climate/rawdata/historical >"listmyfolder_jtb.txt"

listmyfolder <- read.table("listmyfolder_jtb.txt", header=TRUE, quote="\"", stringsAsFactors=FALSE)

## filesToDownload is made by splitting the curl statements to get the files
filesToDownload<-read.table("files_partial_jtb.txt",stringsAsFactors=F,header=F)

prFile=listmyfolder[grepl("pr_",listmyfolder[,1]),1]
tasmin=listmyfolder[grepl("tasmin_",listmyfolder[,1]),1]
tasmax=listmyfolder[grepl("tasmax_",listmyfolder[,1]),1]

filesHave=c(prFile,tasmin,tasmax)

stillToDownload=setdiff(filesToDownload[,1],filesHave)
idx=c()
for(i in 1:length(stillToDownload)){
idx=c(idx,which(filesToDownload==stillToDownload[i]))
  
}


curlStatements=read.csv("curlStatements.csv",stringsAsFactors=F,header=F)

##add file name to all 


writeLines(paste(curlStatements[idx,1],"v1.0/",filesToDownload[idx,1],sep=""), "curlToDo2.sh", sep = "\n", useBytes = FALSE)

