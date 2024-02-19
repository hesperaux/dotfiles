#!/bin/bash
shopt -s expand_aliases
source ~/.bash_aliases

install_polybar_themes () {
    mkdir ~/repos
    mkdir ~/git
    cd ~/git && git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
    echo "Choose polybar theme..."
    cd ~/git/polybar-themes/ && chmod +x setup.sh
    ~/git/polybar-themes/setup.sh
}

install_zsh_with_zgenom () {
    sudo apt-get update
    sudo apt-get install zsh
    cd ~/git && git clone https://github.com/jandamm/zgenom.git
}

install_looking_glass_deps () {
    sudo apt-get install binutils-dev cmake fonts-dejavu-core libfontconfig-dev \
        gcc g++ pkg-config libegl-dev libgl-dev libgles-dev libspice-protocol-dev \
        nettle-dev libx11-dev libxcursor-dev libxi-dev libxinerama-dev \
        libxpresent-dev libxss-dev libxkbcommon-dev libwayland-dev wayland-protocols \
        libpipewire-0.3-dev libpulse-dev libsamplerate0-dev
}

install_fzf() {
    cd ~/git && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

install_rofi_calc () {
    DIR=`pwd`
    sudo apt-get install rofi-dev qalc libtool libtool-bin autoconf
    cd ~/git
    git clone https://github.com/svenstaro/rofi-calc.git
    cd rofi-calc/
    mkdir m4
    autoreconf -i
    mkdir build
    cd build/
    ../configure
    make
    sudo make install
    cd ${DIR}
    exit
}




USERNAME=hesperaux


install_brave_repo() {
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

}

install_dotnet() {
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install dotnet-sdk-8.0 dotnet-sdk-7.0
}

install_neovim_git() {
    mkdir -p ${HOME}/git
    cd ${HOME}/git
    git clone https://github.com/neovim/neovim.git
    cd neovim
    cmake -S cmake.deps -B .deps -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo -DUSE_BUNDLED=OFF -DUSE_BUNDLED_LIBUV=ON -DUSE_BUNDLED_LUV=ON -DUSE_BUNDLED_LIBVTERM=ON -DUSE_BUNDLED_TS=ON
    cmake --build .deps
    cmake -B build -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo
    cmake --build build
}


deps() {
    sudo apt-get update

    sudo apt-get install build-essential apt-transport-https rofi flatpak curl \
        geany mousepad snapd gdb-multiarch openocd qemu-system-arm \
        i3lock flameshot cmake alacritty blender chromium cifs-utils \
        codeblocks diffutils dnsutils fdisk fonts-firacode \
        freecad geeqie git git-gui gitk gtk2-engines \
        gtk2-engines-aurora gtk2-engines-cleanice gtk2-engines-murrine \
        gtk2-engines-oxygen gtk2-engines-pixbuf gtk2-engines-sugar \
        gtk3-engines-breeze gzip hdparm hostname i3 i3lock \
        inetutils-telnet linux-image-amd64 linux-source lm-sensors \
        mlocate mousepad nano ntfs-3g parted pciutils \
        qalc rofi-dev libqalculate-dev samba screen sensible-utils snapd traceroute \
        usbutils vlc xarchiver xbacklight xcb xcb-proto xclip \
        psmisc feh xsel flatpak yaru-theme-gtk bridge-utils \
        gpick libiw-dev blueman lxappearance picom python3-pip \
        python3-xcffib python3-cairocffi libpangocairo-1.0-0 binutils-dev cmake \
        fonts-dejavu-core libfontconfig-dev gcc g++ pkg-config libegl-dev libgl-dev \
        libgles-dev libspice-protocol-dev nettle-dev libx11-dev libxcursor-dev \
        libxi-dev libxinerama-dev libxpresent-dev libxss-dev libxkbcommon-dev \
        libwayland-dev wayland-protocols libpipewire-0.3-dev libpulse-dev \
        libsamplerate0-dev psmisc feh wmctrl slop golang npm netctl \
        usbtop btop powerstat fonts-sil-andika gettext cmake ninja-build gettext unzip \
        luajit libluajit-5.1-dev lua-mpack lua-lpeg libunibilium-dev libmsgpack-dev \
        libtermkey-dev ripgrep libtree-sitter0 libvterm0 lua-luv python3-greenlet python3-msgpack \
        python3-pynvim ruby black numlockx gcc-arm-none-eabi python3-venv hunspell lightdm \
        bat zoxide tmux

    #	xfce4-battery-plugin xfce4-clipman-plugin \
        #	xfce4-cpugraph-plugin xfce4-diskperf-plugin xfce4-mount-plugin \
        #	xfce4-netload-plugin xfce4-pulseaudio-plugin \
        #	xfce4-sensors-plugin xfce4-systemload-plugin \
        #	xfce4-weather-plugin
}

brave() {

    install_brave_repo
    sudo apt-get update
    sudo apt-get install brave-browser
}


if [[ "$1" == "looking-glass" ]]; then
    install_looking_glass_deps
    exit
elif [[ "$1" == "rofi-calc" ]]; then
    install_rofi_calc
    exit
elif [[ "$1" == "apt" ]]; then
    deps
    exit
elif [[ "$1" == "neovim" ]]; then
    install_neovim_git
    exit
elif [[ "$1" == "zsh" ]]; then
    install_zsh_with_zgenom
    exit
elif [[ "$1" == "dotnet" ]]; then
    install_dotnet
    exit
elif [[ "$1" == "brave" ]]; then
    brave
    exit
elif [[ "$1" == "fzf" ]]; then
    install_fzf
    exit
elif [[ "$1" == "dotfiles" ]]; then
    if [[ ! -d "${HOME}/.wallfiles" ]]; then
        git clone git@github.com:hesperaux/wallfiles.git --bare ~/.wallfiles
    fi;
    if [[ ! -d "${HOME}/.themefiles" ]]; then
        git clone git@github.com:hesperaux/themefiles.git --bare ~/.themefiles
    fi;
    if [[ ! -d "${HOME}/.fontfiles" ]]; then
        git clone git@github.com:hesperaux/fontfiles.git --bare ~/.fontfiles
    fi;
    dotfiles config --local status.showUntrackedFiles no
    wallfiles config --local status.showUntrackedFiles no
    themefiles config --local status.showUntrackedFiles no
    fontfiles config --local status.showUntrackedFiles no
    exit
else
    echo "Options are: looking-glass, rofi-calc, apt, neovim, zsh, dotnet, brave, dotfiles"
    echo "Using 'su' to add ${USERNAME} to sudo group."
    su -c 'gpasswd -a ${USERNAME} sudo'
fi;
