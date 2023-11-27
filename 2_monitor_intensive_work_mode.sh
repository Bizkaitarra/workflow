#!/bin/bash

# Obtiene una lista de las IDs de todas las ventanas de PHPStorm
phpstorm_window_ids=$(xdotool search --class jetbrains-phpstorm)

for window_id in $phpstorm_window_ids; do
    # Obtiene el nombre de la ventana
    WM_NAME=$(xprop -id $window_id WM_NAME | awk -F '"' '{print $2}')

    # Comprueba si la ventana debe excluirse
    if [[ "$WM_NAME" == *"Content window"* || "$WM_NAME" == *"jetbrains-phpstorm"* ]]; then
        echo "Ignorando ventana: $WM_NAME"
        continue
    fi

    echo "Ventana a mover detectada: $WM_NAME"

    # Comprueba si el nombre contiene un guion y un punto (indicativo de archivo)
    if [[ "$WM_NAME" == *" "* ]]; then
        # Es una ventana de proyecto de PHPStorm, muévela al monitor derecho
        xdotool windowactivate $window_id
        sleep 0.2  # Pausa de 0.2 segundos
        xdotool key --clearmodifiers "Super+Up"
        sleep 0.2  # Pausa de 0.2 segundos
        xdotool key --clearmodifiers "Super+Shift+Right"
        echo "Detectado como de proyecto"
    else
        # Es una ventana de archivo individual de PHPStorm, muévela al monitor izquierdo
        xdotool windowactivate $window_id
        sleep 0.2  # Pausa de 0.2 segundos
        xdotool key --clearmodifiers "Super+Up"
        sleep 0.2  # Pausa de 0.2 segundos
        xdotool key --clearmodifiers "Super+Shift+Left"
        echo "Detectado como de NO proyecto"
    fi

done

