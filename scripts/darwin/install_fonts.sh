#
# This script installs all downloaded fonts
# NOTE: this script should not be used directly, it is sourced by the install.sh
#

mkdir -p ~/Library/Fonts
cp -f ${FONTS_DOWNLOAD_DIR}/*.ttf ~/Library/Fonts/ || true
cp -f ${FONTS_DOWNLOAD_DIR}/*.otf ~/Library/Fonts/ || true
