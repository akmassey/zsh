# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == */usr/local/opt/fzf/man* && -d "/usr/local/opt/fzf/man" ]]; then
  export MANPATH="$MANPATH:/usr/local/opt/fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
if [ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]; then
  source "/usr/local/opt/fzf/shell/key-bindings.zsh"
fi

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# fzf + rg configuration
if which fzf > /dev/null 2>&1 && which rg > /dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --no-messages --glob "!.git/*"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude '.git'"

  export FZF_DEFAULT_OPTS="
  --multi
  --height 40%
  --preview-window='right'
  --color fg:188,bg:233,hl:103,fg+:222,bg+:234,hl+:104
  --color info:183,prompt:110,spinner:107,pointer:167,marker:215
  --bind='ctrl-y:execute-silent(echo {+} || pbcopy)'
  --preview='/usr/local/bin/lesspipe.sh {} | /usr/local/bin/bat --style=numbers --color=always'
  "

  # Use fd (https://github.com/sharkdp/fd) instead of the default find
  # command for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
fi

# replace CTRL-o with cd widget
bindkey '^o' fzf-cd-widget

# BibTeX Setup  More info: https://github.com/msprev/fzf-bibtex
# ------------
export FZF_BIBTEX_CACHEDIR="$HOME/.cache/fzf-bibtex"
export FZF_BIBTEX_SOURCES="$HOME/Documents/Resume/akmassey-umbc-cv/bib/akm-publications.bib"

# # TODO: create Ctrl-P shortcut for vim
# #     See: http://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before/
# function execute_nvim_through_fzf {
#   nvim $(fzf)
# }
# zle -N execute_nvim_through_fzf
# bindkey -M viins '^p' execute_nvim_through_fzf
# bind -x '"\C-p": nvim $(fzf);'
