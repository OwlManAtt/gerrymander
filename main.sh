#!/bin/bash

function res_from_pos {
	identify 4-${1}-${2}.jpg  | awk '{print $3}' | tr 'x' ':'
}

function get_width_by_row {
	width = 0
	row = $1
	for col in `seq 0 9`; do
		width = $[ $width + $(res_from_pos $col $row | awk -F: '{print $1}') ]
	done
}
