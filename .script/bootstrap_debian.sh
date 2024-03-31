#!/bin/bash
shopt -s expand_aliases
source ~/.bash_aliases

USERNAME=hesperaux

install_pyenv() {
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
}

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
    cd ~/git && git clone https://github.com/jandamm/zgenom.git ~/.zgen
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

install_starship() {
    curl -sS https://starship.rs/install.sh | sh
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

install_brave_repo() {
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

}

install_dotnet() {
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install dotnet-sdk-8.0
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

base_install() {
    sudo apt-get update
    sudo apt-get install \
        build-essential \
        apt-transport-https \
        curl \
        cmake \
        cifs-utils \
        diffutils \
        dnsutils \
        fdisk \
        git \
        gzip \
        hdparm \
        hostname \
        inetutils-telnet \
        lm-sensors \
        mlocate \
        nano \
        ntfs-3g \
        parted \
        pciutils \
        qalc \
        libqalculate-dev \
        samba \
        screen \
        traceroute \
        usbutils \
        psmisc \
        bridge-utils \
        python3-pip \
        binutils-dev \
        gcc \
        g++ \
        pkg-config \
        nettle-dev \
        libpipewire-0.3-dev \
        psmisc \
        golang \
        netctl \
        usbtop \
        btop \
        powerstat \
        gettext\
        ninja-build\
        gettext \
        unzip \
        luajit \
        libluajit-5.1-dev \
        lua-mpack \
        lua-lpeg \
        libunibilium-dev \
        libmsgpack-dev \
        libtermkey-dev \
        ripgrep \
        libtree-sitter0 \
        libvterm0 \
        lua-luv \
        python3-greenlet \
        python3-msgpack \
        python3-pynvim \
        ruby \
        black \
        python3-venv \
        hunspell \
        bat \
        zoxide \
        tmux
    sudo apt-get install --no-install-recommends npm
}

server_install() {
    base_install
    sudo apt-get install \
    docker.io \
    docker-compose \
    nfs-kernel-server \
    nfs-common
}

desktop_install() {
    base_install
    sudo apt-get install \
        rofi \
        flatpak \
        geany \
        mousepad \
        snapd \
        gdb-multiarch \
        openocd \
        qemu-system-arm \
        i3lock\
        flameshot \
        alacritty \
        blender \
        fonts-firacode \
        freecad\
        geeqie \
        git-gui \
        gitk \
        gtk2-engines \
        gtk2-engines-aurora\
        gtk2-engines-cleanice \
        gtk2-engines-murrine \
        gtk2-engines-oxygen\
        gtk2-engines-pixbuf \
        gtk2-engines-sugar \
        gtk3-engines-breeze\
        yaru-theme-gtk \
        i3 \
        i3lock \
        linux-source \
        mousepad \
        rofi-dev \
        sensible-utils \
        snapd \
        vlc \
        xarchiver \
        xbacklight \
        xcb \
        xcb-proto \
        xclip \
        feh \
        xsel \
        gpick\
        libiw-dev \
        blueman \
        lxappearance \
        picom \
        python3-xcffib\
        python3-cairocffi \
        libpangocairo-1.0-0 \
        fonts-dejavu-core\
        libfontconfig-dev \
        libegl-dev \
        libgl-dev \
        libgles-dev\
        libspice-protocol-dev \
        nettle-dev \
        libx11-dev \
        libxcursor-dev \
        libxi-dev\
        libxinerama-dev \
        libxpresent-dev \
        libxss-dev \
        libxkbcommon-dev \
        libwayland-dev\
        wayland-protocols \
        libpipewire-0.3-dev \
        libpulse-dev \
        libsamplerate0-dev\
        feh \
        wmctrl \
        slop \
        fonts-sil-andika \
        libunibilium-dev \
        libmsgpack-dev \
        libtermkey-dev\
        gcc-arm-none-eabi \
        lightdm \
        numlockx \
        redshift
}

install_brave() {

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
elif [[ "$1" == "desktop-packages" ]]; then
    desktop_install
    exit
elif [[ "$1" == "server-packages" ]]; then
    server_install
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
    install_brave
    exit
elif [[ "$1" == "fzf" ]]; then
    install_fzf
    exit
elif [[ "$1" == "starship" ]]; then
    install_starship
    exit
elif [[ "$1" == "pyenv" ]]; then
    install_pyenv
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
    echo "Options are: looking-glass, rofi-calc, apt, neovim, zsh, dotnet, brave, dotfiles, desktop-packages, server-packages"
fi;
