if [[ $(uname) == "Darwin" ]]; then
    source os/mac/packages.zsh
    source packages.zsh
    cat env.zsh > zshrc
    cat os/mac/aliases.zsh >> zshrc
    cat aliases.zsh >> zshrc
fi

