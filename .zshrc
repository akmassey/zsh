# To profile startup times: https://esham.io/2018/02/zsh-profiling
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light mroth/evalcache
zinit light lukechilds/zsh-nvm

# Add in snippets
zinit snippet OMZP::command-not-found
#zinit snippet OMZP::fd
zinit snippet OMZP::pyenv
zinit snippet OMZP::rbenv
zinit snippet OMZP::gem
zinit snippet OMZP::bundler
zinit snippet OMZP::golang
#zinit snippet OMZP::rust
zinit snippet OMZP::npm

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
# bindkey -e
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
# bindkey '^[w' kill-region

# History
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# zoxide init https://github.com/ajeetdsouza/zoxide
# eval "$(zoxide init --cmd cd zsh)"
_evalcache zoxide init --cmd cd zsh

# source keychain prior to anything
if [ -x $HOMEBREW_PREFIX/bin/keychain ]; then
  # for Mac OS X only
  eval "$(keychain --eval --inherit any id_rsa id_ed25519)"
fi

# TODO: update this to use `curl wttr.in` since forecast.io was killed
# # Print weather information
# if [[ -e $HOME/.weather && -x /bin/cat ]]; then
#   /bin/cat $HOME/.weather
#   echo "\n"
# fi

# Print stock quotes
if [[ -e $HOME/.stocks && -x /bin/cat ]]; then
  /bin/cat $HOME/.stocks
  echo "\n"
fi

if [[ -x $HOME/bin/monitor-sites ]]; then
  /bin/cat $HOME/.monitored_sites
  echo "\n"
fi

# Print a quote
if type fortune > /dev/null 2>/dev/null; then
  fortune $HOME/Documents/Fortunes/akm-quotes
  echo "\n"
fi

# Load custom functions
fpath=( $HOME/.zsh/functions "${fpath[@]}" )
autoload -Uz duck
autoload -Uz cdf
autoload -Uz lno
autoload -Uz loop
autoload -Uz mcd
autoload -Uz reload
autoload -Uz rule
autoload -Uz rulem
autoload -Uz sizeup
autoload -Uz o
autoload -Uz p
autoload -Uz timezsh
autoload -Uz getcertnames

# Starting to find autocorrect rather annoying...
unsetopt correct_all

# Load fzf configuration
[ -f ~/.zsh/fzf.zsh ] && source ~/.zsh/fzf.zsh

# # Node Version Manager
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# # bun
# [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

# # Lunchy config
# LUNCHY_DIR=$(dirname `gem which lunchy`)/../extras
# if [ -f $LUNCHY_DIR/lunchy-completion.zsh ]; then
#   . $LUNCHY_DIR/lunchy-completion.zsh
# fi

# sqlite config
if [[ -x "$(brew --prefix)/opt/sqlite/bin/sqlite3" ]]; then
  export PATH="$(brew --prefix)/opt/sqlite/bin:$PATH"
fi

# load aliases
if [ -f ~/.zsh/aliases ]; then source ~/.zsh/aliases; fi

# load functions
source ~/.zsh/functions/*

# set your editor
if [[ -f /opt/homebrew/bin/nvim && -x /opt/homebrew/bin/nvim ]]; then
  export EDITOR=/opt/homebrew/bin/nvim
elif [[ -f /usr/local/bin/nvim && -x /usr/local/bin/nvim ]]; then
  export EDITOR=/usr/local/bin/nvim
elif [[ -f /usr/bin/nvim && -x /usr/bin/nvim ]]; then
  export EDITOR=/usr/bin/nvim
else
  export EDITOR=/usr/bin/vim
fi;

# used by git-latexdiff
export PDFVIEWER=/Applications/Skim.app/Contents/MacOS/Skim

# ensure HTML Tidy uses your configuration file
[[ -f $HOME/.tidyrc ]] && export HTML_TIDY=$HOME/.tidyrc

# ensure Go is in your PATH
[[ -d $HOME/src/go ]] && export GOPATH=$HOME/src/go
[[ -d $HOME/src/go/bin ]] && export GOBIN=$HOME/src/go/bin
export PATH="$GOBIN:$PATH"

# colorized man pages
man () {
LESS_TERMCAP_mb=$'\e'"[1;31m" \
LESS_TERMCAP_md=$'\e'"[1;31m" \
LESS_TERMCAP_me=$'\e'"[0m" \
LESS_TERMCAP_se=$'\e'"[0m" \
LESS_TERMCAP_so=$'\e'"[1;44;33m" \
LESS_TERMCAP_ue=$'\e'"[0m" \
LESS_TERMCAP_us=$'\e'"[1;32m" \
command man "$@"
}
# export MANPAGER="env MAN_PN=1 /usr/local/bin/vim -u NONE -N -M +MANPAGER -"

# Avoid unnecessary paging in git
# export GIT_PAGER="less -FRXK"
export GIT_PAGER="delta"

# An input filter to allow less to display more than just plain text.  More
# info here:  https://github.com/wofr06/lesspipe
export LESSOPEN="|/opt/homebrew/bin/lesspipe.sh %s"
export LESS="--mouse"

# Source completions for git-extras
if [[ -f /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh ]]; then
  source /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh
fi

# rbenv configuration
# NOTE: we need this to appear after homebrew, python, etc...
if command -v rbenv > /dev/null; then
  # eval "$(rbenv init -)"
  _evalcache rbenv init -
fi

# pyenv config
if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  # eval "$(pyenv init --path -)"
  _evalcache pyenv init --path -
fi

# Perl brew
if [ -f $HOME/perl5/perlbrew/etc/bashrc ]; then source $HOME/perl5/perlbrew/etc/bashrc; fi

# load Rust settings
if [ -d $HOME/.cargo ] && [ -f $HOME/.cargo/env ]; then source $HOME/.cargo/env; fi

# load private configuration
if [ -d $HOME/.private ]; then source ~/.private/*; fi

# # yarn configuration
# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# iterm2 integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# Created by `pipx` on 2021-05-26 22:17:51
export PATH="$HOME/.local/bin:$PATH"

autoload -U bashcompinit
bashcompinit

# remove duplicate entries from $PATH and $FPATH
typeset -U PATH
typeset -U FPATH
