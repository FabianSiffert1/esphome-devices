<p align="center">
  <img src="diySunriseAlarmFirstSteps.png" width="450" height="450">
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
credentials and an API key (`openssl rand -base64 32`).

## Roadmap

1. ~~Display showing clock and HA entities~~
2. Momentary button, backlight wake and auto-dim
3. Rotary encoder setting a number
4. MAX98357A + speaker
5. Alarm scheduling — weekday rules, skip-next, extra-tomorrow
6. Standalone I2S mic for HA voice
7. HA / Spotify HUD screen

Most remaining GPIOs are on the buried side of the board, so steps 2–4 need it
reseated or a wider breadboard.
