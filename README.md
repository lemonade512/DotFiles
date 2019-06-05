# Overview
This repository stores all of my development config. If I need a new
development machine, I can get everything set up and configured with less
than 5 commands and in under 10 minutes.

Everything has been designed to be user-friendly so others can easily use my
configuration as is or add it to their own configuration.

# Installation Instructions
In a terminal run the following commands in your home directory:
```sh
git clone --recurse-submodules https://github.com/lemonade512/DotFiles.git .dotfiles
cd .dotfiles
sudo pip install -r requirements.txt
python install.py
```

Note that some dotfiles are built from templates. The built files will be
stored in the `build` directory. If you want to rebuild these files, you
will need to re-run the install script.

# Libraries
The install script does not install many of the libraries I use on a daily
basis, such as google-appengine, android-studio, and google-cloud-sdk. The
.bashrc assumes these libraries are located in a libraries folder in the home
directory. If you need these libraries, you will need to install them
manually.
