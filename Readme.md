# Dotfiles

I found quite an interesting repository on github
[pokerus](https://github.com/j-hui/pokerus) which uses quite an interesting
techinque to manage dotfiles:

- It register local git subcommands for this repository, in case of pokerus it's
  infect,disindefct, etc.
- Those subcommands are replacing files in the system using symlinks

I like this idea, and this repository tries to follow the same concept.



Usefull commands:


Check if symlink command is already registered as git subcommand

```sh
git --list-cmds=main,others,alias | grep link || echo link: OK
git --list-cmds=main,others,alias | grep unlink || echo unlink: OK
```


