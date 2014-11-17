#!/bin/bash

CONVERT=convert
OUT_DIR=out
JPEG_QUALITY=75
SED="sed -r"
JPEG_BASE="head -c -4"


# Compresses images into jpegs
# Synopsis: input.png output
# Genreates output.jpg and output_alpha.jpg
function compress_image()
{
	local covert_flags="-layers flatten -quality $JPEG_QUALITY"
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

# Create the files for packaging
# Synopsis: generate subdir [pk3name]
function generate()
{
	PACKAGE=$1
	local pk3_name="$2"
	#local SRC_FILES=$(find $PACKAGE -type f '!' -iname ".*" )
	local SRC_FILES=$(git ls-files "$PACKAGE/*")
	for src_file in $SRC_FILES
	do
		local out_file=$OUT_DIR/$PACKAGE/$(convert_paths ${src_file#$PACKAGE/})
		mkdir -p "$(dirname "$out_file")"
		
		if echo -n "$src_file" | grep -Eq "\.(png|svg|tga|xcf)$"
		then
			local jpeg_base=$(echo -n $out_file | $JPEG_BASE)
			if [ "$src_file" -nt "$jpeg_base.jpg" ]
			then
				echo -e "Compressing \x1b[1m$src_file\x1b[0m"
				compress_image "$src_file" "$jpeg_base"
				scale_image "$jpeg_base"
				continue
			fi
		elif echo -n "$src_file" | grep -Eq "\.serverpackage$" && [ -n "$pk3_name" ]
		then
			local out_file="$OUT_DIR/$PACKAGE/$pk3_name.serverpackage$"
			if [ "$src_file" -nt "$out_file" ]
			then
				echo -e "Creating \x1b[1m$pk3_name.serverpackage\x1b[0m"
				cp "$src_file" "$out_file"
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
}

# Create the package
# Synopsis: package subdir [zzz-package-name-v123.pk3]
function package()
{
	PACKAGE=$1
	PK3_NAME=$2
	
	echo -e "Creating package \x1b[1m$PK3_NAME\x1b[0m"
	( cd "$OUT_DIR/$PACKAGE" && zip -p "../$PK3_NAME" -r * )
	
	echo "Done!"
}

# Get an automatic package name (zzz-subdir-v123.pk3)
# Synopsis: package_name subdir [version number]
function package_name()
{
	if [ -n "$2" ]
	then
		VERSION=$2
	else
		VERSION=$(git describe --tags || echo "unknown")
	fi
	echo "zzz-$1-$VERSION.pk3"
}

SYSTEM_NAME=$(uname)
if [ "$SYSTEM_NAME" = Darwin -o "$SYSTEM_NAME" = FreeBSD ]
then
	SED="sed -E"
	JPEG_BASE="$SED s/.{4}$//"
fi


mkdir -p "$OUT_DIR"

SUBPACKAGES=$(find . -mindepth 1 -maxdepth 1 -type d '!' \( -iname '.*' -o -name out \) -exec basename {} \;)


if [ -z "$1" ]
then
	for subdir in $SUBPACKAGES
	do
		generate $subdir
		package $subdir "$(package_name $subdir)"
	done
fi

while [ "$1" ]
do
	if echo "$SUBPACKAGES" | grep -xqF -e "$1"
	then
		subdir="$1"
		shift 
		
		if [ "$1" = "-o" -a -n "$2" ]
		then
			pk3_name=$2
			echo $pk3_name | grep -qE "\.pk3$" || pk3_name="$pk3_name.pk3"
			shift 2
		elif [ "$1" = "-v" -a -n "$2" ]
		then
			pk3_name=$(package_name $subdir $2)
			shift 2
		else
			pk3_name=$(package_name $subdir)
		fi
		
		generate $subdir "$pk3_name"
		package $subdir "$pk3_name"
	else
		case $1 in
			clean)
				echo -e "Removing old files"
				rm -rf "$OUT_DIR"
				;;
			*)
				echo 1>&2 "Unknown option: $1"
				;;
		esac
		shift
	fi
done