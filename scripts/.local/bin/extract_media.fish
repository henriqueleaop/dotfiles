#!/usr/bin/env fish

# CONFIGURAÇÃO
set target_extensions "jpg" "jpeg" "png" "gif" "mp4" "avi" "mov" "mp3" "wav" "pdf" "doc" "docx" "txt"

if test (count $argv) -lt 2
    echo "Uso: ./resgate_final.fish <DESTINO> <IMG1> [IMG2]..."
    exit 1
end

set dest_root (path resolve $argv[1])
set images $argv[2..-1]
set mount_point "/mnt/temp_resgate"
set file_list "/tmp/lista_arquivos_resgate.txt"

if not test -d $mount_point
    sudo mkdir -p $mount_point
end

# Loop das Imagens
for img_file in $images
    set img_name (path basename $img_file)
    set current_dest "$dest_root/$img_name"_DUMP
    
    echo "========================================================="
    echo "ALVO: $img_name"
    echo "========================================================="

    # 1. Montagem Forçada com NTFS-3G (Mais resiliente a erros)
    # remove_hiberfile: remove arquivo de hibernação que trava montagem
    # ro: read-only
    if sudo mount -t ntfs-3g -o ro,remove_hiberfile,force $img_file $mount_point
        echo "[OK] Montado via NTFS-3G."
    else
        echo "[AVISO] Tentando montagem loop padrão..."
        if not sudo mount -o ro,loop $img_file $mount_point
            echo "[ERRO FATAL] Não foi possível montar $img_file"
            continue
        end
    end

    echo "[BUSCA] Gerando lista de arquivos seguros (ignorando sistema)..."
    
    # Entra na pasta
    pushd $mount_point

    # O COMANDO BLINDADO
    # 1. Exclui pastas de sistema (-prune)
    # 2. Procura pelas extensões (usando -iname para cada uma)
    # 3. Salva em arquivo de texto ignorando erros de I/O (2>/dev/null)
    
    # Constrói a string de busca de extensões
    set find_args \(
    for ext in $target_extensions
        set -a find_args -iname "*.$ext" -o
    end
    # Remove o último -o
    set -e find_args[-1]
    set -a find_args \)

    # Executa o find ignorando o lixo
    find . -type d \( \
           -iname "Windows" -o \
           -iname "Program Files" -o \
           -iname "Program Files (x86)" -o \
           -iname "ProgramData" -o \
           -iname "AppData" -o \
           -iname "Application Data" -o \
           -iname '$Recycle.Bin' -o \
           -iname "System Volume Information" \
           \) -prune -o \
           -type f $find_args -print0 > $file_list 2>/dev/null

    popd

    # Verifica se achou algo
    if test -s $file_list
        echo "[COPIA] Arquivos encontrados! Iniciando transferência..."
        echo "        Destino: $current_dest"
        
        if not test -d $current_dest
            mkdir -p $current_dest
        end

        # Rsync lendo da lista limpa
        rsync -av --progress --files-from=$file_list --from0 $mount_point $current_dest/
    else
        echo "[FALHA] Nenhum arquivo encontrado nas extensões alvo ou erro crítico na leitura."
        echo "        Tente verificar manualmente a pasta /mnt/temp_resgate"
    end

    sudo umount $mount_point
    echo "========================================================="
end
