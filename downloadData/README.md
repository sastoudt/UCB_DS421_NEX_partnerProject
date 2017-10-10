## Download Data from NEX

We streamline the process outlined here: https://nex.nasa.gov/nex/resources/366/

Throughout all of these you will need to find/replace /path/to/your/preferred/location/ with your desired path.



make_directories_files.sh: bash script to make all the directories needed to store the files
make_directories_images.sh: bash script to make all the directories needed to store any images you make

NEX_climate_download_Full.sh: bash script to scrape all of the data from NEX

grab_nex_climate_filenames.sh: bash script to get all the file names from the download file
nex_climate_filenames.txt: output of running grab_nex_climate_filenames.sh

grab_nex_climate_modeltags.sh: bash script to get all the model product names
tags.csv: output of running grab_nex_climate_modeltags.sh

findMissingFilesGetNextRun.R: R script to find which files are missing if you get a timeout error

Before running this script, run this in terminal: ls -R /path/to/data >"listmyfolder.txt"

After running findMissingFilesGetNextRun.R, run the following in terminal: bash curlToDo2.sh



