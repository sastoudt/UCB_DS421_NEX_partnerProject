listmyfolder <- read.table("listmyfolder.txt", header=TRUE, quote="\"", stringsAsFactors=FALSE)


filesToDownload<-read.csv("filesToDownload.csv",stringsAsFactors=F,header=F)

prFile=listmyfolder[grepl("pr_",listmyfolder[,1]),1]
tasmin=listmyfolder[grepl("tasmin_",listmyfolder[,1]),1]
tasmax=listmyfolder[grepl("tasmax_",listmyfolder[,1]),1]

filesHave=c(prFile,tasmin,tasmax)

head(filesToDownload)

length(filesHave) ## 2499
nrow(filesToDownload) ## 8112

stillToDownload=setdiff(filesToDownload[,1],filesHave)
idx=c()
for(i in 1:length(stillToDownload)){
idx=c(idx,which(filesToDownload==stillToDownload[i]))
  
}

idx

curlStatements=read.csv("curlStatements.csv",stringsAsFactors=F,header=F)

##add file name to all 

head(curlStatements)

writeLines(paste(curlStatements[idx,1],"v1.0/",filesToDownload[idx,1],sep=""), "curlToDo2.sh", sep = "\n", useBytes = FALSE)

