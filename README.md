<h1>Overview</h1>
In this repository I keep all of my config files for vim, mercurial, and other
programs I use. I also have some cheat sheets and other miscellaneous files
that I use during development.

The installation script was inspired by (and mostly copied from) https://github.com/hashrocket/dotmatrix.

<h1>Installation Instructions</h1>
In a terminal run the following commands in your home directory:
```sh
git clone --recurse-submodules https://github.com/lemonade512/DotFiles.git .dotfiles
cd .dotfiles
./install.sh
```

<h1>Libraries</h1>
The install script does not install many of the libraries I use on a daily
basis, such as google-appengine, android-studio, and google-cloud-sdk. The
.bashrc assumes these libraries are located in a libraries folder in the home
directory. If you need these libraries, you will need to install them
manually.
