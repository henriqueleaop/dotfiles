#!/usr/bin/env fish

# DEFINIÇÃO DOS ALVOS (Baseado no seu scan)
# Vídeos Antigos e Novos
set video_ext "mpg" "mpeg" "avi" "flv" "mp4" "wmv" "mov" "rmvb" "3gp"
# Projetos Criativos e Nostalgia (Opcional - removi código fonte pra não lotar, mas deixei Flash e 3D)
set creative_ext "swf" "c4d"
# Áudio (Opcional)
set audio_ext "wma" "ogg"

# Juntando tudo
set all_ext $video_ext $creative_ext $audio_ext

if test (count $argv) -lt 2
    echo "Uso: ./resgate_final.fish <DESTINO> <IMG1> [IMG2]..."
    exit 1
end

set dest_root (path resolve $argv[1])
set images $argv[2..-1]
set mount_point "/mnt/temp_resgate"
set file_list "/tmp/lista_resgate_fina.txt"

if not test -d $mount_point
    sudo mkdir -p $mount_point
end

for img_file in $images
    set img_name (path basename $img_file)
    set current_dest "$dest_root/$img_name"_RESGATE
    
    echo "========================================================="
    echo "ALVO: $img_name"
    echo "BUSCANDO EXTENSÕES: $all_ext"
    echo "========================================================="

    # Monta
    if not sudo mount -t ntfs-3g -o ro,remove_hiberfile,force $img_file $mount_point 2>/dev/null
        sudo mount -o ro,loop $img_file $mount_point
    end

    pushd $mount_point

    # Constrói a query do find
    set find_args \(
    for ext in $all_ext
        set -a find_args -iname "*.$ext" -o
    end
    set -e find_args[-1] 
    set -a find_args \)

    # Busca ignorando lixo do Windows
    find . -type d \( \
           -iname "Windows" -o \
           -iname "Program Files" -o \
           -iname "Program Files (x86)" -o \
           -iname "ProgramData" -o \
           -iname "AppData" -o \
           -iname '$Recycle.Bin' \
           \) -prune -o \
           -type f $find_args -print0 > $file_list 2>/dev/null

    popd

    # Executa a cópia
    if test -s $file_list
        echo "[ENCONTRADO] Copiando arquivos..."
        # --ignore-existing garante que não vamos copiar o que já foi salvo antes
        rsync -av --progress --files-from=$file_list --from0 --ignore-existing $mount_point $current_dest/
    else
        echo "[VAZIO] Nada de interesse encontrado nesta imagem."
    end

    sudo umount $mount_point
end

    echo "Missão cumprida. Verifique a pasta de destino."
