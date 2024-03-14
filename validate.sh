#!/bin/bash

echo "=== Validating ExifTool"

which exiftool
exiftool -ver

echo "=== Validating ImageMagick"

which convert
convert -list configure 
convert -version | tee imagemagick_version.txt

echo "=== Completed Build."
