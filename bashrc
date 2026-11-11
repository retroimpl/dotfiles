# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

export PATH="$PATH:$(go env GOPATH)/bin"

export EDITOR=/usr/bin/nvim
export FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"
export FZF_DEFAULT_COMMAND="fd --type f"
export GODOT_BIN=$HOME/.local/bin/godot

alias vim=nvim
alias cdd="cd $HOME/Desktop"
alias cdg="cd $HOME/Goinfre"

vf() {
    nvim "$(fzf)"
}

bf() {
    bat "$(fzf)"
}
