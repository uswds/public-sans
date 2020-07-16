#!/bin/sh

#===========================================================================
#Update this variable ==========================================================

thisFont="PublicSans"  #must match the name in the font file
thisFontIt="PublicSans-italics"
axis="wght"

#===========================================================================
#Generating fonts ==========================================================

source ../env/bin/activate
set -e

#echo "CLEAN FONTS FOLDERS"
#rm -rf ../fonts/ttf/ ../fonts/otf/ ../fonts/variable/ ../fonts/webfonts/

echo ".
GENERATING VARIABLE FONTS
."
mkdir -p ../fonts/variable
VF_FILE=../fonts/variable/$thisFont\[$axis]\.ttf
VF_IT_FILE=../fonts/variable/$thisFont-Italic\[$axis]\.ttf

glyphs2ufo $thisFont.glyphs --generate-GDEF
fontmake -m $thisFont.designspace -o variable --output-path $VF_FILE

glyphs2ufo $thisFontIt.glyphs --generate-GDEF
fontmake -m $thisFontIt.designspace -o variable --output-path $VF_IT_FILE

#============================================================================
#Post-processing fonts ======================================================

echo ".
POST-PROCESSING VF
."
vfs=$(ls ../fonts/variable/*.ttf)
for vf in $vfs
do
	gftools fix-dsig --autofix $vf
	gftools fix-nonhinting $vf $vf.fix
	mv $vf.fix $vf
	gftools fix-unwanted-tables -t MVAR $vf
done

rm ../fonts/variable/*gasp*

python3 PublicSans_stat_table.py $VF_FILE

rm -rf *ufo #$thisFont.designspace $thisFontIt.designspace

echo ".
COMPLETE!
."
