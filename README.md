# dotfiles deployment (inspired by [hackernews](https://news.ycombinator.com/item?id=11070797)):

```sh
cd
git clone --bare git@github.com:weirdgiraffe/dotfiles.git $HOME/.dotfiles
alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-dir=$HOME/"
dotfiles checkout
```

then resolve all possible conflicts and

```sh
config config status.showUntrackedFiles no
```

