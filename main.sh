#!/bin/bash
MAPURL=$1 ## "http://www.wardmaps.com/viewmap.php?map_id=2822"
IMGROOT=$(wget "$MAPURL" -q -O - | grep "unrestored400500" | grep "so.addVariable" | awk '{ print $2 }' | tr -d "[)\";]")
NICENAME=$(echo "${IMGROOT}" | tr '/' '_')
NICENAME=${NICENAME:9:$(echo -n "$NICENAME" | wc -c) - 10}.jpg
IMGROOT="http://www.wardmaps.com/$IMGROOT"

imgdatafolder="/tmp/imgdata.$$"
mkdir "${imgdatafolder}"
imgdatafile="${imgdatafolder}/xmldata"

wget "${IMGROOT}/ImageProperties.xml" -q -O - | tr ' ' '\n' | tr -d '"' > $imgdatafile
WIDTH=$(cat $imgdatafile | grep 'WIDTH=' | awk -F= '{print $2}') 
HEIGHT=$(cat $imgdatafile | grep 'HEIGHT=' | awk -F= '{print $2}')
TILESIZE=$(cat $imgdatafile | grep 'TILESIZE=' | awk -F= '{print $2}')


pre="4"  ## no idea what it does. im assuming its the zoom depth (4 should be the maximum zoom)

ymin=0
ymax=$(bc <<<"scale=0; $HEIGHT/$TILESIZE")
xmin=0
xmax=$(bc <<<"scale=0; $WIDTH/$TILESIZE")

execstring="convert"
for row in `seq $ymin $ymax`
do
  yoffset=$(bc <<<"${row} * ${TILESIZE}")
  for col in `seq $xmin $xmax`
  do
    # I dont know what TileGroup0 is.  Lets hope it works anyway.
    wget "${IMGROOT}/TileGroup0/${pre}-${col}-${row}.jpg" -q -O "${imgdatafolder}/${col}-${row}.jpg"
    xoffset=$(bc <<<"${col} * ${TILESIZE}")
    execstring="${execstring} -page +${xoffset}+${yoffset} '${imgdatafolder}/${col}-${row}.jpg'"
  done
done

execstring="${execstring} -mosaic ./${NICENAME}"
eval "${execstring}"
rm -rf "${imgdatafolder}"
