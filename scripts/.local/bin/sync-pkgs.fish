#!/usr/bin/fish

# ==============================================================================
# SYNC-PKGS
# Extrai os pacotes instalados no sistema e salva nas listas do dotfiles,
# ignorando pacotes específicos de hardware definidos no pacman_ignore.txt
# ==============================================================================

# Define os caminhos base
set DOTFILES_DIR "/home/liceki/dotfiles"
set PACKAGES_DIR "$DOTFILES_DIR/packages"
set IGNORE_FILE "$PACKAGES_DIR/pacman_ignore.txt"

# Garante que o arquivo de ignore existe para o grep não quebrar
if not test -f "$IGNORE_FILE"
    echo "Aviso: Arquivo $IGNORE_FILE não encontrado. Criando um vazio..."
    touch "$IGNORE_FILE"
end

# 1. Extrai pacotes nativos (Pacman), ignora a blacklist e salva
pacman -Qqen | grep -v -E -f "$IGNORE_FILE" > "$PACKAGES_DIR/pacman_list.txt"

# 2. Extrai pacotes da comunidade (AUR/Yay), ignora a blacklist e salva
pacman -Qqem | grep -v -E -f "$IGNORE_FILE" > "$PACKAGES_DIR/yay_list.txt"

# 3. Extrai Flatpaks (não usa a blacklist do pacman)
flatpak list --app --columns=application > "$PACKAGES_DIR/flatpak_list.txt"

# ==============================================================================
# Opcional: Auto-Commit
# Descomente as linhas abaixo se quiser que o script commite as mudanças
# automaticamente sempre que for acionado pelo hook do pacman.
# ==============================================================================
cd "$DOTFILES_DIR"
git add packages/
git commit -m "chore(packages): auto-sync pacman, yay and flatpak lists"
git push 
