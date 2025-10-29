fastfetch

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

plugins=(git)
source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

export ARCHFLAGS="-arch $(uname -m)"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"
export PATH="$PATH:$HOME/.local/bin"
