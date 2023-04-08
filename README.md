# dotfiles

## Setup (mac)

### Clone this repository

**Please clone the dotfiles directly under your home directory.**

```shell
cd ~
git clone https://github.com/jion-kozono/dotfiles.git
```


### Install the required libraries && Place each dotfiles as a symbolic link

```shell
cd ~/dotfiles
sh scripts/install.sh
```

## Features

### Check update dotfiles repository

When loading .zshrc, it will tell you if there are any changes in the dotfiles repository.

[details](zsh/.zshrc.check_update_dotfiles)

```
=== DOTFILES IS DIRTY ===
  The dotfiles have been changed. Please update them with the following command.

  cd ~/dotfiles
  git add .
  git commit -m "update dotfiles"
  git push origin main
=========================
```
