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

# Cria uma versão temporária e limpa da blacklist (sem # e sem linhas vazias)
set CLEAN_IGNORE "/tmp/clean_ignore.txt"
grep -v -E '^\s*(#|$)' "$IGNORE_FILE" > "$CLEAN_IGNORE"

# 1. Extrai pacotes nativos (Pacman), ignora a blacklist e salva
pacman -Qqen | grep -v -E -f "$CLEAN_IGNORE" > "$PACKAGES_DIR/pacman_list.txt"

# 2. Extrai pacotes da comunidade (AUR/Yay), ignora a blacklist e salva
pacman -Qqem | grep -v -E -f "$CLEAN_IGNORE" > "$PACKAGES_DIR/yay_list.txt"

# 3. Extrai Flatpaks (não usa a blacklist do pacman)
flatpak list --app --columns=application > "$PACKAGES_DIR/flatpak_list.txt"

# Limpa o arquivo temporário
rm "$CLEAN_IGNORE"

# ==============================================================================
# Auto-Commit
# Commita e envia as mudanças automaticamente se houver alteração real nas listas
# ==============================================================================
cd "$DOTFILES_DIR"
git add packages/

# Verifica se o git add colocou algo novo no stage (se a lista mudou)
if not git diff --cached --quiet
    git commit -m "chore(packages): auto-sync pacman, yay and flatpak lists"
    git push
else
    # Opcional: Descomente a linha abaixo se quiser ver essa mensagem no log do pacman
    echo "Nenhuma alteração nas listas de pacotes. Auto-commit ignorado."
end
