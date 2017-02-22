# grab the lines that start with curl
# replace everything before 'v1.0/' with blank (delete it)
# all that's left is the file names
# you can run this script and pipe list into a file with 'bash grab_nex_climate_filenames.sh | tee file.txt'

grep '^curl' NEX_climate_download_FULL.sh | sed -e 's:^.*v1.0/::' 



