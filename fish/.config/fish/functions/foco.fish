function foco --description 'Timer de Deep Work com interrupção visual robusta'
    clear
    termdown $argv[1]m;

    # 1. Notificação Crítica (Aparece em todos os desktops e sobre tela cheia)
    notify-send "SISTEMA DE FOCO" "O TEMPO ACABOU. LEVANTE-SE." --urgency=critical --icon=dialog-warning

    # 2. Janela de aviso centralizada (Sem flags desconhecidas)
    # No KDE/Wayland, o kdialog abrirá no centro da tela ativa por padrão.
    kdialog --title "DEEP WORK FINALIZADO" --msgbox "Ciclo de $argv[1] minutos concluído. \n\nAfastar-se da tela agora é obrigatório."
end
