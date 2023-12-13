param(
    [string]$url,
    [int]$quality = 5
)

if (-not $url) {
    Write-Host "`nUżycie: .\tvp_downloader.ps1 ADRES_URL [JAKOSC]`n`nDostępne wartości jakości:"
    Write-Host "[11] => 2160p"
    Write-Host "[9]  => 1080p"
    Write-Host "[7]  => 720p"
    Write-Host "[6]  => 544p"
    Write-Host "[5]  => 450p"
    exit 1
}

$id = $url -split ',' | Select-Object -Last 1

$url_api = "https://vod.tvp.pl/api/products/vods/"+$id+"?lang=pl&platform=BROWSER"

try {
    $response = Invoke-WebRequest -Uri $url_api
    $content = $response.Content | ConvertFrom-Json
} catch {
    Write-Host "Błąd: Nie można połączyć się z API."
    exit 1
}

$externalUid = $content.externalUid
$title = $content.season.serial.title
if ($title -ne $null) {
    $number = $content.number
    $filename = "$title - odc. $number.mp4"
}
else {
    $title = $content.title
    $filename = "$title.mp4"
}

$url_video = "https://vod.tvp.pl/sess/TVPlayer2/api.php?id=$externalUid&@method=getTvpConfig&@callback=callback"

try {
    $response = Invoke-WebRequest -Uri $url_video
    $video_url_pattern = "https:.*-$quality\.mp4"
    $matches = [regex]::Matches($response.Content, $video_url_pattern)
} catch {
    Write-Host "Błąd: Nie można pobrać adresu URL wideo."
    exit 1
}

if ($matches.Count -gt 0) {
    $video_url = $matches[0].Value -replace '\\', ''
    try {
        Invoke-WebRequest -Uri $video_url -OutFile $filename
        Write-Host "Plik '$filename' został pobrany."
    }
    catch {
        Write-Host "Błąd: Nie udało się pobrać pliku. Spróbuj dla innej jakości video lub sprawdź, czy adres URL jest poprawny."
    }
}
