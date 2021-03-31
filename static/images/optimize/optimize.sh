# This script optimizes and resizes any images in the optimize directory 
# navigate out to the images directory
cd ..
# move any JPG files larger than 1 MB to optimize dir
find .  -maxdepth 1 -type f -size +1M -name '*.jpg' -exec mv {} optimize/ \;
# go back to optimize dir
cd optimize/
# backup images
cp *.jpg ../../backup/
# remove file data, optimize file to reduce space
jpegoptim *.jpg --strip-all
# reduce size
mogrify -resize 20% *.jpg
# move back to images dir
mv *.jpg ../
# push changes
echo "------Pushing changes----------------"
# navigate out to root directory
cd ../../..
git add *
git commit -m "optimized images"
git push