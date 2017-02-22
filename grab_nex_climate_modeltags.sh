# grab the lines that start with mkdir
# pipe only the lines that have '/historical/', to reduce duplicates from other scenarios,
# replace everything before '/historical/' with blank (delete it)
# replace '/pr/', '/tasmin/', and '/tasmax/' with blank (delete them)
# all that's left is the model names
# remove duplicates; keep only one copy of each model name in list

# you can run this script and pipe list into a file with 'bash grab_nex_climate_modeltags.sh | tee file.txt'

grep '^mkdir' make_directories_files.sh | grep '/historical/' | sed -e 's:^.*/historical/::' | sed -e 's:/pr/.*::' | sed -e 's:/tasmin/.*::' | sed -e 's:/tasmax/.*::' | uniq


