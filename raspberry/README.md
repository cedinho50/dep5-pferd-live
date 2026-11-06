# Pferd Live auf dem Raspberry

Holt den YouTube-Livestream «Der ungezähmte Horizont» auf den Raspberry Pi und stellt ihn als eigene Webseite bereit. Die Ariadne-Anzeigetafel spricht so nur mit der eigenen Domain, nie direkt mit YouTube.

## Aufbau

| Teil | Aufgabe |
|---|---|
| `restream` | Holt den Livestream mit streamlink, ffmpeg macht daraus einen HLS-Stream (ohne Neukodierung, wenig CPU) |
| `web` | nginx liefert die Seite und den Stream auf Port 8099 aus |
| Volume `hls` | Videostücke liegen im Arbeitsspeicher, nicht auf der Karte |

## Installation

```bash
git clone https://github.com/cedinho50/dep5-pferd-live.git
cd dep5-pferd-live/raspberry
docker compose up -d --build
```

Prüfen: im Heimnetz `http://IP-DES-PI:8099` öffnen. Nach 20 bis 30 Sekunden läuft das Video.

Logs ansehen:

```bash
docker logs -f pferd-restream
```

## Freigabe über Cloudflare Tunnel

Im Cloudflare-Dashboard unter Zero Trust → Networks → Tunnels → bestehender Tunnel → Public Hostname hinzufügen:

- Subdomain: `pferd`
- Domain: `gym-cedricberli.work`
- Service: `HTTP` → `localhost:8099` (bzw. `IP-DES-PI:8099`, falls cloudflared in einem Container läuft)

Wichtig: Für diese Subdomain **keine** Cloudflare-Access-Regel einrichten. Die Anzeigetafel kann sich nicht anmelden.

## Neuer Livestream

Startet der Kanal einen neuen Stream, ändert sich oft die Video-ID. Dann in `docker-compose.yml` die Zeile `YOUTUBE_URL` anpassen und neu starten:

```bash
docker compose up -d
```

## Aktualisieren

```bash
git pull
docker compose up -d --build
```

## Stoppen

```bash
docker compose down
```
