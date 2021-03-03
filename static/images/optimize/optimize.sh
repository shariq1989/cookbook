# make backup of images
cp *.jpg ../../backup/
# remove file data, optimize file to reduce space
jpegoptim *.jpg --strip-all
# reduce size
mogrify -resize 75% *.jpg
# move back to images dir
mv *.jpg ../
