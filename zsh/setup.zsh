if [[ $(uname) == "Darwin" ]]; then
    rm -rf ~/.zim
    rm -rf ~/.zimrc
    rm -rf ~/.zshrc
    source os/mac/packages.zsh
    source packages.zsh
    cp p10k.zsh ~/.p10k.zsh
    cat env.zsh >> ~/.zshrc
    cat os/mac/aliases.zsh >> ~/.zshrc
    cat aliases.zsh >> ~/.zshrc
    echo >> ~/.zshrc
    echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc
fi

