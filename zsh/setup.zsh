# vim: ft=zsh ts=2 sw=2 sts=2 et
set -x

if [[ $(uname) == "Darwin" ]]; then
    source os/mac/packages.zsh
    source packages.zsh
    cat env.zsh > zshrc
    cat os/mac/aliases.zsh >> zshrc
    cat aliases.zsh >> zshrc
fi

