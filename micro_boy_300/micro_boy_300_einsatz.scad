include <BOSL2/std.scad>
$fn = 64;

// ============================================================
// Grundig Micro Boy 300 – Einsatz für ESP32 Voice Assistant
// ============================================================
// Koordinaten (Blick ins geöffnete Gehäuse, so wie gemessen):
//   X → rechts   (0 = linke Innenwand)
//   Y → oben     (0 = untere Innenwand)
//   Z → hinten   (0 = Innenseite der Front mit Lautsprechergitter/Ausguck)
// Alle Maße in mm. "TODO" = geschätzt oder angenommen, bitte nachmessen.
//
// Druckteile:
//   front_insert – Platte vorne mit Lautsprecher- und OLED-Halter
//   carrier      – Elektronik-Träger hinten mit ESP32-Podest, Verstärker-Bucht
//                  und USB-C-Turm
//   mic_switch_plug – Blende für eine Seitenöffnung: Mikrofon + Ein/Aus-Schalter
//   led_button_plug – Blende für die andere Seite: LED + Taster (hell drucken!)
//   switch_cap / button_cap – Druckkappen für Schalter und Taster
// Front-Einsatz und Träger werden gemeinsam mit den Originalschrauben
// an den oberen Fassungen verschraubt.
//
// Export: export_part auf das Teil stellen, F6, als 3MF/STL exportieren.
// Jedes Teil liegt dann bereits in Druckrichtung.

// ============================================================
// Parameter
// ============================================================

/* [Export] */
export_part = "preview"; // [preview, front_insert, carrier, mic_switch_plug, led_button_plug, switch_cap, button_cap]

/* [Anzeige (nur Vorschau)] */
show_case_reference = true;   // Gehäuse als Referenz (wird nie gedruckt)
show_front_insert   = true;
show_carrier        = true;
show_side_plugs     = true;
show_dummies        = true;   // Bauteile als Platzhalter

/* [Gehäuse innen] */
case_inner_width  = 64;
case_inner_height = 94.2;
case_outer_depth          = 30;   // laut Radiomuseum (70 × 110 × 30 mm)
case_wall                 = 3.3;
case_back_cover_thickness = 2;    // TODO: Rückwand nachmessen
case_inner_depth          = case_outer_depth - case_wall - case_back_cover_thickness;

/* [Schnalle oben mittig] */
buckle_distance_from_side = 27;   // Seitenwand bis Schnalle (beidseitig gleich)
buckle_protrusion         = 2.5;  // so weit ragt sie von oben in den Innenraum
buckle_depth              = case_inner_depth;  // TODO: Ausdehnung in Z

/* [Seitenöffnungen links und rechts] */
side_opening_distance_from_top = 8.5;
side_opening_length            = 24;
side_opening_z_start           = 5;    // TODO: Abstand Front-Innenseite bis Öffnung
side_opening_z_size            = 10;   // TODO: Höhe der Öffnung in Z

/* [Obere Schraubfassungen, unter den Seitenöffnungen] */
upper_boss_outer_d            = 5.7;
upper_boss_hole_d             = 2.5;
upper_boss_height             = 8;     // Höhe in Z ab Front
upper_boss_distance_from_wall = 6.9;   // Seitenwand bis innere Kante der Fassung
upper_boss_gap_below_opening  = 1;     // Oberkante so weit unter dem Ende der Öffnung

/* [Untere Schraubfassungen] */
lower_boss_outer_d             = 5.7;
lower_boss_hole_d              = 2.5;
lower_boss_height              = 12;
lower_boss_distance_from_wall  = 6.9;  // Seitenwand bis innere Kante der Fassung
lower_boss_distance_from_floor = 5;    // TODO: untere Wand bis Unterkante der Fassung

/* [Mittlere Schraubfassung] */
center_boss_outer_d             = 6.12;
center_boss_hole_d              = 2;
center_boss_height              = 4;
center_boss_distance_from_right = 28.9;  // rechte Wand bis rechte Kante der Fassung
center_boss_center_y            = 52;    // TODO: Höhe nachmessen

/* [Ausguck] */
window_width              = 47.36;
window_distance_from_left = 5;
// Annahme: Ausguck liegt auf Höhe der Seitenöffnungen und hat eine
// durchsichtige Scheibe, gegen die der OLED-Halter drückt.

/* [Lautsprechergitter] */
speaker_grille_diameter            = 51;
speaker_grille_distance_from_floor = 5.3;

/* [Lautsprecher-Modul 3 W 4 Ohm] */
// Herstellerangabe 44 × 31 × 15 mm – TODO: nachmessen, ggf. inkl. Befestigungslaschen
speaker_length           = 44;
speaker_width            = 31;
speaker_depth            = 15;
speaker_offset_on_grille = [0, 0];  // Feinjustage gegenüber der Gittermitte

/* [Lautsprecher-Halter] */
speaker_fit_tolerance = 0.2;   // Spiel pro Seite – klein halten, sitzt dann stramm
speaker_holder_wall   = 1.6;
speaker_lip_overlap   = 1.5;   // so weit greift der vordere Rahmen über den Rand (45°-Fase)

/* [OLED 0,91 Zoll 128x32] */
// TODO: typische Werte dieser Module – am echten Modul nachmessen!
oled_pcb_length       = 38;
oled_pcb_width        = 12;
oled_pcb_thickness    = 1.2;
oled_glass_length     = 30;
oled_glass_width      = 11.5;
oled_glass_thickness  = 1.5;
oled_glass_offset     = 1;      // Glasmitte gegenüber Platinenmitte, weg von den Pins
oled_active_length    = 22.4;   // leuchtende Fläche
oled_active_width     = 5.6;
oled_pin_zone_length  = 5;      // Bereich der Stiftleiste am Platinenende
oled_pins_on_left     = true;   // Stiftleiste zeigt nach links (-X)
oled_offset_in_window = [0, 0]; // Feinjustage gegenüber der Ausguck-Mitte

/* [OLED-Halter] */
oled_fit_tolerance     = 0.2;   // Spiel pro Seite
oled_holder_wall       = 1.6;
oled_front_lip         = 0.8;   // Rahmen vor dem Glas, hält das Modul nach vorne
oled_view_margin       = 0.8;   // Sichtfenster so viel größer als die Leuchtfläche
oled_back_ledge        = 1.2;   // Auflage hinter der Platine an den Längsseiten
oled_back_relief_depth = 1.5;   // Freiraum für Bauteile auf der Platinenrückseite
oled_cable_channel_to_plate_edge = true; // Kabelkanal bis zum Plattenrand, damit
                                         // das Modul mit angelöteten Kabeln einschiebbar ist

/* [Front-Einsatz (Platte)] */
wall_clearance    = 0.3;   // Spiel zur Gehäusewand
plate_thickness   = 1.2;
plate_z           = upper_boss_height;  // Platte liegt auf den oberen Fassungen
screw_clearance_d = 2.6;   // TODO: an deine Schrauben anpassen

/* [Elektronik-Träger] */
carrier_thickness = 1.6;   // liegt direkt hinter der Front-Platte

/* [ESP32-S3-DevKitC-1] */
// Espressif-Referenz 62,74 × 25,4 mm – Klone sind teils etwas länger. TODO: nachmessen
esp_board_length      = 62.74;
esp_board_width       = 25.4;
esp_board_thickness   = 1.6;
esp_module_height     = 3.3;   // WROOM-Modul auf der Oberseite
esp_header_below      = 0;     // 0 = Stiftleisten entfernt; mit Stiftleisten ca. 11
esp_offset_x          = 0;     // seitliche Verschiebung gegenüber der Mitte
esp_gap_to_buckle     = 0.5;
esp_gap_above_speaker = 1;     // Luft zwischen Lautsprecher-Rückseite und Platine
esp_platform_inset    = 2.0;   // Podest schmaler als die Platine (Platz für Lötpads)
esp_platform_wall     = 1.6;

/* [Verstärker MAX98357A] */
// Liegt flach auf dem Träger in einer Bucht im ESP32-Podest, unter dem ESP32.
// TODO: typische Werte der Breakouts – nachmessen! Schraubklemme nicht einlöten.
amp_board_length     = 19.4;  // in Y
amp_board_width      = 17.8;  // in X
amp_board_thickness  = 1.6;
amp_component_height = 1.5;   // Bauteile auf der Oberseite
amp_fit_tolerance    = 0.2;

/* [USB-C-Buchse (Breakout)] */
// TODO: typische Werte kleiner USB-C-Breakouts – nachmessen!
usb_board_length         = 14;   // quer zur Buchse
usb_board_height         = 11;   // in Steckrichtung
usb_board_thickness      = 1.6;
usb_receptacle_thickness = 3.3;  // Standard-USB-C-Buchse
usb_receptacle_width     = 9;
usb_center               = [51.5, 83];  // Position auf dem Träger
usb_port_face_z          = case_inner_depth; // Buchse bündig mit der Innenseite der Rückwand
usb_tower_top_below_face = 2;    // so weit schaut die Platine oben aus dem Turm
usb_tower_wall           = 1.6;
usb_fit_tolerance        = 0.2;
usb_wire_window_height   = 4;

/* [Seitenblenden] */
mic_on_right_side          = true;  // Mikrofon + Schalter rechts, LED + Taster links
side_plug_fit_tolerance    = 0.15;  // Presssitz in der Öffnung
side_plug_flange_overlap   = 0.8;   // Flansch innen größer als die Öffnung
side_plug_flange_thickness = 1.2;
side_plug_pocket_wall      = 1.2;

/* [Mikrofon INMP441] */
mic_pcb_diameter       = 15;    // runde Platine, ca. 15 mm – TODO nachmessen
mic_pcb_thickness      = 1.2;
mic_fit_tolerance      = 0.2;
mic_pocket_extra_depth = 0.6;   // Rand steht etwas über die Platine
mic_wire_notch_width   = 8;
mic_grille_slot_count  = 3;
mic_grille_slot_width  = 1.2;
mic_grille_slot_pitch  = 2.4;
mic_grille_slot_length = 5;

/* [Ein/Aus-Schalter (rastend), in der Mikrofon-Blende] */
// TODO: typische Werte für 8,5 × 8,5 mm Druckschalter mit Rastung – nachmessen!
switch_body_size      = 8.5;   // quadratischer Körper
switch_body_height    = 7;     // ohne Stößel und Pins
switch_plunger_height = 3;     // Überstand des Stößels im ausgeschalteten Zustand
switch_cap_hole_d     = 5;     // Loch für die Druckkappe

/* [Taster (Wakeword überspringen), in der LED-Blende] */
// TODO: typische Werte für 6 × 6 mm Taster – nachmessen!
button_body_size      = 6;
button_body_height    = 3.5;
button_plunger_height = 1.5;
button_cap_hole_d     = 4;

/* [Druckkappen und Schaltertaschen] */
cap_protrusion          = 1.5;  // so weit steht die Kappe außen über
cap_collar_thickness    = 1;    // Bund innen, hält die Kappe in der Blende
cap_collar_overlap      = 1;    // Bund so viel größer als das Loch
cap_fit_tolerance       = 0.15;
switch_pocket_tolerance = 0.2;
switch_back_wall        = 1.2;  // stützt den Schalter beim Drücken
side_plug_boss_margin   = 0.3;  // Abstand der Taschen zur oberen Fassung

/* [LED WS2812, 144 LEDs/m] */
led_count            = 2;
led_pitch            = 1000 / 144;  // ≈ 6,94 mm pro LED
led_strip_width      = 12;    // TODO: je nach Streifen 10 oder 12 mm
led_strip_thickness  = 2.2;   // Platine + LED – TODO
led_fit_tolerance    = 0.3;
led_wire_notch_width = 5;

// ============================================================
// Abgeleitete Werte
// ============================================================

buckle_width          = case_inner_width - 2 * buckle_distance_from_side;
side_opening_top      = case_inner_height - side_opening_distance_from_top;
side_opening_bottom   = side_opening_top - side_opening_length;
side_opening_center_y = (side_opening_top + side_opening_bottom) / 2;
side_opening_center_z = side_opening_z_start + side_opening_z_size / 2;
plate_back_z          = plate_z + plate_thickness;
carrier_z             = plate_back_z;
carrier_back_z        = carrier_z + carrier_thickness;

// Position einer Fassung rechts plus ihr Spiegelbild links
function mirrored_pair(distance_from_wall, outer_d, center_y) =
    let(right_x = case_inner_width - distance_from_wall + outer_d / 2)
    [[right_x, center_y], [case_inner_width - right_x, center_y]];

upper_boss_positions = mirrored_pair(
    upper_boss_distance_from_wall, upper_boss_outer_d,
    side_opening_bottom - upper_boss_gap_below_opening - upper_boss_outer_d / 2);

lower_boss_positions = mirrored_pair(
    lower_boss_distance_from_wall, lower_boss_outer_d,
    lower_boss_distance_from_floor + lower_boss_outer_d / 2);

center_boss_position = [
    case_inner_width - center_boss_distance_from_right - center_boss_outer_d / 2,
    center_boss_center_y];

window_center         = [window_distance_from_left + window_width / 2, side_opening_center_y];
speaker_grille_center = [case_inner_width / 2,
                         speaker_grille_distance_from_floor + speaker_grille_diameter / 2];

// Lautsprecher-Halter
speaker_center        = speaker_grille_center + speaker_offset_on_grille;
speaker_slot_length   = speaker_length + 2 * speaker_fit_tolerance;
speaker_slot_width    = speaker_width  + 2 * speaker_fit_tolerance;
speaker_holder_length = speaker_slot_length + 2 * speaker_holder_wall;
speaker_holder_width  = speaker_slot_width  + 2 * speaker_holder_wall;
speaker_sound_opening = [speaker_slot_length - 2 * speaker_lip_overlap,
                         speaker_slot_width  - 2 * speaker_lip_overlap];
speaker_back_z        = speaker_lip_overlap + speaker_depth;

// OLED-Halter
oled_center        = window_center + oled_offset_in_window;
oled_slot_length   = oled_pcb_length + 2 * oled_fit_tolerance;
oled_slot_width    = oled_pcb_width  + 2 * oled_fit_tolerance;
oled_stack_depth   = oled_glass_thickness + oled_pcb_thickness + oled_fit_tolerance;
oled_holder_length = oled_slot_length + 2 * oled_holder_wall;
oled_holder_width  = oled_slot_width  + 2 * oled_holder_wall;
oled_holder_depth  = plate_z;   // reicht von der Front bis an die Platte
oled_distance_to_pin_side_edge = oled_pins_on_left
    ? oled_center.x - wall_clearance
    : case_inner_width - wall_clearance - oled_center.x;

// ESP32 (liegt flach, hochkant, Antenne oben)
esp_center_x   = case_inner_width / 2 + esp_offset_x;
esp_top_y      = case_inner_height - buckle_protrusion - wall_clearance - esp_gap_to_buckle;
esp_center     = [esp_center_x, esp_top_y - esp_board_length / 2];
esp_board_z    = max(carrier_back_z, speaker_back_z + esp_gap_above_speaker) + esp_header_below;
esp_top_z      = esp_board_z + esp_board_thickness + esp_module_height;
esp_platform_y_start = speaker_center.y + speaker_slot_width / 2 + 1.5;
esp_platform_y_end   = esp_top_y - 1;
esp_platform_size    = [esp_board_width - 2 * esp_platform_inset,
                        esp_platform_y_end - esp_platform_y_start];
esp_platform_center  = [esp_center_x, (esp_platform_y_start + esp_platform_y_end) / 2];

// Verstärker-Bucht am unteren Ende des Podests, Richtung Lautsprecher offen
amp_bay_size   = [amp_board_width + 2 * amp_fit_tolerance, amp_board_length + 2 * amp_fit_tolerance];
amp_bay_center = [esp_center_x, esp_platform_y_start + amp_bay_size.y / 2];
amp_space_z    = esp_board_z - carrier_back_z;   // Luft zwischen Träger und ESP32

// USB-C-Turm
usb_pocket_size    = [usb_board_thickness + usb_receptacle_thickness + 2 * usb_fit_tolerance,
                      usb_board_length + 2 * usb_fit_tolerance];
usb_tower_size     = usb_pocket_size + 2 * [usb_tower_wall, usb_tower_wall];
usb_board_bottom_z = usb_port_face_z - usb_board_height;
usb_tower_top_z    = usb_port_face_z - usb_tower_top_below_face;

// Seitenblenden
side_plug_flange_size = [side_opening_length + 2 * side_plug_flange_overlap,
                         side_opening_z_size + 2 * side_plug_flange_overlap];   // [Y, Z]
side_plug_nub_size    = [side_opening_length - 2 * side_plug_fit_tolerance,
                         side_opening_z_size - 2 * side_plug_fit_tolerance];

mic_cavity_d          = mic_pcb_diameter + 2 * mic_fit_tolerance;
mic_cavity_depth      = mic_pcb_thickness + mic_pocket_extra_depth;
mic_block_d           = mic_cavity_d + 2 * side_plug_pocket_wall;
mic_plug_inner_extent = side_plug_flange_thickness + mic_cavity_depth;

led_cavity_size       = [led_count * led_pitch + 2 * led_fit_tolerance,
                         led_strip_width + 2 * led_fit_tolerance];              // [Y, Z]
led_cavity_depth      = led_strip_thickness + led_fit_tolerance;
led_block_size        = led_cavity_size + 2 * [side_plug_pocket_wall, side_plug_pocket_wall];
led_plug_inner_extent = max(led_cavity_depth, side_plug_flange_thickness + 0.8);

// Druckschalter-Taschen
function push_pocket_size(body_size) = body_size + 2 * switch_pocket_tolerance;
function push_block_size(body_size)  = push_pocket_size(body_size) + 2 * side_plug_pocket_wall;
function push_block_depth(body_height, plunger_height) =
    side_plug_flange_thickness + cap_collar_thickness + plunger_height + body_height + switch_back_wall;

switch_block_size  = push_block_size(switch_body_size);
switch_block_depth = push_block_depth(switch_body_height, switch_plunger_height);
button_block_size  = push_block_size(button_body_size);
button_block_depth = push_block_depth(button_body_height, button_plunger_height);

// Aufteilung innerhalb einer Blende (lokales Y, 0 = Öffnungsmitte):
// Schalter bzw. Taster unten direkt über der oberen Fassung,
// Mikrofon bzw. LED oben (die Taschen dürfen innen über die Öffnung hinausragen).
lowest_block_edge_y = -(side_opening_length / 2 + upper_boss_gap_below_opening) + side_plug_boss_margin;
switch_offset_y = lowest_block_edge_y + switch_block_size / 2;
button_offset_y = lowest_block_edge_y + button_block_size / 2;
mic_offset_y    = side_opening_length / 2 - side_plug_fit_tolerance - mic_grille_slot_length / 2 - 0.8;
led_offset_y    = side_opening_length / 2 - side_plug_fit_tolerance - (led_count - 1) * led_pitch / 2 - 3;

// Bauteil-Blöcke jeder Blende als [Y-Versatz, Größe in Y, Tiefe nach innen]
mic_side_blocks = [
    [0,               side_plug_flange_size.x, side_plug_flange_thickness],
    [mic_offset_y,    mic_block_d,             mic_plug_inner_extent],
    [switch_offset_y, switch_block_size,       switch_block_depth]];
led_side_blocks = [
    [0,               side_plug_flange_size.x, side_plug_flange_thickness],
    [led_offset_y,    led_block_size.x,        led_plug_inner_extent],
    [button_offset_y, button_block_size,       button_block_depth]];

// Block als Rechteck im Gehäuse: [Mitte, Größe] – mit Spiel für die Aussparungen
function side_block_rect(right_side, block) =
    let(depth = block[2] + wall_clearance + 0.2,
        center_x = right_side ? case_inner_width - depth / 2 : depth / 2)
    [[center_x, side_opening_center_y + block[0]], [depth, block[1] + 2 * wall_clearance]];

// ============================================================
// Plausibilitätschecks (Ausgabe in der Konsole)
// ============================================================

function rects_overlap(center_a, size_a, center_b, size_b) =
    abs(center_a.x - center_b.x) < (size_a.x + size_b.x) / 2 &&
    abs(center_a.y - center_b.y) < (size_a.y + size_b.y) / 2;

speaker_holder_size = [speaker_holder_length, speaker_holder_width];
esp_board_size      = [esp_board_width, esp_board_length];

echo(str("Schnallenbreite: ", buckle_width, " mm"));
echo(str("Ausguck bis rechte Wand: ",
         case_inner_width - window_distance_from_left - window_width, " mm (gemessen: 10,15)"));
echo(str("Lautsprecher-Rückseite bei Z = ", speaker_back_z));
echo(str("ESP32 Oberkante bei Z = ", esp_top_z, " (Innentiefe: ", case_inner_depth, ")"));
echo(str("Innentiefe (berechnet): ", case_inner_depth, " mm"));
echo(str("USB-C-Loch in der Rückwand bei X = ", usb_center.x, ", Y = ", usb_center.y));

if (esp_top_z > case_inner_depth)
    echo("WARNUNG: ESP32 passt nicht in die Tiefe – Stiftleisten entfernen oder kleineres Board");
if (usb_board_bottom_z < carrier_back_z)
    echo("WARNUNG: USB-C-Platine reicht bis unter den Träger – Innenraum zu flach");
if (speaker_back_z > case_inner_depth)
    echo("WARNUNG: Lautsprecher ist tiefer als der Innenraum");
if (amp_board_thickness + amp_component_height > amp_space_z - 1)
    echo("WARNUNG: Verstärker hat unter dem ESP32 kaum Platz");
if (amp_bay_size.x + 2 * esp_platform_wall > esp_platform_size.x)
    echo("WARNUNG: Verstärker-Bucht breiter als das Podest – esp_platform_inset verkleinern");
if (amp_bay_size.y > esp_platform_size.y - 10)
    echo("WARNUNG: Nach der Verstärker-Bucht bleibt kaum Auflage für den ESP32");
if (esp_platform_size.y < 10)
    echo("WARNUNG: ESP32-Podest ist sehr kurz – Platine liegt kaum auf");
if (rects_overlap(usb_center, usb_tower_size, esp_center, esp_board_size))
    echo("WARNUNG: USB-C-Turm kollidiert mit dem ESP32");
for (side = [[mic_on_right_side, mic_side_blocks], [!mic_on_right_side, led_side_blocks]])
    for (b = side[1]) {
        r = side_block_rect(side[0], b);
        if (rects_overlap(usb_center, usb_tower_size, r[0], r[1]))
            echo(str("WARNUNG: USB-C-Turm kollidiert mit einer Seitenblende (Y-Versatz ", b[0], ")"));
        if (rects_overlap(esp_center, esp_board_size, r[0], r[1]) && b[2] > side_plug_flange_thickness)
            echo(str("WARNUNG: ESP32 kollidiert mit einer Seitenblende (Y-Versatz ", b[0], ")"));
    }
if (side_opening_center_y + max(mic_offset_y + mic_block_d / 2, led_offset_y + led_block_size.x / 2)
    > case_inner_height)
    echo("WARNUNG: Mikrofon- oder LED-Tasche ragt über die Gehäuseoberkante");
if (switch_cap_hole_d + 2 * cap_collar_overlap > push_pocket_size(switch_body_size) ||
    button_cap_hole_d + 2 * cap_collar_overlap > push_pocket_size(button_body_size))
    echo("WARNUNG: Kappenbund passt nicht in die Schaltertasche");
if (side_opening_center_z - mic_block_d / 2 < 0)
    echo("WARNUNG: Mikrofon-Blende ragt vor die Front – Seitenöffnung in Z prüfen");
if (side_plug_flange_overlap >= upper_boss_gap_below_opening)
    echo("WARNUNG: Flansch der Seitenblende stößt an die obere Fassung");
if (rects_overlap(center_boss_position, [center_boss_outer_d, center_boss_outer_d],
                  speaker_center, speaker_holder_size))
    echo("WARNUNG: mittlere Fassung kollidiert mit dem Lautsprecher-Halter – Position prüfen");
for (p = concat(lower_boss_positions, upper_boss_positions))
    if (rects_overlap(p, [lower_boss_outer_d, lower_boss_outer_d], speaker_center, speaker_holder_size))
        echo(str("WARNUNG: Fassung bei ", p, " kollidiert mit dem Lautsprecher-Halter"));
if (oled_holder_length > window_width)
    echo("HINWEIS: OLED-Halter ist breiter als der Ausguck");

assert(oled_holder_depth >= oled_front_lip + oled_stack_depth + oled_back_relief_depth,
       "OLED-Halter zu flach: plate_z vergrößern oder OLED-Maße prüfen");

// ============================================================
// Hilfsmodule
// ============================================================

module at(position_2d) {
    translate([position_2d.x, position_2d.y, 0]) children();
}

// Lokales System einer Seitenblende: Ursprung = Öffnungsmitte an der
// Innenseite der Wand, +X zeigt nach außen durch die Wand.
module on_side_wall(right_side) {
    translate([right_side ? case_inner_width : 0, side_opening_center_y, side_opening_center_z])
        scale([right_side ? 1 : -1, 1, 1])
            children();
}

// Fassung endet unter der Schicht → Schraubloch; ragt sie hinein → Durchbruch
module boss_cutout(position, outer_d, boss_height, layer_z, layer_thickness) {
    hole_d = boss_height > layer_z ? outer_d + 2 * wall_clearance : screw_clearance_d;
    translate([position.x, position.y, layer_z - 1])
        cylinder(d = hole_d, h = layer_thickness + 2);
}

// Aussparungen, die Front-Platte und Träger gemeinsam haben
module shared_layer_cutouts(layer_z, layer_thickness) {
    // Schnalle
    translate([buckle_distance_from_side - wall_clearance,
               case_inner_height - buckle_protrusion - wall_clearance,
               layer_z - 1])
        cube([buckle_width + 2 * wall_clearance,
              buckle_protrusion + wall_clearance + 1,
              layer_thickness + 2]);
    // Schraubfassungen
    for (p = upper_boss_positions)
        boss_cutout(p, upper_boss_outer_d, upper_boss_height, layer_z, layer_thickness);
    for (p = lower_boss_positions)
        boss_cutout(p, lower_boss_outer_d, lower_boss_height, layer_z, layer_thickness);
    // Platz für die Seitenblenden
    for (b = mic_side_blocks) side_plug_keepout(mic_on_right_side,  b, layer_z, layer_thickness);
    for (b = led_side_blocks) side_plug_keepout(!mic_on_right_side, b, layer_z, layer_thickness);
}

module side_plug_keepout(right_side, block, layer_z, layer_thickness) {
    rect = side_block_rect(right_side, block);
    // 1 mm über die Wand hinaus verlängert, damit sauber geschnitten wird
    translate([rect[0].x + (right_side ? 0.5 : -0.5), rect[0].y, layer_z - 1])
        cube([rect[1].x + 1, rect[1].y, layer_thickness + 2], anchor = BOTTOM);
}

module layer_outline(layer_z, layer_thickness) {
    translate([wall_clearance, wall_clearance, layer_z])
        cube([case_inner_width  - 2 * wall_clearance,
              case_inner_height - 2 * wall_clearance,
              layer_thickness]);
}

// ============================================================
// Gehäuse-Referenz (wird nicht gedruckt)
// ============================================================

module screw_boss(position, outer_d, hole_d, height) {
    translate([position.x, position.y, 0])
        tube(od = outer_d, id = hole_d, h = height, anchor = BOTTOM);
}

module case_shell() {
    difference() {
        translate([-case_wall, -case_wall, -case_wall])
            cube([case_inner_width  + 2 * case_wall,
                  case_inner_height + 2 * case_wall,
                  case_inner_depth  + case_wall]);
        // Innenraum, hinten offen
        cube([case_inner_width, case_inner_height, case_inner_depth + 1]);
        // Seitenöffnungen
        for (x = [-case_wall - 1, case_inner_width - 1])
            translate([x, side_opening_bottom, side_opening_z_start])
                cube([case_wall + 2, side_opening_length, side_opening_z_size]);
        // Ausguck
        translate([window_distance_from_left, side_opening_bottom, -case_wall - 1])
            cube([window_width, side_opening_length, case_wall + 2]);
        // Lautsprechergitter (als offene Fläche)
        translate([speaker_grille_center.x, speaker_grille_center.y, -case_wall - 1])
            cylinder(d = speaker_grille_diameter, h = case_wall + 2);
    }
}

module case_inner_features() {
    translate([buckle_distance_from_side, case_inner_height - buckle_protrusion, 0])
        cube([buckle_width, buckle_protrusion, buckle_depth]);
    for (p = upper_boss_positions)
        screw_boss(p, upper_boss_outer_d, upper_boss_hole_d, upper_boss_height);
    for (p = lower_boss_positions)
        screw_boss(p, lower_boss_outer_d, lower_boss_hole_d, lower_boss_height);
    screw_boss(center_boss_position, center_boss_outer_d, center_boss_hole_d, center_boss_height);
}

module case_reference() {
    color("SteelBlue", 0.25) case_shell();
    color("Orange", 0.7)     case_inner_features();
}

// ============================================================
// Lautsprecher-Halter
// ============================================================
// Lokale Koordinaten: Ursprung = Lautsprechermitte, Z = 0 an der Front.
// Rahmen von der Front bis zur Platte. Der Lautsprecher wird von hinten
// durch Träger und Platte eingesetzt und liegt vorne an einer 45°-Fase an.

module speaker_holder_body() {
    translate([-speaker_holder_length / 2, -speaker_holder_width / 2, 0])
        cube([speaker_holder_length, speaker_holder_width, plate_z + 0.5]);
}

module speaker_holder_cutouts() {
    // Schallöffnung ganz vorne
    translate([0, 0, -1])
        cube([speaker_sound_opening.x, speaker_sound_opening.y, 2.01], anchor = BOTTOM);
    // 45°-Fase als Anschlag
    prismoid(size1 = speaker_sound_opening,
             size2 = [speaker_slot_length, speaker_slot_width],
             h = speaker_lip_overlap, anchor = BOTTOM);
    // Schacht, durch Platte und Träger nach hinten offen
    translate([0, 0, speaker_lip_overlap - 0.01])
        cube([speaker_slot_length, speaker_slot_width, carrier_back_z + 1], anchor = BOTTOM);
}

module speaker_dummy() {
    color("DimGray")
        translate([0, 0, speaker_lip_overlap])
            cube([speaker_length, speaker_width, speaker_depth], anchor = BOTTOM);
    color("Black")
        translate([0, 0, speaker_lip_overlap - 0.05])
            cylinder(d = min(speaker_length, speaker_width) - 4, h = 0.1);
}

// ============================================================
// OLED-Halter
// ============================================================
// Lokale Koordinaten: Ursprung = Platinenmitte, Z = 0 an der Front.
// Das Modul wird mit angelöteten Kabeln eingeschoben: Ende ohne Pins voran,
// die Pins zuletzt. Auf der Pin-Seite ist der Halter offen, gegenüber ist
// eine Anschlagwand. Die Kabel laufen durch einen Kanal durch Platte und
// Träger bis zum Rand, damit sie beim Einschieben nirgends anstoßen.

oled_mirror = [oled_pins_on_left ? 1 : -1, 1, 1];

module oled_holder_body() {
    translate([-oled_holder_length / 2, -oled_holder_width / 2, 0])
        cube([oled_holder_length, oled_holder_width, oled_holder_depth + 0.5]);
}

module oled_holder_cutouts() {
    pin_end_x     = -oled_slot_length / 2;
    open_side_x   = -oled_holder_length / 2 - 1;
    cable_start_x = oled_cable_channel_to_plate_edge
                    ? -oled_distance_to_pin_side_edge - 1
                    : open_side_x;
    scale(oled_mirror) {
        // Einschubschacht: Pin-Seite offen, gegenüber Anschlagwand
        translate([open_side_x, -oled_slot_width / 2, oled_front_lip])
            cube([oled_slot_length / 2 - open_side_x, oled_slot_width, oled_stack_depth]);
        // Sichtfenster im vorderen Rahmen
        translate([oled_glass_offset, 0, oled_front_lip / 2])
            cube([oled_active_length + 2 * oled_view_margin,
                  oled_active_width  + 2 * oled_view_margin,
                  oled_front_lip + 2], center = true);
        // Freiraum für Bauteile hinter der Platine
        translate([pin_end_x + oled_pin_zone_length,
                   -oled_slot_width / 2 + oled_back_ledge,
                   oled_front_lip + oled_stack_depth - 0.01])
            cube([oled_slot_length - oled_pin_zone_length,
                  oled_slot_width - 2 * oled_back_ledge,
                  oled_back_relief_depth]);
        // Kabelkanal: von der Stiftleiste durch Halter, Platte und Träger bis zum Rand
        translate([cable_start_x, -oled_slot_width / 2, -1])
            cube([pin_end_x + oled_pin_zone_length - cable_start_x,
                  oled_slot_width, carrier_back_z + 2]);
    }
}

module oled_dummy() {
    scale(oled_mirror) {
        glass_front_z = oled_front_lip;
        pcb_front_z   = glass_front_z + oled_glass_thickness;
        color("Black")
            translate([oled_glass_offset - oled_glass_length / 2, -oled_glass_width / 2, glass_front_z])
                cube([oled_glass_length, oled_glass_width, oled_glass_thickness]);
        color("White")
            translate([oled_glass_offset, 0, glass_front_z])
                cube([oled_active_length, oled_active_width, 0.05], center = true);
        color("RoyalBlue")
            translate([-oled_pcb_length / 2, -oled_pcb_width / 2, pcb_front_z])
                cube([oled_pcb_length, oled_pcb_width, oled_pcb_thickness]);
        color("Gold")
            for (i = [0 : 3])
                translate([-oled_pcb_length / 2 + oled_pin_zone_length / 2, (i - 1.5) * 2.54, pcb_front_z])
                    cylinder(d = 0.8, h = 7);
    }
}

// ============================================================
// Front-Einsatz (Platte + Lautsprecher- und OLED-Halter)
// ============================================================

module front_insert() {
    color("LimeGreen") difference() {
        union() {
            layer_outline(plate_z, plate_thickness);
            at(speaker_center) speaker_holder_body();
            at(oled_center)    oled_holder_body();
        }
        shared_layer_cutouts(plate_z, plate_thickness);
        // mittlere Fassung: vorerst nur Markierung zum Prüfen der Position
        translate([center_boss_position.x, center_boss_position.y, plate_z - 1])
            cylinder(d = center_boss_outer_d, h = plate_thickness + 2);
        at(speaker_center) speaker_holder_cutouts();
        at(oled_center)    oled_holder_cutouts();
    }
}

// ============================================================
// Elektronik-Träger (ESP32-Podest + USB-C-Turm)
// ============================================================
// Liegt direkt hinter der Front-Platte und wird mit ihr zusammen an den
// oberen Fassungen verschraubt. Der ESP32 liegt ohne Stiftleisten flach auf
// dem Podest (doppelseitiges Schaumklebeband) und ragt unten über den
// Lautsprecher. Die Antenne zeigt nach oben, weg vom Lautsprechermagneten.
// Unter dem ESP32 liegt der Verstärker in einer Bucht des Podests, die zum
// Lautsprecher hin offen ist (kurzes Kabel).

module esp_platform() {
    height = esp_board_z - carrier_back_z + 0.01;
    translate([esp_platform_center.x, esp_platform_center.y, carrier_back_z - 0.01])
        difference() {
            cube([esp_platform_size.x, esp_platform_size.y, height], anchor = BOTTOM);
            // hohl, mit Mittelsteg – spart Material
            for (side = [-1, 1])
                translate([side * esp_platform_size.x / 4, 0, -1])
                    cube([esp_platform_size.x / 2 - 1.5 * esp_platform_wall,
                          esp_platform_size.y - 2 * esp_platform_wall,
                          height + 2], anchor = BOTTOM);
        }
}

module amp_bay_cutout() {
    // Bucht durch das Podest, am unteren Ende offen
    translate([amp_bay_center.x, amp_bay_center.y - 1, carrier_back_z])
        cube([amp_bay_size.x, amp_bay_size.y + 2, amp_space_z + 1], anchor = BOTTOM);
}

module amp_dummy() {
    at(amp_bay_center) translate([0, 0, carrier_back_z]) {
        color("MediumOrchid")
            cube([amp_board_width, amp_board_length, amp_board_thickness], anchor = BOTTOM);
        color("Black")
            translate([0, 0, amp_board_thickness]) cube([3, 3, amp_component_height], anchor = BOTTOM);
    }
}

module usb_tower() {
    at(usb_center) translate([0, 0, carrier_back_z - 0.01])
        cube([usb_tower_size.x, usb_tower_size.y, usb_tower_top_z - carrier_back_z + 0.01], anchor = BOTTOM);
}

module usb_tower_cutouts() {
    at(usb_center) {
        // Schacht für Platine + Buchse
        translate([0, 0, usb_board_bottom_z])
            cube([usb_pocket_size.x, usb_pocket_size.y, usb_port_face_z], anchor = BOTTOM);
        // Fenster für die Kabel unten an der Platine, Richtung ESP32
        translate([-usb_tower_size.x / 2 - 1, 0, usb_board_bottom_z])
            cube([usb_tower_size.x / 2 + 1, usb_pocket_size.y - 2, usb_wire_window_height],
                 anchor = BOTTOM + LEFT);
    }
}

module carrier() {
    color("MediumSeaGreen") difference() {
        union() {
            layer_outline(carrier_z, carrier_thickness);
            esp_platform();
            usb_tower();
        }
        shared_layer_cutouts(carrier_z, carrier_thickness);
        at(speaker_center) speaker_holder_cutouts();
        at(oled_center)    oled_holder_cutouts();
        usb_tower_cutouts();
        amp_bay_cutout();
    }
}

module esp_dummy() {
    at(esp_center) translate([0, 0, esp_board_z]) {
        color("DarkGreen")
            cube([esp_board_width, esp_board_length, esp_board_thickness], anchor = BOTTOM);
        color("Silver")   // WROOM-Modul am oberen Ende
            translate([0, esp_board_length / 2 - 25.5 / 2, esp_board_thickness])
                cube([18, 25.5, esp_module_height], anchor = BOTTOM);
    }
}

module usb_dummy() {
    at(usb_center) translate([0, 0, usb_board_bottom_z]) {
        board_x = usb_pocket_size.x / 2 - usb_fit_tolerance - usb_board_thickness / 2;
        color("Purple")
            translate([board_x, 0, 0])
                cube([usb_board_thickness, usb_board_length, usb_board_height], anchor = BOTTOM);
        color("Silver")
            translate([board_x - usb_board_thickness / 2, 0, usb_board_height])
                cube([usb_receptacle_thickness, usb_receptacle_width, 7.4], anchor = TOP + RIGHT);
    }
}

// ============================================================
// Seitenblenden (Mikrofon + Schalter, LED + Taster)
// ============================================================
// Lokales System siehe on_side_wall(). Die Blende wird von innen in die
// alte Seitenöffnung gedrückt: der Zapfen füllt die Öffnung (außen bündig),
// der Flansch liegt innen an der Wand an. Dahinter sitzen die Bauteile.
// Druckrichtung: Außenseite aufs Bett, Taschen zeigen nach oben.
//
// Schalter und Taster: eine Druckkappe steckt von innen im Loch, ihr Bund
// hält sie in der Blende. Dahinter wird der Schalter von hinten (+Z) in
// seine Tasche geschoben; die Rückwand stützt ihn beim Drücken, die Pins
// laufen durch einen Schlitz darin.

module side_plug_nub_and_flange() {
    cube([case_wall, side_plug_nub_size.x, side_plug_nub_size.y], anchor = LEFT);
    cube([side_plug_flange_thickness, side_plug_flange_size.x, side_plug_flange_size.y], anchor = RIGHT);
}

module push_switch_block(offset_y, body_size, body_height, plunger_height) {
    block = push_block_size(body_size);
    translate([0, offset_y, 0])
        cube([push_block_depth(body_height, plunger_height), block, block], anchor = RIGHT);
}

module push_switch_cutouts(offset_y, body_size, body_height, plunger_height, hole_d) {
    pocket       = push_pocket_size(body_size);
    flange_back  = -side_plug_flange_thickness;
    pocket_depth = cap_collar_thickness + plunger_height + body_height;
    translate([0, offset_y, 0]) {
        // Loch für die Druckkappe durch Flansch und Zapfen
        translate([flange_back - 0.01, 0, 0])
            xcyl(d = hole_d, h = side_plug_flange_thickness + case_wall + 2, anchor = LEFT);
        // Tasche für Kappenbund und Schalter, nach hinten (+Z) offen
        translate([flange_back, 0, -pocket / 2])
            cube([pocket_depth, pocket, 50], anchor = RIGHT + BOTTOM);
        // Schlitz für die Pins in der Rückwand
        translate([flange_back - pocket_depth + 0.01, 0, -pocket / 2 + 1])
            cube([switch_back_wall + 1, pocket - 2, 50], anchor = RIGHT + BOTTOM);
    }
}

// Mikrofon: Platine mit der glatten Seite (Schallloch, ohne Chip) nach außen
module mic_cutouts() {
    translate([-side_plug_flange_thickness, 0, 0]) {
        // Aufnahme für die Platine, von innen offen
        xcyl(d = mic_cavity_d, h = mic_cavity_depth + 1, anchor = RIGHT);
        // Kabelkerben oben und unten
        cube([mic_cavity_depth + 1, mic_block_d + 0.4, mic_wire_notch_width], anchor = RIGHT);
    }
    // Schallschlitze durch Zapfen und Flansch
    for (i = [0 : mic_grille_slot_count - 1])
        translate([0, 0, (i - (mic_grille_slot_count - 1) / 2) * mic_grille_slot_pitch])
            cube([2 * (case_wall + side_plug_flange_thickness) + 2,
                  mic_grille_slot_length, mic_grille_slot_width], center = true);
}

// LED: Streifenstück mit den LEDs nach außen, der Zapfen dient als Diffusor
module led_cutouts() {
    cube([led_plug_inner_extent + 1, led_cavity_size.x, led_cavity_size.y], anchor = RIGHT);
    cube([led_plug_inner_extent + 1, led_block_size.x + 0.4, led_wire_notch_width], anchor = RIGHT);
}

module mic_switch_plug() {
    difference() {
        union() {
            side_plug_nub_and_flange();
            translate([-side_plug_flange_thickness + 0.01, mic_offset_y, 0])
                xcyl(d = mic_block_d, h = mic_cavity_depth + 0.01, anchor = RIGHT);
            push_switch_block(switch_offset_y, switch_body_size, switch_body_height, switch_plunger_height);
        }
        translate([0, mic_offset_y, 0]) mic_cutouts();
        push_switch_cutouts(switch_offset_y, switch_body_size, switch_body_height,
                            switch_plunger_height, switch_cap_hole_d);
    }
}

module led_button_plug() {
    difference() {
        union() {
            side_plug_nub_and_flange();
            translate([0, led_offset_y, 0])
                cube([led_plug_inner_extent, led_block_size.x, led_block_size.y], anchor = RIGHT);
            push_switch_block(button_offset_y, button_body_size, button_body_height, button_plunger_height);
        }
        translate([0, led_offset_y, 0]) led_cutouts();
        push_switch_cutouts(button_offset_y, button_body_size, button_body_height,
                            button_plunger_height, button_cap_hole_d);
    }
}

// Druckkappe: Bund unten, Schaft nach oben (so wird sie auch gedruckt)
module push_cap(hole_d) {
    shaft_length = side_plug_flange_thickness + case_wall + cap_protrusion;
    cylinder(d = hole_d + 2 * cap_collar_overlap, h = cap_collar_thickness);
    cylinder(d = hole_d - 2 * cap_fit_tolerance, h = cap_collar_thickness + shaft_length);
}

// Kappe an ihrer Einbauposition im lokalen Blendensystem
module placed_cap(offset_y, hole_d) {
    translate([-side_plug_flange_thickness - cap_collar_thickness, offset_y, 0])
        rotate([0, 90, 0]) push_cap(hole_d);
}

module push_switch_dummy(offset_y, body_size, body_height, plunger_height) {
    plunger_top = -side_plug_flange_thickness - cap_collar_thickness;
    translate([0, offset_y, 0]) {
        color("Silver")
            translate([plunger_top, 0, 0]) cube([plunger_height, 3, 3], anchor = RIGHT);
        color("DimGray")
            translate([plunger_top - plunger_height, 0, 0])
                cube([body_height, body_size, body_size], anchor = RIGHT);
    }
}

module mic_dummy() {
    translate([-side_plug_flange_thickness - mic_fit_tolerance, mic_offset_y, 0]) {
        color("MediumPurple") xcyl(d = mic_pcb_diameter, h = mic_pcb_thickness, anchor = RIGHT);
        color("Silver")
            translate([-mic_pcb_thickness, 0, 0]) cube([1, 3.76, 4.72], anchor = RIGHT);
    }
}

module led_dummy() {
    translate([0, led_offset_y, 0]) {
        color("Black") cube([led_strip_thickness, led_count * led_pitch, led_strip_width], anchor = RIGHT);
        color("White")
            for (i = [0 : led_count - 1])
                translate([0, (i - (led_count - 1) / 2) * led_pitch, 0])
                    cube([0.1, 5, 5], anchor = RIGHT);
    }
}

// ============================================================
// Ausgabe
// ============================================================

module preview() {
    if (show_case_reference) case_reference();
    if (show_front_insert)   front_insert();
    if (show_carrier)        carrier();
    if (show_side_plugs) {
        on_side_wall(mic_on_right_side) {
            color("Goldenrod") mic_switch_plug();
            color("Tomato")    placed_cap(switch_offset_y, switch_cap_hole_d);
        }
        on_side_wall(!mic_on_right_side) {
            color("WhiteSmoke") led_button_plug();
            color("Tomato")     placed_cap(button_offset_y, button_cap_hole_d);
        }
    }
    if (show_dummies) {
        at(speaker_center) speaker_dummy();
        at(oled_center)    oled_dummy();
        esp_dummy();
        amp_dummy();
        usb_dummy();
        on_side_wall(mic_on_right_side) {
            mic_dummy();
            push_switch_dummy(switch_offset_y, switch_body_size, switch_body_height, switch_plunger_height);
        }
        on_side_wall(!mic_on_right_side) {
            led_dummy();
            push_switch_dummy(button_offset_y, button_body_size, button_body_height, button_plunger_height);
        }
    }
}

// Seitenblende in Druckrichtung: Außenseite des Zapfens aufs Bett
module print_side_plug() {
    translate([0, 0, case_wall]) rotate([0, 90, 0]) children();
}

if (export_part == "preview")
    preview();
else if (export_part == "front_insert")   // Platte aufs Bett, Halter zeigen nach oben
    translate([0, case_inner_height, plate_back_z]) rotate([180, 0, 0]) front_insert();
else if (export_part == "carrier")        // Träger aufs Bett, Podest und Turm nach oben
    translate([0, 0, -carrier_z]) carrier();
else if (export_part == "mic_switch_plug")
    print_side_plug() mic_switch_plug();
else if (export_part == "led_button_plug")
    print_side_plug() led_button_plug();
else if (export_part == "switch_cap")
    push_cap(switch_cap_hole_d);
else if (export_part == "button_cap")
    push_cap(button_cap_hole_d);
