#!/bin/sh

# -------------------------------------------------------------------
# UPDATE THIS VARIABLE ----------------------------------------------

thisFont="Public-Sans" # must match the name in the font file, e.g. FiraCode-VF.ttf needs the variable "FiraCode"

# -------------------------------------------------------------------
# Update the following as needed ------------------------------------

source env/bin/activate
set -e

cd source

echo "Generating TTF binaries"
mkdir -p ../fonts/webfonts
fontmake -g $thisFont.glyphs -i -o ttf --output-dir ../fonts/webfonts/
fontmake -g $thisFont-italics.glyphs -i -o ttf --output-dir ../fonts/webfonts/

echo "Generating OTF binaries"
mkdir -p ../fonts/otf
fontmake -g $thisFont.glyphs -i -o otf --output-dir ../fonts/otf/
fontmake -g $thisFont-italics.glyphs -i -o otf --output-dir ../fonts/otf/

echo "Generating Variable Fonts"
mkdir -p ../fonts/variable
fontmake -g $thisFont.glyphs -o variable --output-path ../fonts/variable/$thisFont-Roman-VF.ttf
fontmake -g $thisFont-italics.glyphs -o variable --output-path ../fonts/variable/$thisFont-Italic-VF.ttf

echo "Replacing old UFOs"
rm -rf instance_ufo/ ../fonts/ufo
mv master_ufo/ ../fonts/ufo

echo "Post processing"

ttfs=$(ls ../fonts/webfonts/*.ttf)
echo $ttfs
for ttf in $ttfs
do
	gftools fix-dsig --autofix $ttf;
	gftools fix-nonhinting $ttf $ttf;
done
rm ../fonts/webfonts/*backup*.ttf

vfs=$(ls ../fonts/variable/*.ttf)
for vf in $vfs
do
	gftools fix-dsig --autofix $vf;
	gftools fix-nonhinting $vf $vf
done
rm ../fonts/variable/*backup*.ttf

gftools fix-vf-meta $vfs;
for vf in $vfs
do
	mv "$vf.fix" $vf;
done

cd ..

# ============================================================================
# Autohinting ================================================================

statics=$(ls fonts/webfonts/*.ttf)
echo hello
for file in $statics; do
    echo "fix DSIG in " ${file}
    gftools fix-dsig --autofix ${file}

    echo "TTFautohint " ${file}
    # autohint with detailed info
    hintedFile=${file/".ttf"/"-hinted.ttf"}
    ttfautohint -I ${file} ${hintedFile}
    cp ${hintedFile} ${file}
    rm -rf ${hintedFile}

    echo "fix hinting in " ${file}
    gftools fix-hinting ${file}
	  mv "$file.fix" $file;
done


# ============================================================================
# Build woff and woff2 fonts ==========================================================

# requires https://github.com/bramstein/homebrew-webfonttools

ttfs=$(ls fonts/webfonts/*.ttf)
for ttf in $ttfs; do
    woff2_compress $ttf
    sfnt2woff-zopfli $ttf
done