#!/bin/bash
num=1
for f in *.tif
do
#	f_temp=${f%.*}
	f_temp=$(printf "%d" "$num")
	mv -f ./$f ./$f_temp".tif"
	num=$(expr "$num" + 1)
done

