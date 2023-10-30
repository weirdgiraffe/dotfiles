rm -rf ~/.zim
rm -rf ~/.zimrc

cat << \EOF >| ~/.zshrc
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

EOF

if [[ $(uname) == "Darwin" ]]; then
    source os/mac/packages.zsh
fi

source packages.zsh

cat env.zsh >> ~/.zshrc

if [[ $(uname) == "Darwin" ]]; then
  cat os/mac/aliases.zsh >> ~/.zshrc
fi

cat aliases.zsh >> ~/.zshrc

cp p10k.zsh ~/.p10k.zsh
cat << \EOF >> ~/.zshrc
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
EOF

