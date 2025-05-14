#!/usr/bin/env bash

# Configurables
GRUB_DIR=/boot/grub/themes
GRUB_THEME=grub-bgrt
FONTSIZE=24 # See README.md
BGRT_DIR=/sys/firmware/acpi/bgrt

while getopts "b:d:" option; do
	case $option in
		b)
			BGRT_DIR=$OPTARG;;
		d)
			GRUB_DIR=$OPTARG;;
		\?)
			echo "Error: Invalid option"
         		exit;;
	esac
done

# Sanity Checks
if [[ ! -r ${BGRT_DIR}/image ]]; then
	echo "Sorry, I can't read /sys/firmware/acpi/bgrt/image"
	echo "Your system is not suitable for this theme"
	exit 1
fi

command -v convert >/dev/null 2>&1 || { echo >&2 "I require convert (from imagemagick) but it's not installed.  Aborting."; exit 1; }
command -v install >/dev/null 2>&1 || { echo >&2 "I require install (from coreutils) but it's not installed.  Aborting."; exit 1; }
command -v awk >/dev/null 2>&1 || { echo >&2 "I require awk but it's not installed.  Aborting."; exit 1; }

# OK. Convert the image to PNG (grub doesn't support BMPs)
convert ${BGRT_DIR}/image PNG24:theme/bgrt.png

# Replace the placeholders with the image offsets
< theme/theme.txt.in awk \
	-v BGRTLEFT=$(<${BGRT_DIR}/xoffset) \
	-v BGRTTOP=$(<${BGRT_DIR}/yoffset) \
	'{gsub (/\$BGRTLEFT\$/, BGRTLEFT);
	  gsub (/\$BGRTTOP\$/, BGRTTOP);
	  print}' > theme/theme.txt

# Finally, install the theme

install -d ${GRUB_DIR}/${GRUB_THEME}
install -m644 theme/dejavu-mono-12.pf2 ${GRUB_DIR}/${GRUB_THEME}/
install -m644 theme/lato-${FONTSIZE}.pf2 ${GRUB_DIR}/${GRUB_THEME}/
install -m644 theme/{bgrt,background}.png ${GRUB_DIR}/${GRUB_THEME}/
install -d ${GRUB_DIR}/${GRUB_THEME}/progress_bar/
install -m644 theme/progress_bar/progress_bar_{nw,n,ne,w,c,e,sw,s,se,hl_c}.png ${GRUB_DIR}/${GRUB_THEME}/progress_bar/
install -m644 theme/theme.txt ${GRUB_DIR}/${GRUB_THEME}/

echo "Install complete."
echo "To use this theme, add:"
echo "   GRUB_THEME=${GRUB_DIR}/${GRUB_THEME}/theme.txt"
echo "to your grub config (e.g. /etc/default/grub),"
echo "then rebuild grub (e.g. update-grub)."
