#!/bin/sh

#===========================================================================
#Update this variable ======================================================

thisFont="PublicSans"  #must match the name in the font file
axis="wght" #eg with multiple axis "wdth,wght" --> with comma, no space

#===========================================================================
#Generating fonts ==========================================================

echo "│
└─ █▀█ █░█ █▄▄ █░░ █ █▀▀   █▀ ▄▀█ █▄░█ █▀
   █▀▀ █▄█ █▄█ █▄▄ █ █▄▄   ▄█ █▀█ █░▀█ ▄█
│"
echo "├─ Cleaning font directories
│"
rm -rf ./fonts/ttf/ ./fonts/otf/ ./fonts/variable/ ./fonts/webfonts/
rm -rf ./master_ufo/ ./instance_ufo/

echo "├─ Generating static OTF
│"
mkdir -p ./fonts/ttf
fontmake -g ./sources/$thisFont.glyphs -i -o ttf --output-dir ./fonts/ttf/
fontmake -g ./sources/$thisFont-Italic.glyphs -i -o ttf --output-dir ./fonts/ttf/

echo "│
├─ Generating OTF
│"
mkdir -p ./fonts/otf
fontmake -g ./sources/$thisFont.glyphs -i -o otf --output-dir ./fonts/otf/
fontmake -g ./sources/$thisFont-Italic.glyphs -i -o otf --output-dir ./fonts/otf/

echo "│
├─ Generating variable fonts
│"
mkdir -p ./fonts/variable
fontmake -g ./sources/$thisFont.glyphs -o variable --output-path ./fonts/variable/$thisFont\[wght\].ttf
fontmake -g ./sources/$thisFont-Italic.glyphs -o variable --output-path ./fonts/variable/$thisFont-Italic\[wght\].ttf

#============================================================================
#Post-processing fonts ======================================================

echo "│
├─ Post-processing TTF
│"
ttfs=$(ls ./fonts/ttf/*.ttf)
echo $ttfs
for ttf in $ttfs
do
	gftools fix-dsig --autofix $ttf
	ttfautohint $ttf $ttf.fix
	[ -f $ttf.fix ] && mv $ttf.fix $ttf
	gftools fix-hinting $ttf
	[ -f $ttf.fix ] && mv $ttf.fix $ttf
done

echo "│
├─ Post-processing OTF
│"
otfs=$(ls ./fonts/otf/*.otf)
for otf in $otfs
do
	gftools fix-dsig -f $otf
	#gftools fix-weightclass $otf
	#[ -f $otf.fix ] && mv $otf.fix $otf
done

echo "│
├─ Post-processing variable fonts
│"
vfs=$(ls ./fonts/variable/*.ttf)
for vf in $vfs
do
	#gftools fix-dsig --autofix $vf
	gftools fix-nonhinting $vf $vf.fix
	mv $vf.fix $vf
	gftools fix-unwanted-tables --tables MVAR $vf
	#gftools fix-vf-meta $vf
	#mv $vf.fix $vf
	gftools gen-stat $vf --src ./sources/stat.yaml
	mv $vf.fix $vf
done
rm ./fonts/variable/*gasp*

#============================================================================
#Build woff and woff2 fonts =================================================

echo "│
├─ Building webfonts
│"
mkdir -p ./fonts/webfonts

ttfs=$(ls ./fonts/ttf/*.ttf)
for ttf in $ttfs
do
  woff2_compress $ttf
  sfnt2woff-zopfli $ttf
done

woffs=$(ls ./fonts/ttf/*.woff*)
for woff in $woffs
do
	mv $woff ./fonts/webfonts/
done

echo "│
├─ Syncing ufo/designspace to /sources directory
│"
rsync -avzhr ./master_ufo/ ./sources/ufo/ --delete

echo "│
├─ Cleaning up
│"
rm -rf ./master_ufo/ ./instance_ufo/

echo "│
├─ Test output
│"
fontbakery check-googlefonts --json report.json fonts/ttf/*.ttf

echo "│
└─ ░██████╗██╗░░░██╗░█████╗░░█████╗░███████╗░██████╗░██████╗██╗
   ██╔════╝██║░░░██║██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝██║
   ╚█████╗░██║░░░██║██║░░╚═╝██║░░╚═╝█████╗░░╚█████╗░╚█████╗░██║
   ░╚═══██╗██║░░░██║██║░░██╗██║░░██╗██╔══╝░░░╚═══██╗░╚═══██╗╚═╝
   ██████╔╝╚██████╔╝╚█████╔╝╚█████╔╝███████╗██████╔╝██████╔╝██╗
   ╚═════╝░░╚═════╝░░╚════╝░░╚════╝░╚══════╝╚═════╝░╚═════╝░╚═╝
"
