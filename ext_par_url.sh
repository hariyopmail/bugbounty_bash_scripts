#!/bin/bash

vp=vars_pars

cat "$1"/*"_$1" | while read origin_url; do
	url=$(echo "$origin_url" | cut -d"|" -f2-)
	
	#extract params
	echo "$url" | grep -Eo "(?:\?|&|;)([^=]+)=([^&|;]+)" | tee >(sed "s|^|$url\||" >> "$vp"/.url_value_params_temp) >(cut -d"=" -f1 | grep -Eo "[0-9A-Za-z_:]{2,}" | sort -u  >> "$vp"/.p_url_params_temp) > /dev/null

	#extract paths
	echo "$url" | cut -d"/" -f4- | cut -d"?" -f1  | tee >(cut -d"/" -f1 | sort -u >> "$vp"/.d_single_url_paths_temp) >(cut -d"/" -f2 | sort -u >> "$vp"/.d_single_url_paths_temp) >(cut -d"/" -f3 | sort -u >> "$vp"/.d_single_url_paths_temp) >(cut -d"/" -f4 | sort -u >> "$vp"/.d_single_url_paths_temp) >(rev | cut -d"/" -f1 | rev | sort -u >> "$vp"/.d_single_url_paths_temp ) >(cut -d"/" -f1- | sort -u >> "$vp"/.d_multi_url_paths_temp ) > /dev/null

done	


if [ -f $vp/.d_single_url_paths_temp ]; then
	cat $vp/.d_single_url_paths_temp | sort -u >> "$vp"/d_single_url_paths
	rm $vp/.d_single_url_paths_temp
fi

if [ -f $vp/.d_multi_url_paths_temp ]; then
	cat $vp/.d_multi_url_paths_temp | sort -u >> "$vp"/d_multi_url_paths
	rm $vp/.d_multi_url_paths_temp
fi

if [ -f $vp/.p_url_params_temp ]; then
	cat $vp/.p_url_params_temp | sort -u >> "$vp"/p_url_params
	rm $vp/.p_url_params_temp
fi

if [ -f $vp/.url_value_params ]; then
	cat "$vp"/.url_value_params_temp | sort -u >> "$vp"/url_value_params
	rm "$vp"/.url_value_params
fi
