# deployment:

```sh
cd
git clone --bare git@github.com:weirdgiraffe/dotfiles.git $HOME/.dotfiles
alias config="git --git-dir=$HOME/.dotfiles/ --work-dir=$HOME/"
config checkout
```

then resolve all possible conflicts and

```sh
config config status.showUntrackedFiles no
```

