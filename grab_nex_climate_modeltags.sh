# grab the lines that start with mkdir

grep '^mkdir' make_directories_files.sh | grep '/historical/' | sed -e 's:^.*/historical/::' | sed -e 's:/pr/.*::' | sed -e 's:/tasmin/.*::' | sed -e 's:/tasmax/.*::' | uniq


