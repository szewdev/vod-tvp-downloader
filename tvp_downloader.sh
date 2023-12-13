#!/bin/bash

if [ "$#" -ge 1 ]; then
    url=$1

    if [ "$#" -ge 2 ]; then
        quality=$2
    else
        quality=5
    fi
else
    echo -e "\nUżycie: $0 ADRES_URL [JAKOSC]\n\nDostępne wartości jakości:"
    echo "[11] => 2160p"
    echo "[9]  => 1080p"
    echo "[7]  => 720p"
    echo "[6]  => 544p"
    echo "[5]  => 450p"
    exit 1
fi

id=$(echo "$url" | awk -F ',' '{print $NF}')

url_api="https://vod.tvp.pl/api/products/vods/$id?lang=pl&platform=BROWSER"

externalUid=$(curl -s "$url_api" | jq -r '.externalUid')
title=$(curl -s "$url_api" | jq -r '.season.serial.title')
if [ "$title" != "null" ]; then
    number=$(curl -s "$url_api" | jq -r '.number')
    filename="$title - odc. $number.mp4"
else
    title=$(curl -s "$url_api" | jq -r '.title')
    filename="$title.mp4"
fi

url_video="https://vod.tvp.pl/sess/TVPlayer2/api.php?id=$externalUid&@method=getTvpConfig&@callback=callback"

video_url=$(curl -s "$url_video" | grep -oP '"https:.*-'$quality'\.mp4"' | tr -d '"' | sed 's/\\//g' | head -1)

if curl --fail -o "$filename" "$video_url"; then
    echo "Plik '$filename' został pobrany."
else
    echo "Błąd: Nie udało się pobrać pliku. Spróbuj dla innej jakości video lub sprawdź, czy adres URL jest poprawny."
fi
