if [ -f /usr/local/share/antigen/antigen.zsh ]; then
  source /usr/local/share/antigen/antigen.zsh

  antigen use oh-my-zsh

  # use these oh-my-zsh plugins
  antigen bundle git
  antigen bundle git-extras
  antigen bundle wd
  antigen bundle bundler
  antigen bundle brew
  antigen bundle capistrano
  antigen bundle jump
  antigen bundle rbenv
  antigen bundle osx
  antigen bundle gem
  antigen bundle rails
  antigen bundle golang
  antigen bundle gpg-agent
  antigen bundle web-search
  antigen bundle rust
  antigen bundle cargo
  antigen bundle z

  # use these non-oh-my-zsh plugins
  antigen bundle djui/alias-tips
  antigen bundle srijanshetty/zsh-pandoc-completion
  antigen bundle andrewferrier/fzf-z

  antigen bundle /Users/masseya/.zsh_custom/plugins/jupyter-completions --no-local-clone

  # the order of this set of plugins is important
  antigen bundle mafredri/zsh-async
  # antigen theme akmassey/akmassey-zsh-theme
  antigen theme sindresorhus/pure
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle zsh-users/zsh-history-substring-search
  antigen bundle zsh-users/zsh-completions
  antigen bundle zsh-users/zsh-autosuggestions

  antigen apply
else
  echo "Unable to find antigen, so your shell could be missing some zsh plugins."
fi

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

