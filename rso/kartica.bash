#!/bin/bash

# 1. Pripravi nastavitve
set -u
MESTO="${1:-Nova-Gorica}"
IZHOD="/C/rso/brifing.html"

# 2. Pobere podatke od dveh otrok
VREME=$(./nasvet.bash "$MESTO")
NOVICE=$(./novice.bash 2>/dev/null)

# 3. Iz vremena izlušči posamezne vrednosti
OBLEKA=$(echo "$VREME" | sed -n 's/^Obleci: //p')
DEZNIK=$(echo "$VREME" | sed -n 's/^Deznik: //p')
ZDAJ=$(echo "$VREME" | sed -n 's/^Zdaj: //p')
DANES=$(echo "$VREME" | sed -n 's/^Danes: //p')

# 4. Novice pretvori v HTML seznam
HTML_NOVICE=$(echo "$NOVICE" | sed 's/^ \* /<li>/; s/$/<\/li>/')


# 5. Sestavi celotno HTML datoteko in 6. Shrani
cat > "$IZHOD" <<HTML
<!DOCTYPE html>
<html lang="sl">
<head>
    <meta charset="UTF-8">
    <title>Jutranji brifing - $MESTO</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }
        .kartica { border: 1px solid #ccc; padding: 20px; border-radius: 8px; max-width: 500px; box-shadow: 2px 2px 10px #eee; }
        h1 { color: #333; margin-top: 0; }
        ul { padding-left: 20px; }
    </style>
</head>
<body>
    <div class="kartica">
        <h1>Brifing za kraj: $MESTO</h1>
        <p><strong>Trenutno stanje:</strong> $ZDAJ</p>
        <p><strong>Napoved za danes:</strong> $DANES</p>
        <p><strong>Priporočilo za oblačila:</strong> $OBLEKA</p>
        <p><strong>Potrebujete dežnik?</strong> $DEZNIK</p>
        
        <h2>Zadnje novice:</h2>
        <ul>
            $HTML_NOVICE
        </ul>
    </div>
</body>
</html>
HTML

echo "Kartica je bila uspešno shranjena v $IZHOD"

