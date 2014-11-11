#!/bin/bash

CONVERT=convert
SELF_DIR=$(dirname $(readlink -se "${BASH_SOURCE[0]}"))
OUT_DIR=out
SOURCE_DIR=.
JPEG_QUALITY=75
SED="sed -r"


# Compresses images into jpegs
# Synopsis: input.png output
# Genreates output.jpg and output_alpha.jpg
function compress_image()
{
	local covert_flags="-layers merge -quality $JPEG_QUALITY"
	convert -background none "$1" $covert_flags "$2.jpg"
	convert -background none "$1" $covert_flags -alpha Extract "$2_alpha.jpg"
}

# Ensure that the output jpg are of the appropriate size
# Synopsis: scale_image output
# Where "output" is the same as $2 in compress_image
function scale_image()
{
	local MAX_W=1024
	
	if echo -n "$1" | grep -q "gfx/hud/default/minigames/.*/piece.*"
	then
		MAX_W=256
	fi
	
	if [ "$MAX_W" -gt 0 ]
	then
		img_w=$(identify -format %w "$1.jpg")
		if [ "$img_w" -gt "$MAX_W" ]
		then
			local scale=$(echo "scale=10; $MAX_W/$img_w*100" | bc)
			convert "$1.jpg"       -resize "$scale%" "$1.jpg"
			convert "$1_alpha.jpg" -resize "$scale%" "$1_alpha.jpg"
		fi
	fi
}

# Convert shortened paths
function convert_paths()
{
	echo "$1" | $SED "s~^hud/~gfx/hud/default/~"
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
		mkdir -p "$(dirname "$out_file")"
		
		if echo -n "$src_file" | grep -Eq "\.(png|svg|tga|xcf)$"
		then
			local jpeg_base=$(echo -n $out_file | head -c -4)
			if [ "$src_file" -nt "$jpeg_base.jpg" ]
			then
				echo -e "Compressing \x1b[1m$src_file\x1b[0m"
				compress_image "$src_file" "$jpeg_base"
				scale_image "$jpeg_base"
				continue
			fi
		elif [ "$src_file" -nt "$out_file" ]
		then
			echo -e "Copying \x1b[1m$src_file\x1b[0m"
			cp "$src_file" "$out_file"
			continue
		fi
		
		echo -e "Skipping \x1b[1m$src_file\x1b[0m"
		
	done
	
	PK3_VERSION=$(git describe --tags || echo "unknown")
	PK3_NAME=$TARGET-$PK3_VERSION.pk3
	echo -e "Creating package \x1b[1m$PK3_NAME\x1b[0m"
	( cd "$OUT_DIR/$TARGET" && zip -p "../$PK3_NAME" -r * )
	
	echo "Done!"
}

if [ "$(uname)" = Darwin ]
then
	SED="sed -E"
fi


mkdir -p "$OUT_DIR"
for arg in $*
do
	case $arg in
		clean)
			
			rm -rf "$OUT_DIR"
			;;
		quit)
			exit
			;;
	esac
done

generate minigames zzz-minigames
