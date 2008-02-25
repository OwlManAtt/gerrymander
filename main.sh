#!/bin/bash

# 4-wide-high.jpg 

function get_map_horizontal_units {
    #
}

function get_map_vertical_units {
    #
}

function res_from_pos {
	identify 4-${1}-${2}.jpg  | awk '{print $3}' | tr 'x' ':'
}

function get_width_by_row {
	w=0
	row=$1
	for col in `seq 0 9`; do
		w=$[ $w + $(res_from_pos $col $row | awk -F: '{print $1}') ]
	done
    echo $w
}

function get_height_by_col {
    height=p0
    col=$1
    for row in `seq 0 9`; do
        h=$[ $h + $(res_from_pos $col $row | awk -F: '{print $2}') ]
    done
    echo $h
}

mapsize="$(get_width_by_row 0)x$(get_height_by_col 0)"
convert -size $mapsize xc:none /tmp/blankmap


composite \
    -geometry ${x}x${y}{$xo}${yo} $in # a section of the map
    $out # a temp file

