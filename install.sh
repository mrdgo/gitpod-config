#!/usr/bin/env bash

# install rsync to deploy dotfiles
sudo apt install --yes rsync libicu-dev libncurses-dev libgmp-dev zlib1g-dev

wget https://downloads.haskell.org/~hls/haskell-language-server-1.8.0.0/haskell-language-server-1.8.0.0-x86_64-linux-deb10.tar.xz
tar -xvf haskell-language-server-1.8.0.0-x86_64-linux-deb10.tar.xz
export PATH="$PATH:$(pwd)/haskell-language-server-1.8.0.0/bin"


cd $(mktemp -d)

URL="https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"
curl -LO "$URL"
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract >/dev/null
mkdir -p /home/gitpod/.local/bin
ln -s $(pwd)/squashfs-root/AppRun /home/gitpod/.local/bin/nvim

pushd /opt
sudo git clone \
  --depth 1  \
  --filter=blob:none  \
  --sparse \
  https://github.com/mrdgo/dots \
  /opt/dots \
;
sudo chown -R gitpod:gitpod dots
cd dots
git sparse-checkout set roles/nvim/files/nvim
mkdir -p ~/.config/nvim
rsync -a roles/nvim/files/nvim/ ~/.config/nvim
popd
