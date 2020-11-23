# Path to your oh-my-zsh installation.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.zsh_custom

# Ensure the proper version of zsh functions are in your $FPATH
if [[ -d /usr/local/Cellar/zsh/5.8_1/share/zsh/functions ]]; then
  export FPATH="/usr/local/Cellar/zsh/5.8_1/share/zsh/functions:$FPATH"
else
  ZSH_V=$(zsh --version | cut -d ' ' -f 2)
  export FPATH="/usr/local/Cellar/zsh/$ZSH_V/share/zsh/functions:$FPATH"
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"

SPACESHIP_USER_SHOW="always"
SPACESHIP_HOST_SHOW="always"

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
plugins=(
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
  git
  git-extras
  gitfast
  bundler
  brew
  fd
  rbenv
  osx
  gem
  rails
  capistrano
  golang
  gpg-agent
  jupyter-completions
  history-substring-search
  wd
  z
  fzf-z
  rust
  rustup
  cargo
  kubectl
  xcode
  zsh_reload
)

# source keychain prior to gpg-agent, which is done through a plugin
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

autoload -Uz compinit && compinit -D

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
  $HOME/bin/monitor-sites
  echo "\n"
fi

# Print a quote
if type fortune > /dev/null 2>/dev/null; then
  myfortune
fi

test -e /Users/masseya/.zsh/iterm2_shell_integration.zsh && source /Users/masseya/.zsh/iterm2_shell_integration.zsh || true
