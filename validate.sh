#!/bin/bash

echo "=== Validating ExifTool"

which exiftool
exiftool -ver

echo "=== Validating ImageMagick"

which convert
magick -list format
convert -version | tee imagemagick_version.txt

echo "=== Completed Build."
