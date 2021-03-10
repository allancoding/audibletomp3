#!/bin/sh -efu

input="../files/Your Book!.mp3"
ffprobe \
    -print_format csv \
    -show_chapters \
    "$input" |
cut -d ',' -f '5,7,8' |
while IFS=, read start end chapter
do
    ffmpeg \
        -nostdin \
        -ss "$start" -to "$end" \
        -i "$input" \
        -c copy \
        -map 0 \
        "${input%.*}-$chapter.${input##*.}"
done