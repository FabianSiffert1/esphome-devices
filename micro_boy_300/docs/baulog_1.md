# Micro-Boy 300 – Baulog

Sep 27, 2026 · @Fabi

## Das Projekt

Ein ESPHome-Sprachsatellit für Home Assistant Assist, eingebaut in ein Grundig Micro Boy 300 (Taschenradio, ca. 8 × 6 × 2,5 cm). Das Wake Word läuft auf dem Gerät, Spracherkennung und Sprachausgabe laufen lokal auf dem NUC.

## Aufbau auf dem Breadboard

Der Prototyp läuft auf einem ESP32-S3 DevKitC-1 (N16R8) mit INMP441-Mikrofon und 0,91"-OLED (SSD1306).

- Wake Word „Hey Beepoh“ (microWakeWord), „Okay Nabu“ als Reserve
- Push-to-Talk-Taster und Stummschalter
- OLED-Gesicht mit sieben Zuständen: bereit, hört zu, denkt nach, antwortet, Fehler, stumm, nicht verstanden
- HA-Pipeline: Speech-to-Phrase (STT) und Piper (TTS) im Docker auf dem NUC. Whisper ist für Deutsch auf dem i3 zu langsam.

## Problem: Brummen im Mikrofon

Das Mikrofon brummte. Speech-to-Phrase hängte dadurch Wörter an („mach Cozy aus in Küche“), und das Wake Word reagierte schlechter.

Zwei Ursachen wurden gefunden:

- **OLED:** Das Panel zieht beim Zeichnen pulsierenden Strom, der über die gemeinsame Versorgung im Mikrofon landet.
- **Mikrofon beschädigt:** Beim Löten ist Flux in die Schallöffnung gelaufen.

Als Notlösung: OLED-Kontrast 30 %, stehendes Bild beim Zuhören, Neuzeichnen nur bei Bildänderung, `gain_factor: 4`, `volume_multiplier: 2.0`.

## 27.09. – Brummen gelöst

Das Brummen ist weg, die Aufnahmen sind klar und fast ohne Knacken.

- Neues INMP441 (gleiches Modell) eingelötet, Schallöffnung dabei abgeklebt.
- Breadboard-Power-Modul entfernt, alles läuft über USB.
- Mikrofon an eigenen 3V3- und GND-Pins, L/R an GND.
- Ein Rest-Summen verschwand im nächsten Test ebenfalls, vermutlich kam es vom MacBook.

Danach Verstärkung zurückgenommen: `gain_factor` 4 → 1, `volume_multiplier` 2.0 → 1.0.

Mikrotausch und Entfernen des Power-Moduls passierten gleichzeitig. Welcher Anteil auf was geht, ist offen.

## 27.09. – 5 V, LEDs, Schalter, Taster

Alle Bedienelemente und die LEDs laufen auf dem Breadboard.

- **5 V:** Lötbrücke IN-OUT geschlossen, der 5V-Pin liefert jetzt USB-Spannung. Die erste Messung zeigte 0,8 V, das Kabel steckte im falschen Loch. Das Power-Modul darf nicht mehr an den 5V-Pin, solange USB steckt.
- **LEDs:** WS2812-Streifen an GPIO21. Alle Zustände stimmen, kein Flackern, der 74AHCT125 ist nicht nötig. Helligkeit per `color_correct` auf 40 %.
- **Wake-Word-Schalter (neu):** Schiebeschalter an GPIO12. Aus = Wake Word deaktiviert, nur Push-to-Talk. Der Stummschalter hat Vorrang. Zuerst an GPIO18 gesteckt, weil „18. Pin“ als Beschriftung gelesen wurde.
- **Taster:** an GPIO11, diagonal gegenüberliegende Beine verwenden.

## 27.09. – Notlösungen zurückgenommen (Test offen)

Zwei Brumm-Kompromisse sind in der Config zurückgenommen, der Test steht noch aus.

- OLED-Kontrast 30 % → 100 %
- Zuhören ist kein stehendes Bild mehr: Die Augen „atmen“ im 0,6-s-Takt, passend zum LED-Pulsieren.

„Neuzeichnen nur bei Bildänderung“ bleibt. Kommt das Brummen zurück, zuerst den Kontrast wieder senken.

## 27.09. – Schlafende Augen und kürzere Anzeigezeit

Das Gesicht zeigt jetzt an, wenn das Wake Word per Schalter ausgeschaltet wird.

- **Schalter aus:** 3 s schlafende Augen (Bögen und „z z“), danach wird das Display dunkel. Neuer Zustand 7.
- Nur aus „bereit“: Laufende Anfragen oder der Stumm-Zustand werden nicht unterbrochen.
- **Schalter an:** Die schlafenden Augen verschwinden sofort.
- Nach einer Anfrage bleibt das Gesicht 10 s statt 15 s sichtbar, dann wird das Display dunkel.

## Als Nächstes

- [ ] Kontrast 100 % und Zuhör-Animation testen („mach Cozy aus“)
- [ ] Schlafende Augen und 10-s-Anzeigezeit testen
- [ ] Debug-Aufnahmen in HA abschalten, WAVs löschen
- [ ] Gehäuse-Layout mit Pappmodellen, LED-Anzahl festlegen
- [ ] Träger im CAD konstruieren
- [ ] Sobald der Verstärker da ist: MAX98357A anschließen, Sprachausgabe testen, danach Mikro erneut prüfen