#!/bin/bash
# Naloga: Procesi (Verzija brez sudo/sqlite3)

set -u                                  # ustavi ob nedefinirani spremenljivki

MESTO="${1:-Nova-Gorica}"               # kraj podamo kot argument; privzeto Nova-Gorica
DANES=$(date +%F)                       # danasnji datum, npr. 2026-09-15

# --- TESTNI PODATKI (ker nimamo sqlite3) ---
TEMP="7.5"
VLAGA="82"
TMAX="12.0"
TMIN="4.0"
PAD="15.5" # Če spremenite na 0, bo javilo, da dežnik ni potreben

# Glavna skripta kartica.sh preko sed-a išče spodnje besede (Zdaj:, Danes:, Obleci:, Deznik:)
# Zato smo izpise prilagodili, da jih kartica.sh lahko pravilno prebere.

echo "Zdaj: ${TEMP}°C, Vlaga: ${VLAGA}% ($MESTO)"
echo "Danes: Najnižja ${TMIN}°C, Najvišja ${TMAX}°C"

# --- kaj obleci: odlocamo po NAJNIZJI napovedani temperaturi (TMIN) ---
T=${TMIN%.*}                            # odrezi decimalke: "4.0" -> "4"
if   [ "$T" -lt 0 ];  then OBLEKA="zimska bunda, kapa in rokavice"
elif [ "$T" -lt 10 ]; then OBLEKA="topla jakna in dolge hlace"
elif [ "$T" -lt 18 ]; then OBLEKA="pulover ali lahka jakna"
elif [ "$T" -lt 25 ]; then OBLEKA="majica, zjutraj morda pulover"
else                       OBLEKA="kratke hlace in majica"
fi

# --- deznik? padavine so decimalne (mm), zato primerjamo z awk ---
if awk "BEGIN{exit !($PAD > 1)}"; then DEZNIK="DA, vzemi deznik ($PAD mm)"
else                                    DEZNIK="ni treba (${PAD} mm)"
fi

echo "Obleci: $OBLEKA"
echo "Deznik: $DEZNIK"
