# This script optimizes and resizes any images in the optimize directory 
# navigate out to the images directory
echo "------Navigating to images dir----------------"
git pull
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
	# reduce size
	echo "------Using mogrify to resize----------------"
	mogrify -auto-orient -verbose -filter Triangle -define filter:support=2 -thumbnail 1200 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB *.jp*g
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
