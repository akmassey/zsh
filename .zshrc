# source keychain prior to anything
if [ -x $HOMEBREW_PREFIX/bin/keychain ]; then
  # for Mac OS X only
  eval "$(keychain --eval --inherit any id_rsa id_ed25519)"
fi

# Print weather information
if [[ -e $HOME/.weather && -x /bin/cat ]]; then
  /bin/cat $HOME/.weather
  echo "\n"
fi

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
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.zsh_custom

# Uncomment to enable profiling
# zmodload zsh/zprof

# TODO: install and setup Homebrew zsh

# Ensure the proper version of zsh functions are in your $FPATH
if [[ -d $HOMEBREW_PREFIX/Cellar/zsh/5.8_1/share/zsh/functions ]]; then
  export FPATH="$HOMEBREW_PREFIX/Cellar/zsh/5.8_1/share/zsh/functions:$FPATH"
else
  ZSH_V=$(zsh --version | cut -d ' ' -f 2)
  export FPATH="$HOMEBREW_PREFIX/Cellar/zsh/$ZSH_V/share/zsh/functions:$FPATH"
  # echo "Using zsh version: $ZSH_V"
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="spaceship"
ZSH_THEME="powerlevel10k/powerlevel10k"

# SPACESHIP_USER_SHOW="always"
# SPACESHIP_HOST_SHOW="always"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
plugins=(
  evalcache
  zsh-nvm
  zsh-completions
  zsh-autosuggestions
  zsh-interactive-cd
  gitfast
  bundler
  brew
  fd
  rbenv
  pyenv
  # poetry
  macos
  gem
  # rails
  golang
  # gpg-agent
  wd
  z
  fzf-z
  rust
  # rustup
  # cargo
  npm
)

# Here are some oh-my-zsh plugins that I used to use and may need to go back
# to using in the future:
#     xcode
#     kubectl
#     jupyter-completions
#     history-substring-search

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
autoload -Uz p
autoload -Uz timezsh
autoload -Uz getcertnames

# Initialize the completion system
autoload -Uz compinit

# Cache completion if nothing changed - faster startup time
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# Enhanced form of menu completion called `menu selection'
zmodload -i zsh/complist

source $ZSH/oh-my-zsh.sh

# Starting to find autocorrect rather annoying...
unsetopt correct_all

# Load fzf configuration
[ -f ~/.zsh/fzf.zsh ] && source ~/.zsh/fzf.zsh

source ~/.zsh/init

# Needed at least temporarily to resolve a bug: https://github.com/zsh-users/zsh-autosuggestions/issues/422
typeset -g ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE='20'

# remove duplicate entries from $PATH and $FPATH
typeset -U PATH
typeset -U FPATH

# eval "$(starship init zsh)"

# Ensure the PATH environment variable is unique
typeset -U PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
