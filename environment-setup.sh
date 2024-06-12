#!/bin/bash

# Update and upgrade the system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install git
sudo apt-get install -y git make postgresql-client

# Clone the asdf repository
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

# Add asdf to the shell
echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
source ~/.bashrc

# Reload the shell configuration
source ~/.bashrc

# Add the Python plugin to asdf
asdf plugin-add python

# Install Python 3.9 using asdf
asdf install python 3.9.0

# Set the installed Python version as the global default
asdf global python 3.9.0

python -m pip install --upgrade pip && \
pip install poetry

python -m poetry run poetry install
