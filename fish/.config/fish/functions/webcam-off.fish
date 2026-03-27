function webcam-off --description "Encerra a webcam e limpa o módulo do kernel"
    echo "Matando processos do scrcpy..."
    pkill scrcpy
    
    echo "Descarregando o módulo v4l2loopback..."
    sudo modprobe -r v4l2loopback
    
    echo "Infraestrutura desmontada. Webcam desligada."
end
