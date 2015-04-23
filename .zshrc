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
plugins=(git bundler brew brew-cask capistrano jump rbenv osx gem rails golang vundle z)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Source your Keychain.
if [ -x /usr/local/bin/keychain ]; then
  eval "$(keychain ~/.ssh/id_rsa)"
fi


# Starting to find auto correct rather annoying...
unsetopt correct_all

source ~/.zsh/aliases
source ~/.zsh/functions/*

myfortune

export EDITOR=/usr/bin/vim

# used by git-latexdiff
export PDFVIEWER=/Applications/Skim.app/Contents/MacOS/Skim

# ensure HTML Tidy uses your configuration file
export HTML_TIDY=$HOME/.tidyrc

# rbenv configuration
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export RBENV_ROOT=/usr/local/opt/rbenv

# Settings for Go Programming
# http://stackoverflow.com/questions/12843063/install-go-with-brew-and-running-the-gotour
#export GOVERSION="1.1.2"
#export GOROOT=$(brew --prefix)/Cellar/go/$GOVERSION
#export GOPATH=$(brew --prefix)/Cellar/go/$GOVERSION/bin:$HOME/src/go
export GOPATH=$HOME/src/go

# ensure Homebrew is in your PATH
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/lib:$PATH

