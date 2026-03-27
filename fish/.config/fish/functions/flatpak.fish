function flatpak --description "Wrapper para sincronizar pacotes pós-transação"
    command flatpak $argv
    set -l exit_status $status

    if test $exit_status -eq 0
        if contains -- $argv[1] install remove update uninstall
            echo "[dotfiles] Sincronizando listas via wrapper..."
            sync-pkgs
        end
    end

    return $exit_status
end
