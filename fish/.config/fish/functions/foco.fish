function foco --description 'Timer de Deep Work com interrupção forçada no KDE'
    clear
    termdown $argv[1]m; 

    notify-send "CICLO FINALIZADO" "Saia da frente do PC." --urgency=critical --icon=dialog-warning
    
    kdialog --active-window --title "SISTEMA DE FOCO" --msgbox "O TEMPO ACABOU. LEVANTE-SE."
end
