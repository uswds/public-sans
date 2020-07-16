#!/bin/sh

#===========================================================================
#Update this variable ==========================================================

thisFont="PublicSans"  #must match the name in the font file
axis="wght" #eg with multiple axis "wdth,wght" --> with comma, no space

#===========================================================================
#Generating fonts ==========================================================

source ../env/bin/activate
set -e

#echo "CLEAN FONTS FOLDERS"
#rm -rf ./fonts/ttf/ ./fonts/otf/ ./fonts/variable/ ./fonts/webfonts/

echo ".
GENERATING STATIC TTF
."
mkdir -p ../fonts/ttf
fontmake -g $thisFont.glyphs -i -o ttf --output-dir ../fonts/ttf/
fontmake -g $thisFont-Italic.glyphs -i -o ttf --output-dir ../fonts/ttf/

echo ".
GENERATING STATIC OTF
."
mkdir -p ../fonts/otf
fontmake -g $thisFont.glyphs -i -o otf --output-dir ../fonts/otf/
fontmake -g $thisFont-Italic.glyphs -i -o otf --output-dir ../fonts/otf/

echo ".
GENERATING VARIABLE FONTS
."
mkdir -p ../fonts/variable
VF_FILE="../fonts/variable/$thisFont[$axis].ttf"
VF_FILE_IT="../fonts/variable/$thisFont-Italic[$axis].ttf"
fontmake -g $thisFont.glyphs -o variable --output-path $VF_FILE
fontmake -g $thisFont-Italic.glyphs -o variable --output-path $VF_FILE_IT

#============================================================================
#Post-processing fonts ======================================================

echo ".
POST-PROCESSING TTF
."
ttfs=$(ls ../fonts/ttf/*.ttf)
echo $ttfs
for ttf in $ttfs
do
	gftools fix-dsig --autofix $ttf
	ttfautohint $ttf $ttf.fix
	[ -f $ttf.fix ] && mv $ttf.fix $ttf
	gftools fix-hinting $ttf
	[ -f $ttf.fix ] && mv $ttf.fix $ttf
done

echo ".
POST-PROCESSING OTF
."
otfs=$(ls ../fonts/otf/*.otf)
for otf in $otfs
do
	gftools fix-dsig -f $otf
	gftools fix-weightclass $otf
	[ -f $otf.fix ] && mv $otf.fix $otf
done

echo ".
POST-PROCESSING VF
."
vfs=$(ls ../fonts/variable/*.ttf)
for vf in $vfs
do
	gftools fix-dsig --autofix $vf
	gftools fix-nonhinting $vf $vf.fix
	mv $vf.fix $vf
	gftools fix-unwanted-tables --tables MVAR $vf
done
rm ../fonts/variable/*gasp*

gftools fix-vf-meta $VF_FILE $VF_FILE_IT
for vf in $vfs
do
	mv $vf.fix $vf
done

#============================================================================
#Build woff and woff2 fonts =================================================
#requires https://github.com/bramstein/homebrew-webfonttools

echo ".
BUILD WEBFONTS
."
mkdir -p ../fonts/webfonts

ttfs=$(ls ../fonts/ttf/*.ttf)
for ttf in $ttfs
do
  woff2_compress $ttf
  sfnt2woff-zopfli $ttf
done

woffs=$(ls ../fonts/ttf/*.woff*)
for woff in $woffs
do
	mv $woff ../fonts/webfonts/
done

rm -rf master_ufo/ instance_ufo/

echo ".
COMPLETE!
."
