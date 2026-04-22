#!/bin/bash

# ============================================================
#  Chat Tradutor para Jogos - Versão Rápida (sem confirmação)
#  Dependências: zenity, curl, jq, wl-clipboard, wtype
#  Instalar arch: sudo pacman -S zenity curl jq wl-clipboard wtype
#  Instalador Debian/Ubuntu: sudo apt update && sudo apt install zenity curl jq xclip xdotool
# ============================================================

IDIOMA_ORIGEM="pt"
IDIOMA_DESTINO="en"

# 1. Abre a caixa de entrada
TEXTO=$(zenity --entry \
    --title="LnxTrans" \
    --text="Digite sua mensagem (PT → EN):" \
    --width=380 2>/dev/null)

# Cancelou, fechou ou campo vazio = sair silenciosamente
[ $? -ne 0 ] || [ -z "$TEXTO" ] && exit 0

# 2. Traduz
TRADUCAO=$(curl -s -G "https://translate.googleapis.com/translate_a/single" \
    --data-urlencode "client=gtx" \
    --data-urlencode "sl=$IDIOMA_ORIGEM" \
    --data-urlencode "tl=$IDIOMA_DESTINO" \
    --data-urlencode "dt=t" \
    --data-urlencode "q=$TEXTO" | jq -r '[.[0][][0]] | join("")')

[ -z "$TRADUCAO" ] && exit 1

# 3. Copia para clipboard
echo -n "$TRADUCAO" | wl-copy

# 4. Som de confirmação
paplay /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &

# Aguarda clipboard registrar + foco voltar ao jogo
sleep 1.0

# 5. Abre o chat do jogo (ENTER)
wtype -k Return
sleep 0.2

# 6. Cola o texto (Ctrl+V)
wtype -M ctrl v -m ctrl
sleep 0.2

# 7. Envia (ENTER)
wtype -k Return
