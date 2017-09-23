# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.zsh_custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="akmassey"
# ZSH_THEME="random"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-extras bundler brew brew-cask capistrano jump rbenv osx gem rails golang gpg-agent zsh-completions jupyter-completions history-substring-search zsh-autosuggestions web-search wd fzf-z rust cargo)

autoload -U compinit && compinit -D

# source your keychain prior to gpg-agent, which is done through a plugin
if [ -x /usr/local/bin/keychain ]; then
  # for Mac OS X only
  eval "$(keychain --eval --inherit any id_rsa)"
fi

fpath=( $HOME/.zsh/functions "${fpath[@]}" )
autoload -Uz duck
autoload -Uz cdf
autoload -Uz lno
autoload -Uz loop
autoload -Uz mcd
autoload -Uz rule
autoload -Uz rulem
autoload -Uz sizeup
autoload -Uz o
autoload -Uz getcertnames

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Starting to find auto correct rather annoying...
unsetopt correct_all

# Load fzf configuration
[ -f ~/.zsh/fzf.zsh ] && source ~/.zsh/fzf.zsh

source ~/.zsh/init

# remove duplicate entries from $PATH and $FPATH
typeset -U PATH
typeset -U FPATH

# Print weather information
if [[ -e $HOME/.weather ]]; then
  cat $HOME/.weather
  echo "\n"
fi

# Print stock quotes
if [[ -e $HOME/.stocks ]]; then
  cat $HOME/.stocks
  echo "\n"
fi

# Print a quote
if type fortune > /dev/null 2>/dev/null; then
  myfortune
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
