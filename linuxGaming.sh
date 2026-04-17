#! bin/bash
#!/bin/bash

# By Aldo Alfonso Mendoza && microsoft-copilot
# TikTok: @v3nomscool
# Instagram: @v3noms

# Colores
verde="\e[32m"
rojo="\e[31m"
azul="\e[34m"
amarillo="\e[33m"
reset="\e[0m"

# Banner futurista gamer
echo -e "${azul}
███████╗ █████╗ ███╗   ███╗███████╗ ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗████╗ ████║██╔════╝██╔═══██╗██╔══██╗██╔════╝
█████╗  ███████║██╔████╔██║█████╗  ██║   ██║██████╔╝███████╗
██╔══╝  ██╔══██║██║╚██╔╝██║██╔══╝  ██║   ██║██╔═══╝ ╚════██║
██║     ██║  ██║██║ ╚═╝ ██║███████╗╚██████╔╝██║     ███████║
╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝     ╚══════╝
${reset}"

echo -e "${verde}Bienvenido al entorno gaming para Linux Mint 🚀${reset}"
echo "Este proceso instalará herramientas útiles para jugar y emular."

# Actualizar sistema
sudo apt update -y && sudo apt upgrade -y

# Instalar Snapd
echo -e "${amarillo}Instalando Snapd...${reset}"
sudo rm -f /etc/apt/preferences.d/nosnap.pref
sudo apt install -y snapd
sudo systemctl enable --now snapd.socket
sudo systemctl enable --now snapd.service
snap version

# Función para preguntar
preguntar() {
    mensaje=$1
    comando=$2
    read -p "$(echo -e "${azul}${mensaje} (y/n):${reset}")" respuesta 
    if [[ "$respuesta" =~ ^[yY]$ ]]; then
        eval "$comando"
        echo -e "${verde}✔ Instalado correctamente${reset}"
    else
        echo -e "${rojo}✘ Cancelado${reset}"
    fi
}

# Preguntas interactivas
preguntar "¿Quieres instalar Copilot Desktop?" "sudo snap install copilot-desktop"
preguntar "¿Quieres instalar Dolphin Emulator (GameCube/Wii)?" "sudo snap install dolphin-emulator"

# Drivers GPU
read -p "$(echo -e "${azul}¿Quieres instalar drivers de tarjeta gráfica para gaming? (y/n):${reset} ") " respuesta
if [[ "$respuesta" =~ ^[yY]$ ]]; then
    GPU=$(lspci | grep -E "VGA|3D")
    echo "Tu GPU detectada es: $GPU"
    if echo "$GPU" | grep -qi "NVIDIA"; then
        sudo apt install -y nvidia-driver-550
    elif echo "$GPU" | grep -qi "AMD"; then
        sudo apt install -y mesa-vulkan-drivers mesa-utils
    else
        echo "Drivers Intel ya vienen integrados."
    fi
else
    echo -e "${rojo}✘ No se instalarán drivers${reset}"
fi

# PCSX2
read -p "$(echo -e "${azul}¿Quieres instalar PCSX2 (PlayStation 2)? (y/n):${reset}") " respuesta

if [[ "$respuesta" =~ ^[yY]$ ]]; then
    if ! command -v flatpak &> /dev/null; then
        sudo apt install -y flatpak
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
    flatpak install -y flathub net.pcsx2.PCSX2
    echo -e "${verde}✔ PCSX2 instalado${reset}"
fi

# MangoHud
preguntar "¿Quieres instalar MangoHud (overlay FPS)?" "sudo apt install -y mangohud"

# GameMode
preguntar "¿Quieres instalar GameMode (optimización rendimiento)?" "sudo apt install -y gamemode"

echo -e "${verde}✅ Instalación finalizada. ¡Disfruta tu entorno gaming en Linux Mint!${reset}"


