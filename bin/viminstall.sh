#!/bin/bash

# Install vim from source
# =================================== 
sudo apt-get install libcurses5-dev libgnome2-dev libgnomeui-dev \
					 libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
					 libcairo2-dev libx11-dev libxpm-dev libxt-dev \
					 python-dev
sudo apt-get remove vim vim-runtime gvim vim-tiny vim-common gim-gui-common
cd ~/
# Note: this needs hg as a prerequisite
hg clone https://code.google.com/p/vim
cd vim
./configure --with-features=huge \
			--enable-multibyte \
			--enable-rubyinterp \
			--enable-pythoninterp \
			--with-python-config-dir=/usr/lib/python2.7/config \
			--enable-perlinterp \
			--enable-luainterp \
			--enable-gui=gtk --enable-cscope \
			--prefix=/usr
make VIMRUNTIMEDIR=/usr/share/vim/vim74
sudo make install
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/bim 1
sudo update-alternatives --set vi /usr/bin/vim

# Install Vundle
# ==================================
if [ ! -d "~/.vim/bundle" ]; then
	mkdir ~/.vim/bundle
fi

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
if [ -e "~/.vimrc" ]; then
	echo "Making a backup of old .vimrc as .vimrc.bak"
	cp .vimrc .vimrc.bak
	cp vimrc.txt .vimrc
else
	cp vimrc.txt .vimrc
fi

vim +BundleInstall

# Install YouCompleteMe
# ===================================
sudo apt-get install build-essential cmake
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer
cd ~

# Syntastic dependencies
# ===================================
sudo apt-get install pylint
sudo apt-get install pyflakes
