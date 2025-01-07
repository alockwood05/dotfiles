#!/bin/bash

# Usage: audio_to_aiff.sh <audio_file>

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <audio_file>"
    exit 1
fi

# Get the input file and derive the output file name
input_file="$1"
output_file="${input_file%.*}.aiff"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

# Convert the input file to AIFF format
ffmpeg -i "$input_file" -write_id3v2 1 -c:v copy "$output_file"

# Check if the conversion was successful
if [ $? -eq 0 ]; then
    echo "Conversion successful: '$output_file' created."
else
    echo "Error: Conversion failed."
    exit 1
fi
