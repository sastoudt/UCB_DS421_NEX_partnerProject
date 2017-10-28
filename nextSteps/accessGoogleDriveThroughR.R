### sample workflow to upload, download, and change sharing permission for Google Drive storage through R

#### Packages ####
# http://googledrive.tidyverse.org/

install.packages("googledrive")
#install.packages("googlesheet")
devtools::install_github("jennybc/googlesheets")

library("googledrive")
library("googlesheets")

#### Generate Fake Data as Test ####
fakedata=cbind(rnorm(100),rnorm(100),rnorm(100))
write.csv(fakedata,"fakedata.csv",row.names=F)

#### upload files ####

testData=drive_upload("fakedata.csv",path="DS421capstone/",name="testData.csv")

# Use a local file ('.httr-oauth'), to cache OAuth access credentials between R sessions?
# 
# 1: Yes
# 2: No
# 
# Selection: 1

## In our case, the data we would be uploading would be the restructured files (time series per grid cell)

 
#### giving access to files/folders ####

testData=drive_get("DS421capstone/testData.csv") ## not actual data, just file object


testData %>% 
  drive_reveal("permissions") ## add permissions field

testData <- testData %>%
    drive_share(role = "reader", type = "anyone") ## let anyone with the link read the data

#### how to get key/url ####

#?

## need to create some kind of look up table of keys for each grid cell
## given lat long or bounding box, give keys to access our processed data

#### grabbing data  ####

someoneGetData <- testData$id %>%
  gs_key()


