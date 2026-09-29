<p align="center">
  <img src="helios_01/firstSteps.png" width="450" height="450">
</p>

# HELIOS-01

Sunrise alarm clock. ESP32-S3 with a 2.4" parallel TFT, talking to Home Assistant
over the native ESPHome API.

**Status: work in progress.** Display and Home Assistant data are working. No sound,
no buttons, still on a breadboard.

## How it works

Home Assistant owns the alarm time and the light ramp — a Zigbee bulb brought up over
20–30 minutes via `light.turn_on` with a transition. The device plays the alarm sound
once the ramp finishes, and shows the clock, the armed alarm and a temperature
reading in the meantime.

Deliberately, the device holds no schedule logic. HA resolves when the next alarm is
and exposes the answer as a single entity; the display just renders it. Keeps the
rules in one place, where they can be debugged in a UI instead of a flash cycle.

## Hardware

- ESP32-S3 DevKitC-1 (N16R8 — 16 MB flash, 8 MB octal PSRAM)
- 2.4" TFT, ILI9341, **8-bit parallel** (not SPI), Arduino shield form factor
- HW-131 breadboard power supply, 5V via its USB-A input
- Planned: MAX98357A + speaker, momentary button, rotary encoder

The parallel bus is driven as octal SPI, with `LCD_WR` as the clock — in 8080 mode WR
is the strobe that latches each byte, which is exactly what a clock does.

## Home Assistant entities

| Entity | Purpose |
|---|---|
| `input_datetime.sunrise_alarm` | Alarm time (time only, no date) |
| `input_boolean.alarm_enabled` | Whether the alarm is armed |
| `sensor.wohnzimmer_temperature` | Template sensor off the thermostat's `current_temperature` |

The device subscribes to these over the API; HA pushes state changes. Nothing to
configure per-entity beyond adopting the device.

## Gotchas

- **`dimensions` is the surface after `transform`, not the native panel.** With
  `swap_xy: true` it must be 320 x 240. Getting this wrong renders as corruption,
  not as an error.
- **20 MHz is the ceiling on breadboard.** 40 MHz inits cleanly and shows nothing.
  Retry it once this is soldered with short wires.
- **A parallel bus is write-only.** Clean logs say nothing about whether an image is
  on screen. Always check the panel.
- **Watch for OTA rollback.** Check the `compiled on` timestamp after every flash,
  and leave power on for the first minute.
- Never use the power module's barrel jack — a 12V adapter put 11V on the 5V rail.

## Setup

`secrets.yaml` is gitignored. Copy `secrets.yaml.example` and fill in WiFi
credentials, an API key (`openssl rand -base64 32`) and an OTA password. Keys and
passwords are per device (`helios_01_api_key`, `helios_01_ota_password`); only the
WiFi credentials are shared.

## Roadmap

1. ~~Display showing clock and HA entities~~
2. Momentary button, backlight wake and auto-dim
3. Rotary encoder setting a number
4. MAX98357A + speaker
5. Alarm scheduling — weekday rules, skip-next, extra-tomorrow
6. Standalone I2S mic for HA voice (prototyped in the Micro-Boy 300, see below)
7. HA / Spotify HUD screen

Most remaining GPIOs are on the buried side of the board, so steps 2–4 need it
reseated or a wider breadboard.

---
# Micro-Boy 300
<p align="center">
  <img src="micro_boy_300/docs/micro_boy_300.jpg" width="300" height="450">
</p>

## OpenSCAD Prototype 1
<p align="center">
  <img src="micro_boy_300/docs/prototype1front.png" width="20%" height="20%">
 <img src="micro_boy_300/docs/prototype1back.png" width="20%" height="20%">
</p>



## Introduction
Voice satellite for Home Assistant Assist, headed for the case of a Grundig Micro
Boy 300 pocket radio (8 × 6 × 2.5 cm). The wake word runs on the device; speech
recognition and speech output run locally on the server.

**Status: work in progress.** Wake word, voice commands, OLED face, LED status,
mute switch, wake word switch and push-to-talk button all work on the breadboard.
Mic hum is fixed. Amplifier is next; no audio output yet.

## How it works

The ESP listens for the wake word ("Hey Beepoh", with "Okay Nabu" as backup) using
microWakeWord, then streams audio to HA. The pipeline uses Speech-to-Phrase for
speech-to-text and Piper for the reply, both as a Docker stack in `~/docker/voice`.

A 0.91" OLED shows a face for each state: ready, listening, thinking, replying,
error, muted, not understood. It redraws only when the image changes and goes dark
after 10 s idle. The LEDs follow the same states: blue pulse while listening,
purple while thinking, green while replying, red on errors, orange when not
understood, dim red while muted, off when idle.

Controls:

- **Mute switch** silences the mic. Overrides everything, including the button.
- **Wake word switch** turns the wake word off; requests then only start by button.
  Switching it off shows sleeping eyes for 3 s.
- **Push-to-talk button** starts or stops a request without the wake word.

## Hardware

- ESP32-S3 DevKitC-1 (N16R8), both on the breadboard and in the final build — it
  fits the case with the headers removed. IN-OUT solder bridge closed so the 5V pin
  carries USB power.
- INMP441 I2S MEMS microphone
- SSD1306 OLED, 0.91", 128 × 32, I2C
- WS2812 ECO strip, 7 LEDs
- 2 slide switches (mute, wake word), momentary button (push-to-talk)
- Planned: MAX98357A + QUARKZMAN 3 W / 4 Ω speaker (44 × 31 × 15 mm), USB-C breakout
  with 5.1 kΩ CC resistors, 1N5819 Schottky diode

| Part | Pins |
|---|---|
| INMP441 | VDD 3V3 and GND on their own pins, WS GPIO4, SCK GPIO5, SD GPIO6, L/R to GND |
| OLED | VCC 3V3 and GND on other pins than the mic, SDA GPIO8, SCL GPIO9 |
| MAX98357A | VIN 5V, LRC GPIO7, BCLK GPIO15, DIN GPIO16 |
| WS2812 | 5V, DIN GPIO21 via 330 Ω |
| Mute switch | GPIO10 to GND |
| Push-to-talk | GPIO11 to GND |
| Wake word switch | GPIO12 to GND |

GPIO numbers refer to the board's silkscreen labels, not pin positions.

## Gotchas

- **Unsoldered headers fail silently.** The INMP441 shipped with loose pins; pressed
  in, the mic delivered pure silence and no error. Solder every header.
- **Mic and OLED must not share a supply.** The OLED draws pulsed current while
  drawing, which shows up as hum in the mic. Give the mic its own 3V3 and GND pins.
- **Flux ruins the mic.** Flux in the sound port made the first INMP441 sound muffled.
  Tape the port before soldering.
- **Testing on a laptop can add hum.** USB ground noise from a MacBook showed up in
  recordings. Compare recordings on a phone charger.
- **Speech-to-Phrase, not Whisper.** The server's i3-5010U is too slow for Whisper in
  German. Speech-to-Phrase only knows exposed entities — restart the container after
  exposing or renaming anything.
- **The wake word dropdown in HA shows "unavailable"** (probably the nightly build).
  The first model in the list is active by default, so Hey Beepoh goes first.
- **Debug recordings are public.** `debug_recording_dir` under `/config/www` is served
  under `/local/` without auth. Delete the files and remove the option after
  debugging.
- **Mute is software-only.** Cutting the mic's power doesn't reliably silence it —
  the I2S clocks partly power the chip through its pins.
- **Two 5V sources need a diode.** With the IN-OUT bridge closed, the 5V pin is tied
  to USB. Never connect a second 5V source there while USB is plugged in, unless a
  Schottky diode (cathode to the 5V rail) blocks back-feeding.
- **Write lambdas as block scalars.** `lambda: x ? 5 : 0;` on one line breaks YAML
  parsing — the ` : ` reads as a mapping. Use `lambda: |-` and put the code below.
- **LED 0 is skipped** in the breadboard phase — it sits too close to the strip's plug.
  Final build: `num_leds: 7`, partition `from: 0` to `to: 6`.

## Setup

Uses the same shared `secrets.yaml` with its own entry: `micro_boy_300_api_key`.
OTA is encrypted with the API key, so `micro_boy_300_ota_password` is no longer
needed. 