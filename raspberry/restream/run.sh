#!/bin/sh
# Holt den YouTube-Livestream und schreibt ihn als HLS-Stream nach /hls.
# Bricht der Stream ab, startet die Schleife nach kurzer Pause neu.

URL="${YOUTUBE_URL:-https://www.youtube.com/watch?v=0at5Han4CPA}"
QUALITY="${QUALITY:-720p,480p,best}"

mkdir -p /hls

while true; do
  echo "$(date '+%Y-%m-%d %H:%M:%S') Starte Stream: $URL ($QUALITY)"
  rm -f /hls/*.ts /hls/*.m3u8

  streamlink --stdout --retry-streams 10 --retry-open 3 "$URL" "$QUALITY" \
    | ffmpeg -hide_banner -loglevel warning \
        -i pipe:0 \
        -map 0:v:0 -c:v copy -an \
        -f hls \
        -hls_time 4 \
        -hls_list_size 6 \
        -hls_flags delete_segments+omit_endlist \
        -hls_segment_filename /hls/seg_%05d.ts \
        /hls/stream.m3u8

  echo "$(date '+%Y-%m-%d %H:%M:%S') Stream beendet, neuer Versuch in 15 Sekunden"
  sleep 15
done
