### sample workflow to upload, download, and change sharing permission for Google Drive storage through R

# http://googledrive.tidyverse.org/

install.packages("googledrive")

library("googledrive")


fakedata=cbind(rnorm(100),rnorm(100),rnorm(100))
write.csv(fakedata,"fakedata.csv",row.names=F)
### upload files

testData=drive_upload("fakedata.csv",path="DS421capstone/",name="testData.csv")

# Use a local file ('.httr-oauth'), to cache OAuth access credentials between R sessions?
# 
# 1: Yes
# 2: No
# 
# Selection: 1

### In our case, the data we would be uploading would be the restructured files (time series per grid cell)


#### giving access to files/folders


#### grabbing data 

