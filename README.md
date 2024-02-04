
# Personal dotfiles repo

This is my personal dotfiles repo. Since I use multiple VMs, its PITA to setup each one, hence I just created dotfiles for easier sync of confs between VMs.




## Pre-requisite

Install stow for symlink farming

```bash
  apt install stow
```
## Clone

Clone dotfiles

Note: It is very important to clone this repository on the top-level $HOME directory.

```bash
  cd $HOME
  git clone https://github.com/ujwalp15/dotfiles.git
```
## Installation

Use stow to install confs to $HOME

```bash
  cd dotfiles
  stow .
```

## License

[MIT](https://choosealicense.com/licenses/mit/)


