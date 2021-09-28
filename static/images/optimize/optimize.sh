# This script optimizes and resizes any images in the optimize directory 
# navigate out to the images directory
echo "------Navigating to images dir----------------"
cd ..
# move any JPG files larger than 1 MB to optimize dir
echo "------Finding large files and moving them to optimize dir----------------"
find . -maxdepth 1 -type f -size +1M -name "*.jp*g" -exec mv {} optimize/ \;
# go back to optimize dir
echo "------Navigating to optimize dir----------------"
cd optimize/

echo "------Are there files to modify?----------------"
count=`ls -1 *.jp*g 2>/dev/null | wc -l`
if [ $count != 0 ]
then 
	# backup images
	echo "------Yes, backing up large files----------------"
	find . -maxdepth 1 -type f -name "*.jp*g" -exec cp {} ../../backup/ \;
	# remove file data, optimize file to reduce space
	echo "------Using jpegoptim to strip information----------------"
	jpegoptim *.jp*g --strip-all
	# reduce size
	echo "------Using mogrify to resize----------------"
	mogrify -resize 20% *.jp*g
	# move back to images dir
	echo "------Staging new images----------------"
	find . -maxdepth 1 -type f -name "*.jp*g" -exec mv {} ../ \;
	# push changes
	echo "------Pushing changes----------------"
	# navigate out to root directory
	cd ../../..
	git add *
	git commit -m "optimized images"
	git push
else
	echo "------No images to optimize, aborting----------------"
fi 