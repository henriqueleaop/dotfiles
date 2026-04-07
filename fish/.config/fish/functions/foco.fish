function foco --description 'Timer de Deep Work com alerta visual no KDE'
    clear
    termdown $argv[1]m
    and kdialog --title "SISTEMA DE FOCO" --msgbox "CICLO CONCLUÍDO: $argv[1] minutos. Afaste-se da tela."
end
