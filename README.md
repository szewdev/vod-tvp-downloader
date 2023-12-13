# vod-tvp-downloader
Skrypty umożliwiające pobieranie plików wideo z serwisu vod.tvp.pl

## Skrypt bash (tvp_downloader.sh)
Wymagane są zainstalowane następujące pakiety:
- curl
- jq
- grep
- sed

### Użycie skryptu
Przed pierwszym uruchomieniem należy wykonać polecenie `chmod +x tvp_downloader.sh`

Uruchomienie skryptu odbywa się poprzez wywołanie polecenia

`./tvp_downloader.sh ADRES_URL [JAKOSC]`

- **ADRES_URL** - jako wartość tego parametru należy podać cały adres url strony z interesującym nas materiałem wideo (w ramach serwisu vod.tvp.pl)

- **JAKOSC** - ten parametr jest opcjonalny, a jego domyślna wartość to _5_. 

Dostępne wartości to:
| Wartość parametru | Rozdzielczość materiału wideo |
|--|--|
| 11 | 2160p |
| 9 | 1080p |
| 7 | 720p |
| 6 | 544p |
| 5 | 450p |

_Możliwość pobrania pliku wideo w interesującej nas rozdzielczości zależy od jego dostępności w tej jakości w serwisie vod.tvp.pl._
