#!/bin/bash

# Cores para facilitar a leitura no terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}[*] Iniciando a configuração do sistema do Liceki...${NC}\n"

# 1. Garantir que estamos no diretório certo
cd ~/dotfiles || { echo -e "${RED}Erro: Pasta ~/dotfiles não encontrada.${NC}"; exit 1; }

# 2. Limpeza de configs padrão (Evitar conflitos com o Stow)
echo -e "${BLUE}[*] Limpando configurações antigas para liberar caminho para o Stow...${NC}"
rm -rf ~/.config/aichat
rm -rf ~/.config/fish
rm -rf ~/.config/nvim
rm -f ~/.gitconfig ~/.gitignore_global
rm -f ~/.taskrc
rm -f ~/.local/bin/extract_media.fish ~/.local/bin/resgate-final.fish
# Cria a pasta Pictures/Wallpapers se não existir, para o stow não falhar
mkdir -p ~/Pictures/Wallpapers
rm -f ~/Pictures/Wallpapers/wpp1.jpg

# 3. Aplicar o Stow
echo -e "\n${BLUE}[*] Criando links simbólicos (Stow)...${NC}"
STOW_FOLDERS=(aichat fish git nvim scripts task wallpapers)

for folder in "${STOW_FOLDERS[@]}"; do
    echo " -> Aplicando stow em: $folder"
    stow "$folder"
done

# 4. Ajuste de permissões
echo -e "\n${BLUE}[*] Ajustando permissões de execução dos scripts...${NC}"
chmod +x ~/.local/bin/*

# 5. Instalação de Pacotes Oficiais (Pacman)
echo -e "\n${BLUE}[*] Instalando pacotes do repositório oficial (Pacman)...${NC}"
sudo pacman -Syu --needed - < packages/pacman_list.txt

# 6. Instalação do Yay (se não estiver instalado)
if ! command -v yay &> /dev/null; then
    echo -e "\n${RED}[!] Yay não encontrado. Baixando e compilando o Yay...${NC}"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit
    makepkg -si --noconfirm
    rm -rf /tmp/yay
    cd ~/dotfiles || exit
fi

# 7. Instalação de Pacotes da Comunidade (AUR)
echo -e "\n${BLUE}[*] Instalando pacotes do AUR...${NC}"
yay -S --needed - < packages/yay_list.txt

# 8. Instalação de Flatpaks
echo -e "\n${BLUE}[*] Configurando e instalando Flatpaks...${NC}"
sudo pacman -S --needed flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Usa o xargs para ler o txt e passar como argumento para o flatpak install
xargs -a packages/flatpak_list.txt flatpak install flathub -y

# 9. Definir Fish como shell padrão
if [ "$SHELL" != "/usr/bin/fish" ]; then
    echo -e "\n${BLUE}[*] Mudando o shell padrão para o Fish...${NC}"
    chsh -s /usr/bin/fish "$USER"
fi

echo -e "\n${GREEN}[✔] Instalação concluída com sucesso. Reinicie o terminal ou faça logoff para aplicar o novo shell e variáveis.${NC}"
