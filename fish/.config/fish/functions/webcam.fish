function webcam --description "Inicia o S10+ como webcam via USB (800x600)"
    echo "Carregando módulo v4l2loopback..."
    sudo modprobe v4l2loopback exclusive_caps=1 video_nr=9 card_label="S10_Camera"
    
    echo "Iniciando captura via scrcpy (800x600)..."
    scrcpy --video-source=camera --camera-size=320x240 --no-playback --v4l2-sink=/dev/video9
end
