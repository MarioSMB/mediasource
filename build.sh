#!/bin/bash

CONVERT=convert
SELF_DIR=$(dirname $(readlink -se "${BASH_SOURCE[0]}"))
OUT_DIR=out
SOURCE_DIR=.


# Compresses images into jpegs
# Synopsis: input.png output
# Genreates output.jpg and output_alpha.jpg
function compress_image()
{
	convert -background none "$1" -layers merge -quality 75 "$2.jpg"
	convert -background none "$1" -layers merge -alpha Extract -quality 75 "$2_alpha.jpg"
}

# Convert shortened paths
function convert_paths()
{
	echo "$1" | sed -r "s~^hud/~gfx/hud/default/~"
}

# Create the package
# Synopsis: generate subdir zzz-package-name
function generate()
{
	TARGET=$2
	SOURCE_DIR=$1
	local SRC_FILES=$(find $SOURCE_DIR -type f)
	for src_file in $SRC_FILES
	do
		local out_file=$OUT_DIR/$TARGET/$(convert_paths ${src_file#$SOURCE_DIR/})
		mkdir -p $(dirname "$out_file")
		
		if echo -n "$src_file" | grep -Eq "\.(png|svg|tga|xcf)$"
		then
			local jpeg_base=$(echo -n $out_file | head -c -4)
			if [ "$src_file" -nt "$jpeg_base.jpg" ]
			then
				echo -e "Compressing \e[1m$src_file\e[0m"
				compress_image "$src_file" "$jpeg_base"
				continue
			fi
		elif [ "$src_file" -nt "$out_file" ]
		then
			echo -e "Copying \e[1m$src_file\e[0m"
			cp "$src_file" "$out_file"
			continue
		fi
		
		echo -e "Skipping \e[1m$src_file\e[0m"
		
	done
	
	PK3_VERSION=$(git describe --tags || echo "unknown")
	PK3_NAME=$TARGET-$PK3_VERSION.pk3
	echo -e "Creating package \e[1m$PK3_NAME\e[0m"
	( cd "$OUT_DIR/$TARGET" && zip -p "../$PK3_NAME" -r * )
	
	echo "Done!"
}


mkdir -p $OUT_DIR
generate minigames zzz-minigames