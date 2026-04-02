function sync-pkgs
    set PKG_DIR ~/dotfiles/packages
    set DOTFILES_DIR ~/dotfiles

    echo "Extraindo listas de pacotes (pacman, yay, flatpak)..."
    pacman -Qqen > $PKG_DIR/pacman_list.txt
    pacman -Qqem > $PKG_DIR/yay_list.txt
    flatpak list --app --columns=application > $PKG_DIR/flatpak_list.txt

    cd $DOTFILES_DIR

    echo "Verificando alterações no controle de versão..."
    if not git diff --quiet HEAD packages/pacman_list.txt packages/yay_list.txt packages/flatpak_list.txt
        git commit packages/pacman_list.txt packages/yay_list.txt packages/flatpak_list.txt -m "chore(pkg): sync package lists"
        echo "Listas atualizadas e commitadas com sucesso."
    else
        echo "Nenhuma alteração detectada nas listas."
    end

    cd - > /dev/null
end
