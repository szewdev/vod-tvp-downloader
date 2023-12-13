import sys
import requests
import re

def download_video(url, quality=5):
    # Wyciąganie ID z URL
    id = url.split(',')[-1]

    url_api = f"https://vod.tvp.pl/api/products/vods/{id}?lang=pl&platform=BROWSER"
    response = requests.get(url_api).json()

    externalUid = response['externalUid']
    title = response.get('season', {}).get('serial', {}).get('title')

    if title:
        number = response['number']
        filename = f"{title} - odc. {number}.mp4"
    else:
        title = response['title']
        filename = f"{title}.mp4"

    url_video = f"https://vod.tvp.pl/sess/TVPlayer2/api.php?id={externalUid}&@method=getTvpConfig&@callback=callback"
    video_response = requests.get(url_video).text

    video_url_search = re.search(f'"https:.*-{quality}\.mp4"', video_response)
    if video_url_search:
        video_url = video_url_search.group(0).replace('\\', '').strip('"')

        try:
            with requests.get(video_url, stream=True) as r:
                r.raise_for_status()
                with open(filename, 'wb') as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)
            print(f"Plik '{filename}' został pobrany.")
        except requests.exceptions.RequestException as e:
            print("Błąd: Nie udało się pobrać pliku.")
    else:
        print("Nie znaleziono URL wideo.")

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        url = sys.argv[1]
        quality = int(sys.argv[2]) if len(sys.argv) >= 3 else 5
        download_video(url, quality)
    else:
        print("\nUżycie: python script.py ADRES_URL [JAKOSC]\n\nDostępne wartości jakości:")
        print("[11] => 2160p")
        print("[9]  => 1080p")
        print("[7]  => 720p")
        print("[6]  => 544p")
        print("[5]  => 450p")
