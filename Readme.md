# Dotfiles

That is yet another iteration on management of my dotfiles. This time it is
based on [GNU Stow][] tool. This tool allows to easily create symlinks from the
repository to the home directory.

## Sensitive information

Sensitive information in this repository is stored using [git-crypt][]

## Fresh system

It is expected that system has bash installed. The rest should be handled by the
installation script itself. So just clone the repo and run:

```
bash scripts/install.sh
```

## Maintenance

When you need to add something to dotfiles, just create an empty dir (or a file)
in the dotfiles dir and then just adopt the actual dir/file using stow:

```
mkdir .config/new-tool
stow --adopt -t ~ .
```




[GNU Stow]: https://www.gnu.org/software/stow
[git-crypt]: https://github.com/AGWA/git-crypt
